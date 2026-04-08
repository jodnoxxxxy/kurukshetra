from fastapi import FastAPI, HTTPException, UploadFile, File
from pydantic import BaseModel
import os
import sys
import uvicorn

# Add models to path
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))
from models.crop_recommendation import CropRecommender
from models.disease_detection import DiseaseDetector
from models.yield_prediction import YieldPredictor
from models.weather_analysis import WeatherSmartAnalyzer

app = FastAPI(title="Kurukshetra AI Engine API")

# Initialize models
recommender = CropRecommender()
detector = DiseaseDetector()
predictor = YieldPredictor()
analyzer = WeatherSmartAnalyzer()

class CropRecRequest(BaseModel):
    n: int
    p: int
    k: int
    temperature: float
    humidity: float
    ph: float
    rainfall: float

class YieldRequest(BaseModel):
    crop: str
    area: float
    temperature: float
    rainfall: float
    fertilizer: float

class WeatherRequest(BaseModel):
    crop: str
    forecast: list

@app.get("/")
def read_root():
    return {"status": "ok", "message": "Kurukshetra AI Engine is running"}

@app.post("/predict/crop-recommendation")
def predict_crop(req: CropRecRequest):
    try:
        result = recommender.predict(req.n, req.p, req.k, req.temperature, req.humidity, req.ph, req.rainfall)
        return {"success": True, "data": {"recommendation": result}}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/predict/yield")
def predict_yield(req: YieldRequest):
    try:
        result = predictor.predict(req.crop, req.area, req.temperature, req.rainfall, req.fertilizer)
        return {"success": True, "data": {"predicted_yield": result, "unit": "quintals"}}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/predict/disease")
async def predict_disease(image: UploadFile = File(...)):
    try:
        # Save temp file
        temp_path = f"temp_{image.filename}"
        with open(temp_path, "wb") as f:
            f.write(await image.read())
        
        result = detector.predict(temp_path)
        os.remove(temp_path) # Clean up
        
        return {"success": True, "data": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.post("/analyze/weather-suggestions")
def analyze_weather(req: WeatherRequest):
    try:
        result = analyzer.analyze_conditions(req.forecast, req.crop)
        return {"success": True, "data": result}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)
