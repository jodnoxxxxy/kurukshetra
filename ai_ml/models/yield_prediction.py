import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_squared_error, r2_score
import pickle
import os

class YieldPredictor:
    def __init__(self):
        self.model = None
        self.model_path = os.path.join(os.path.dirname(__file__), 'yield_predictor.pkl')

    def train(self, data_path):
        """
        Trains the yield prediction model using a dataset.
        Expected columns: crop, area, temperature, rainfall, fertilizer, label (yield in quintals)
        """
        if not os.path.exists(data_path):
            print(f"Dataset not found at {data_path}. Training with dummy data.")
            self._train_dummy()
            return

        df = pd.read_csv(data_path)
        # Handle categorical data (crop type)
        df_encoded = pd.get_dummies(df, columns=['crop'])

        X = df_encoded.drop('label', axis=1)
        y = df_encoded['label']

        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        self.model = RandomForestRegressor(n_estimators=100, random_state=42)
        self.model.fit(X_train, y_train)

        y_pred = self.model.predict(X_test)
        print(f"R2 Score: {r2_score(y_test, y_pred):.2f}")

        with open(self.model_path, 'wb') as f:
            pickle.dump(self.model, f)

    def _train_dummy(self):
        """Generates dummy data for training if no dataset is provided."""
        crops = ['paddy', 'wheat', 'maize', 'cotton', 'soybean', 'sugarcane']
        
        data = []
        for _ in range(500):
            crop = np.random.choice(crops)
            area = np.random.uniform(0.5, 20.0) # hectares
            temp = np.random.uniform(15, 35) # avg temp
            rain = np.random.uniform(500, 2500) # mm
            fert = np.random.uniform(50, 500) # kg
            # Roughly calculate yield based on inputs + noise
            y_val = (area * 20.0) + (temp * 1.5) + (fert * 0.05) + np.random.normal(0, 10)
            data.append([crop, area, temp, rain, fert, max(y_val, 0)])
        
        df = pd.DataFrame(data, columns=['crop', 'area', 'temperature', 'rainfall', 'fertilizer', 'label'])
        df_encoded = pd.get_dummies(df, columns=['crop'])
        
        X = df_encoded.drop('label', axis=1)
        y = df_encoded['label']
        
        self.model = RandomForestRegressor(n_estimators=50, random_state=42)
        self.model.fit(X, y)
        
        with open(self.model_path, 'wb') as f:
            pickle.dump(self.model, f)

    def predict(self, crop, area, temperature, rainfall, fertilizer):
        """Predicts the yield based on crop type and environmental conditions."""
        if self.model is None:
            if os.path.exists(self.model_path):
                with open(self.model_path, 'rb') as f:
                    self.model = pickle.load(f)
            else:
                self._train_dummy()

        # Create input features, including one-hot encoding for the specified crop
        crops = ['paddy', 'wheat', 'maize', 'cotton', 'soybean', 'sugarcane']
        input_dict = {
            'area': area,
            'temperature': temperature,
            'rainfall': rainfall,
            'fertilizer': fertilizer
        }

        for c in crops:
            input_dict[f'crop_{c}'] = 1 if c == crop else 0

        input_df = pd.DataFrame([input_dict])
        
        # Ensure correct column ordering based on training
        # This is a basic implementation; a more robust approach uses a pipeline for preprocessing
        prediction = self.model.predict(input_df)
        return round(prediction[0], 2)

if __name__ == "__main__":
    predictor = YieldPredictor()
    # To train properly, provide a real dataset:
    # predictor.train('path/to/yield_data_india.csv')
    
    # Test prediction
    result = predictor.predict('paddy', 5.0, 28.0, 1200.0, 300.0)
    print(f"Predicted Yield: {result} quintals")
