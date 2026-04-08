import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
import pickle
import os

class CropRecommender:
    def __init__(self):
        self.model = None
        self.model_path = os.path.join(os.path.dirname(__file__), 'crop_recommender.pkl')

    def train(self, data_path):
        """
        Trains the crop recommendation model using a dataset.
        Expected columns: N, P, K, temperature, humidity, ph, rainfall, label
        """
        if not os.path.exists(data_path):
            print(f"Dataset not found at {data_path}. Training with dummy data.")
            self._train_dummy()
            return

        df = pd.read_csv(data_path)
        X = df[['N', 'P', 'K', 'temperature', 'humidity', 'ph', 'rainfall']]
        y = df['label']

        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

        self.model = RandomForestClassifier(n_estimators=100, random_state=42)
        self.model.fit(X_train, y_train)

        y_pred = self.model.predict(X_test)
        print(f"Model Accuracy: {accuracy_score(y_test, y_pred):.2f}")

        with open(self.model_path, 'wb') as f:
            pickle.dump(self.model, f)

    def _train_dummy(self):
        """Generates dummy data for training if no dataset is provided."""
        crops = ['Rice', 'Maize', 'Chickpea', 'Kidneybeans', 'Pigeonpeas', 'Mothbeans', 'Mungbean', 
                 'Blackgram', 'Lentil', 'Pomegranate', 'Banana', 'Mango', 'Grapes', 'Watermelon', 
                 'Muskmelon', 'Apple', 'Orange', 'Papaya', 'Coconut', 'Cotton', 'Jute', 'Coffee']
        
        data = []
        for _ in range(1000):
            n = np.random.randint(0, 140)
            p = np.random.randint(5, 145)
            k = np.random.randint(5, 205)
            temp = np.random.uniform(10, 45)
            hum = np.random.uniform(15, 100)
            ph = np.random.uniform(3.5, 10)
            rain = np.random.uniform(20, 300)
            label = np.random.choice(crops)
            data.append([n, p, k, temp, hum, ph, rain, label])
        
        df = pd.DataFrame(data, columns=['N', 'P', 'K', 'temperature', 'humidity', 'ph', 'rainfall', 'label'])
        
        X = df[['N', 'P', 'K', 'temperature', 'humidity', 'ph', 'rainfall']]
        y = df['label']
        
        self.model = RandomForestClassifier(n_estimators=50, random_state=42)
        self.model.fit(X, y)
        
        with open(self.model_path, 'wb') as f:
            pickle.dump(self.model, f)

    def predict(self, n, p, k, temperature, humidity, ph, rainfall):
        """Predicts the best crop based on soil and weather conditions."""
        if self.model is None:
            if os.path.exists(self.model_path):
                with open(self.model_path, 'rb') as f:
                    self.model = pickle.load(f)
            else:
                self._train_dummy()

        input_data = np.array([[n, p, k, temperature, humidity, ph, rainfall]])
        prediction = self.model.predict(input_data)
        return prediction[0]

if __name__ == "__main__":
    recommender = CropRecommender()
    # To train properly, provide a real dataset:
    # recommender.train('path/to/crop_recommendation_dataset.csv')
    
    # Test prediction
    result = recommender.predict(90, 42, 43, 20.8, 82.0, 6.5, 202.9)
    print(f"Recommended Crop: {result}")
