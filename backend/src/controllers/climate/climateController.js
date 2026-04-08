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

    if (process.env.OPENWEATHER_API_KEY && lat && lon) {
        try {
            const url = `https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${process.env.OPENWEATHER_API_KEY}&units=metric`;
            const response = await fetch(url);
            const data = await response.json();
            
            if (data.main) {
                rawData = {
                    temperature: data.main.temp,
                    humidity: data.main.humidity,
                    windSpeed: data.wind.speed * 3.6, // Convert m/s to km/h
                    rainfall: (data.rain && data.rain['1h']) ? data.rain['1h'] : 0.0,
                    source: 'api'
                };
            }
        } catch(apiKeyError) {
             console.log("Failed to fetch real data, using fallback mocks");
        }
    }
    return rawData;
};

// Logic Layer: Risk Analysis Engine
const analyzeClimateRisk = (weatherData, staticData = { soilType: 'Loamy', season: 'Kharif' }) => {
    let riskScore = 0;
    
    // Low Risk factors out by default
    let analysis = {
        level: 'Low',
        score: riskScore,
        details: []
    };

    if (weatherData.rainfall > 30.0) {
        riskScore += 3; // High risk weight
        analysis.details.push('Flood Risk');
    }
    if (weatherData.temperature > 36.0) {
        riskScore += 2; // Medium-High risk weight
        analysis.details.push('Heat Risk');
    }
    if (weatherData.humidity < 30.0) {
        riskScore += 2; // Medium-High risk weight
        analysis.details.push('Drought Risk');
    }
    if (weatherData.windSpeed > 40) {
        riskScore += 1;
        analysis.details.push('High Wind Risk');
    }

    if (riskScore >= 3) {
        analysis.level = 'High';
    } else if (riskScore >= 1) {
        analysis.level = 'Medium';
    } else {
        analysis.level = 'Low';
    }
    
    analysis.score = riskScore;
    return analysis;
};

// Generate Output: Alerts & Advisory Rules
const generateAlertsAndAdvisory = (riskAnalysis, weatherData) => {
    let alerts = [];
    let advisories = [];

    // ONLY generate alerts based on specific risks
    if (riskAnalysis.details.includes('Flood Risk')) {
        alerts.push({ type: 'Flood Alert', message: 'Heavy rain expected. Avoid irrigation today and secure equipment.', severity: 'High' });
        advisories.push('Improve drainage systems immediately to prevent waterlogging.');
        advisories.push('Postpone fertilizer application until rain stops.');
    }
    
    if (riskAnalysis.details.includes('Heat Risk')) {
        alerts.push({ type: 'Heat Stress', message: 'High temperature expected, risk of crop stress.', severity: 'Medium' });
        advisories.push('Apply mulching to retain soil moisture.');
        advisories.push('Schedule irrigation during cooler evening or early morning hours.');
        advisories.push('Use shade nets for sensitive crops and nursery beds.');
    }
    
    if (riskAnalysis.details.includes('Drought Risk')) {
        alerts.push({ type: 'Drought Warning', message: 'Very low humidity and dry air.', severity: 'Medium' });
        advisories.push('Increase irrigation frequency slightly to maintain soil moisture.');
        advisories.push('Implement drought-resistant practices and reduce chemical inputs.');
    }

    if (riskAnalysis.details.includes('High Wind Risk')) {
        alerts.push({ type: 'Wind Alert', message: 'Strong winds expected, secure light structures.', severity: 'Medium' });
    }

    // Default favorable condition
    if (riskAnalysis.level === 'Low') {
        advisories.push('Conditions are favorable for normal farming activities.');
        advisories.push('Continue standard fertilizer and pesticide schedules.');
        advisories.push('Maintain regular soil monitoring.');
    }

    return { alerts, advisories };
};

exports.getAdvisory = async (req, res) => {
    try {
        const { lat, lon, soilType, season } = req.query;
        
        // 1. Data Input & Fetch Data
        const weatherData = await fetchWeatherData(lat, lon);
        
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
                },
                riskAnalysis: {
                    level: riskAnalysis.level,
                    score: riskAnalysis.score
                },
                smartAlerts: alerts,
                advisorySuggestions: advisories
            }
        });
        
    } catch (error) {
        console.error("Error generating climate advisory:", error);
        res.status(500).json({ success: false, message: 'Failed to fetch climate advisory' });
    }
};