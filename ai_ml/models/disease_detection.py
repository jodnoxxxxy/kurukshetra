import tensorflow as tf
from tensorflow.keras import layers, models
import numpy as np
import os
import cv2

class DiseaseDetector:
    def __init__(self):
        self.model = None
        self.model_path = os.path.join(os.path.dirname(__file__), 'disease_detector.h5')
        self.classes = ['Healthy', 'Bacterial_Leaf_Spot', 'Black_Rot', 'Late_Blight', 'Powdery_Mildew', 
                        'Septoria_Leaf_Spot', 'Spider_Mites', 'Target_Spot', 'Yellow_Leaf_Curl_Virus', 'Mosaic_Virus']

    def train(self, data_dir, image_size=(128, 128), epochs=10):
        """
        Trains the disease detection model using a folder of images.
        Expected data_dir follows 'class_name/image.jpg' structure.
        """
        if not os.path.exists(data_dir):
            print(f"Data directory {data_dir} not found. Training with dummy model for example.")
            self._train_dummy(image_size)
            return

        train_ds = tf.keras.preprocessing.image_dataset_from_directory(
            data_dir,
            validation_split=0.2,
            subset="training",
            seed=123,
            image_size=image_size,
            batch_size=32
        )

        val_ds = tf.keras.preprocessing.image_dataset_from_directory(
            data_dir,
            validation_split=0.2,
            subset="validation",
            seed=123,
            image_size=image_size,
            batch_size=32
        )

        self.model = models.Sequential([
            layers.Rescaling(1./255, input_shape=(image_size[0], image_size[1], 3)),
            layers.Conv2D(32, 3, activation='relu'),
            layers.MaxPooling2D(),
            layers.Conv2D(64, 3, activation='relu'),
            layers.MaxPooling2D(),
            layers.Conv2D(128, 3, activation='relu'),
            layers.MaxPooling2D(),
            layers.Flatten(),
            layers.Dense(128, activation='relu'),
            layers.Dense(len(self.classes), activation='softmax')
        ])

        self.model.compile(optimizer='adam',
                           loss='sparse_categorical_crossentropy',
                           metrics=['accuracy'])

        self.model.fit(train_ds, validation_data=val_ds, epochs=epochs)
        
        self.model.save(self.model_path)

    def _train_dummy(self, image_size):
        """Generates a dummy model with random weights for demonstration."""
        self.model = models.Sequential([
            layers.Rescaling(1./255, input_shape=(image_size[0], image_size[1], 3)),
            layers.Conv2D(8, 3, activation='relu'),
            layers.Flatten(),
            layers.Dense(len(self.classes), activation='softmax')
        ])
        self.model.compile(optimizer='adam', loss='sparse_categorical_crossentropy')
        self.model.save(self.model_path)

    def predict(self, image_path):
        """Predicts the disease from an image path."""
        if self.model is None:
            if os.path.exists(self.model_path):
                self.model = models.load_model(self.model_path)
            else:
                self._train_dummy((128, 128))

        # Load and preprocess image
        image = cv2.imread(image_path)
        image = cv2.resize(image, (128, 128))
        image = np.expand_dims(image, axis=0) # Add batch dimension

        predictions = self.model.predict(image)
        predicted_class = self.classes[np.argmax(predictions[0])]
        confidence = float(np.max(predictions[0]))

        return {
            "disease": predicted_class,
            "confidence": round(confidence, 2)
        }

if __name__ == "__main__":
    detector = DiseaseDetector()
    # To train properly, provide a real dataset directory:
    # detector.train('path/to/leaf_images/')
    
    # Test prediction
    # print(detector.predict('path/to/test_leaf.jpg'))
