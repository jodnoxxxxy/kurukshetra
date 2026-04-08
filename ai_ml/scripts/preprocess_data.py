import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, LabelEncoder
import os

class DataProcessor:
    def __init__(self):
        self.scaler = StandardScaler()
        self.label_encoder = LabelEncoder()

    def process_agricultural_data(self, data_path, output_path=None):
        """Processes raw agricultural data for model consumption."""
        if not os.path.exists(data_path):
            print(f"Data file {data_path} not found.")
            return None

        df = pd.read_csv(data_path)
        print(f"Original shape: {df.shape}")

        # Handle missing values
        df = df.fillna(df.mean(numeric_only=True))
        
        # Remove outliers using IQR
        numeric_cols = df.select_dtypes(include=[np.number]).columns
        for col in numeric_cols:
            Q1 = df[col].quantile(0.25)
            Q3 = df[col].quantile(0.75)
            IQR = Q3 - Q1
            lower_bound = Q1 - 1.5 * IQR
            upper_bound = Q3 + 1.5 * IQR
            df = df[(df[col] >= lower_bound) & (df[col] <= upper_bound)]

        # Feature engineering
        if 'temperature' in df.columns and 'humidity' in df.columns:
            # Heat index or similar proxy
            df['stress_index'] = df['temperature'] * (df['humidity'] / 100)

        print(f"Processed shape: {df.shape}")
        
        if output_path:
            df.to_csv(output_path, index=False)
            print(f"Saved processed data to {output_path}")

        return df

    def prepare_datasets_for_training(self, df, label_col):
        """Splits data into features and target, performs scaling."""
        X = df.drop(label_col, axis=1)
        y = df[label_col]

        # Handle categorical columns
        categorical_cols = X.select_dtypes(include=['object']).columns
        if not categorical_cols.empty:
            X = pd.get_dummies(X, columns=categorical_cols)

        X_scaled = self.scaler.fit_transform(X)
        return X_scaled, y

if __name__ == "__main__":
    processor = DataProcessor()
    # Mock usage:
    # processor.process_agricultural_data('data/raw/sensor_readings.csv', 'data/processed/sensor_readings.csv')
    print("DataProcessor script ready.")
