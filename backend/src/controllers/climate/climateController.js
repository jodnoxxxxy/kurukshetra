const axios = require('axios'); // Optional dependency if installed

// Services for fetching data
const fetchWeatherData = async (lat, lon) => {
    let rawData = {
        temperature: 32.5,
        rainfall: 0.0,
        humidity: 45,
        windSpeed: 15,
        source: 'mock'
    };

    // Only attempt API call if API key and coordinates are valid
    if (process.env.OPENWEATHER_API_KEY && lat && lon) {
        try {
            const timeoutPromise = new Promise((_, reject) =>
                setTimeout(() => reject(new Error('API request timeout')), 10000)
            );

            const url = `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${process.env.OPENWEATHER_API_KEY}&units=metric`;
            
            const fetchPromise = fetch(url);
            const response = await Promise.race([fetchPromise, timeoutPromise]);
            
            if (!response.ok) {
                throw new Error(`API returned status ${response.status}`);
            }
            
            const data = await response.json();
            
            // VALIDATE API response has required fields
            if (!data.main || data.main.temp === undefined) {
                throw new Error('Invalid API response: missing temperature data');
            }
            
            rawData = {
                temperature: parseFloat(data.main.temp) || 32.5,
                humidity: parseFloat(data.main.humidity) || 45,
                windSpeed: (parseFloat(data.wind?.speed || 0) * 3.6) || 15, // Convert m/s to km/h
                rainfall: (data.rain && parseFloat(data.rain['1h'])) ? parseFloat(data.rain['1h']) : 0.0,
                source: 'api'
            };
            
            // VALIDATE extracted values are within realistic ranges
            if (rawData.temperature < -50 || rawData.temperature > 60) {
                console.warn('Temperature out of range, using fallback');
                rawData.temperature = 32.5;
            }
            if (rawData.humidity < 0 || rawData.humidity > 100) {
                console.warn('Humidity out of range, using fallback');
                rawData.humidity = 45;
            }
        } catch(apiError) {
             console.log("Failed to fetch weather from API:", apiError.message);
             console.log("Using fallback mock data");
        }
    }
    
    return rawData;
};

// Logic Layer: Risk Analysis Engine (IMPROVED)
const analyzeClimateRisk = (weatherData, staticData = { soilType: 'Loamy', season: 'Kharif' }) => {
    // EDGE CASE: Handle missing or null data
    if (!weatherData || !weatherData.temperature) {
        return {
            level: 'Unknown',
            score: 0,
            details: []
        };
    }
    
    let riskScore = 0;
    let analysis = {
        level: 'Low',
        score: riskScore,
        details: []
    };

    const { temperature, humidity, rainfall, windSpeed } = weatherData;
    const { season } = staticData;

    // RULE-BASED RISK ANALYSIS

    // FLOOD RISK (Very High Impact)
    if (rainfall > 30.0) {
        riskScore += 3;
        analysis.details.push('Flood Risk');
    }
    if (rainfall > 100.0) {
        riskScore += 2; // Additional penalty for extreme rain
        analysis.details.push('Extreme Rainfall Risk');
    }

    // HEAT RISK
    if (temperature > 40.0) {
        riskScore += 3; // Severe heat
        analysis.details.push('Severe Heat Risk');
    } else if (temperature > 36.0) {
        riskScore += 2;
        analysis.details.push('Heat Risk');
    }

    // FROST/COLD RISK (Season dependent)
    if (temperature < 0 && season !== 'Summer') {
        riskScore += 2;
        analysis.details.push('Frost Risk');
    }
    if (temperature < -5) {
        riskScore += 2;
        analysis.details.push('Extreme Cold Risk');
    }

    // DROUGHT RISK
    if (humidity < 20.0) {
        riskScore += 3; // Severe drought
        analysis.details.push('Severe Drought Risk');
    } else if (humidity < 30.0) {
        riskScore += 2;
        analysis.details.push('Drought Risk');
    }

    // WIND DAMAGE RISK
    if (windSpeed > 60) {
        riskScore += 3; // Storm level winds
        analysis.details.push('Storm Risk');
    } else if (windSpeed > 40) {
        riskScore += 2;
        analysis.details.push('High Wind Risk');
    }

    // DISEASE PRESSURE RISK (High temp + high humidity)
    if (temperature > 25 && humidity > 80) {
        riskScore += 1;
        analysis.details.push('High Disease Pressure Risk');
    }

    // Determine risk level based on weighted score
    if (riskScore >= 4) {
        analysis.level = 'High';
    } else if (riskScore >= 2) {
        analysis.level = 'Medium';
    } else {
        analysis.level = 'Low';
    }
    
    analysis.score = riskScore;
    return analysis;
};

// Generate Output: Alerts & Advisory Rules (IMPROVED)
const generateAlertsAndAdvisory = (riskAnalysis, weatherData) => {
    let alerts = [];
    let advisories = [];

    // CRITICAL CONDITIONS
    if (riskAnalysis.details.includes('Extreme Rainfall Risk')) {
        alerts.push({ 
            type: 'CRITICAL: Extreme Rainfall', 
            message: 'Severe flooding risk. Evacuate low-lying areas and secure all equipment immediately.', 
            severity: 'Critical' 
        });
        advisories.push('SUSPEND all farming operations until flooding subsides.');
        advisories.push('Open drainage channels and clear blockages to prevent waterlogging.');
        advisories.push('Do NOT apply any inputs - they will be washed away.');
        advisories.push('Check livestock and move to higher ground if necessary.');
    } else if (riskAnalysis.details.includes('Flood Risk')) {
        alerts.push({ 
            type: 'Flood Alert', 
            message: 'Heavy rain expected. Avoid irrigation today and secure equipment.', 
            severity: 'High' 
        });
        advisories.push('Improve drainage systems immediately to prevent waterlogging.');
        advisories.push('Postpone fertilizer and pesticide application until rain stops.');
        advisories.push('Secure all lightweight structures and equipment.');
    }
    
    // HEAT STRESS
    if (riskAnalysis.details.includes('Severe Heat Risk')) {
        alerts.push({ 
            type: 'CRITICAL: Extreme Heat', 
            message: 'Severe heat expected. Risk of total crop failure.', 
            severity: 'Critical' 
        });
        advisories.push('Apply heavy mulch (5-10 cm) to protect soil and retain moisture.');
        advisories.push('Increase irrigation frequency to 2-3 times daily.');
        advisories.push('Use shade nets (30-50%) for sensitive crops and nurseries.');
        advisories.push('Spray plants with water in early morning to cool them.');
        advisories.push('Defer harvesting to cooler hours (5-9 AM).');
    } else if (riskAnalysis.details.includes('Heat Risk')) {
        alerts.push({ 
            type: 'Heat Stress', 
            message: 'High temperature expected, risk of crop stress.', 
            severity: 'High' 
        });
        advisories.push('Apply mulching to retain soil moisture.');
        advisories.push('Schedule irrigation during cooler evening or early morning hours.');
        advisories.push('Use shade nets for sensitive crops and nursery beds.');
    }
    
    // FROST/COLD RISK
    if (riskAnalysis.details.includes('Extreme Cold Risk')) {
        alerts.push({ 
            type: 'CRITICAL: Frost/Freeze', 
            message: 'Extreme cold expected. Frost will kill most crops.', 
            severity: 'Critical' 
        });
        advisories.push('Cover sensitive plants with plastic sheets or straw immediately.');
        advisories.push('Set up frost protection systems (heaters, sprinklers).');
        advisories.push('Do NOT plant tender crops - wait for temperature recovery.');
        advisories.push('Harvest any ripe produce before frost arrives.');
    } else if (riskAnalysis.details.includes('Frost Risk')) {
        alerts.push({ 
            type: 'Frost Alert', 
            message: 'Frost expected. Protect sensitive crops.', 
            severity: 'Medium' 
        });
        advisories.push('Cover sensitive plants with frost cloth or mulch.');
        advisories.push('Avoid pruning just before frost.');
    }
    
    // DROUGHT RISK
    if (riskAnalysis.details.includes('Severe Drought Risk')) {
        alerts.push({ 
            type: 'CRITICAL: Severe Drought', 
            message: 'Extreme dry conditions. Water stress will be severe.', 
            severity: 'Critical' 
        });
        advisories.push('Implement drip irrigation immediately if available.');
        advisories.push('Increase irrigation frequency to daily or twice-daily.');
        advisories.push('Apply thick mulch (8-10 cm) to conserve soil moisture.');
        advisories.push('Reduce or suspend chemical applications.');
        advisories.push('Prioritize water to high-value crops.');
    } else if (riskAnalysis.details.includes('Drought Risk')) {
        alerts.push({ 
            type: 'Drought Warning', 
            message: 'Very low humidity and dry air.', 
            severity: 'Medium' 
        });
        advisories.push('Increase irrigation frequency slightly to maintain soil moisture.');
        advisories.push('Implement drought-resistant practices and reduce chemical inputs.');
    }

    // WIND DAMAGE
    if (riskAnalysis.details.includes('Storm Risk')) {
        alerts.push({ 
            type: 'CRITICAL: Storm Conditions', 
            message: 'Severe storm winds expected. Risk of widespread crop damage.', 
            severity: 'Critical' 
        });
        advisories.push('Secure or remove all loose equipment immediately.');
        advisories.push('Support tall plants with staking or bracing.');
        advisories.push('Do NOT spray pesticides - wind will carry them incorrectly.');
        advisories.push('Stay indoors during the storm.');
    } else if (riskAnalysis.details.includes('High Wind Risk')) {
        alerts.push({ 
            type: 'Wind Alert', 
            message: 'Strong winds expected, secure light structures.', 
            severity: 'Medium' 
        });
        advisories.push('Secure all lightweight structures and equipment.');
        advisories.push('Do NOT spray pesticides or fertilizers.');
    }

    // DISEASE PRESSURE
    if (riskAnalysis.details.includes('High Disease Pressure Risk')) {
        alerts.push({ 
            type: 'Disease Pressure', 
            message: 'Warm and humid - conditions ideal for fungal/bacterial diseases.', 
            severity: 'Medium' 
        });
        advisories.push('Scout plants daily for disease symptoms.');
        advisories.push('Apply preventive fungicides if not already done.');
        advisories.push('Ensure proper spacing for air circulation.');
        advisories.push('Avoid overhead irrigation.');
    }

    // DEFAULT FAVORABLE CONDITION
    if (riskAnalysis.level === 'Low' && riskAnalysis.details.length === 0) {
        advisories.push('✓ Conditions are favorable for normal farming activities.');
        advisories.push('✓ Continue standard fertilizer and pesticide schedules.');
        advisories.push('✓ Maintain regular soil and crop monitoring.');
        advisories.push('✓ Good time for planting or transplanting if scheduled.');
    }

    return { alerts, advisories };
};

exports.getAdvisory = async (req, res) => {
    try {
        const { lat, lon, soilType, season } = req.query;
        
        // DATA VALIDATION: Check required parameters
        if (!lat || !lon) {
            return res.status(400).json({
                success: false,
                message: 'Invalid request. Latitude and longitude are required.',
                code: 'MISSING_GEOLOCATION'
            });
        }
        
        // Validate latitude and longitude ranges
        const latitude = parseFloat(lat);
        const longitude = parseFloat(lon);
        
        if (isNaN(latitude) || isNaN(longitude) || latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) {
            return res.status(400).json({
                success: false,
                message: 'Invalid latitude or longitude coordinates.',
                code: 'INVALID_COORDINATES'
            });
        }
        
        // 1. Data Input & Fetch Data
        const weatherData = await fetchWeatherData(latitude, longitude);
        
        // HANDLE NULL/MISSING WEATHER DATA
        if (!weatherData || !weatherData.temperature) {
            return res.status(503).json({
                success: false,
                message: 'Weather service unavailable. Unable to fetch climate data.',
                code: 'WEATHER_SERVICE_ERROR'
            });
        }
        
        // 2. Process Data & Analyze Risk
        const staticData = { soilType: soilType || 'Loamy', season: season || 'Kharif' };
        const riskAnalysis = analyzeClimateRisk(weatherData, staticData);
        
        // 3. Generate Output (Alerts & Advisory)
        const { alerts, advisories } = generateAlertsAndAdvisory(riskAnalysis, weatherData);

        // 4. Send Response to UI Layer
        res.status(200).json({
            success: true,
            data: {
                currentWeather: {
                    temperature: weatherData.temperature,
                    rainfall: weatherData.rainfall,
                    humidity: weatherData.humidity,
                    windSpeed: weatherData.windSpeed,
                    source: weatherData.source || 'mock'
                },
                riskAnalysis: {
                    level: riskAnalysis.level,
                    score: riskAnalysis.score,
                    identifiedRisks: riskAnalysis.details
                },
                smartAlerts: alerts,
                advisorySuggestions: advisories
            }
        });
        
    } catch (error) {
        console.error("Error generating climate advisory:", error);
        
        // Send appropriate error response based on error type
        if (error.message.includes('Location')) {
            return res.status(424).json({
                success: false,
                message: 'Location service error: ' + error.message,
                code: 'LOCATION_ERROR'
            });
        }
        
        res.status(500).json({
            success: false,
            message: 'Failed to fetch climate advisory. Please try again later.',
            code: 'INTERNAL_ERROR'
        });
    }
}