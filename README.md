# Kurukshetra 🌾

A modern, high-fidelity agriculture platform designed to empower Indian farmers with AI-driven insights, marketplace access, and educational resources.

## 🚀 Features

- **Shetishala (Learning Hub)**: Interactive video tutorials and training modules for modern farming techniques.
- **AI Advisory**: Soil health analysis, pest detection using image recognition, and localized crop recommendations.
- **Farmer Dashboard**: Real-time monitoring of farm health, weather alerts, and market price tracking.
- **Support Assistant**: An integrated AI-powered help desk for instant agriculture expert guidance.
- **Marketplace**: Seamless management of orders and sales for farm produce.

## 🛠️ Technology Stack

- **Frontend**: Flutter (Material 3)
- **State Management**: Riverpod 3.x (Notifier Pattern)
- **Navigation**: GoRouter
- **Backend**: Node.js & Firebase
- **Networking**: Dio with specialized AI repository patterns

## 📦 Project Structure

```text
lib/
├── core/          # Shared themes, constants, networking, and utilities
├── features/      # Feature-based architecture (AI, Market, Shetishala, etc.)
│   ├── ai/        # AI Service Implementations (Pest, Soil, Crop)
│   ├── learn/     # Shetishala learning module
│   ├── profile/   # User profile and business management
│   └── navigation/# Global navigation and shared drawer
└── l10n/          # Multi-language localization support
```

## 🏗️ Getting Started

1.  **Clone the repository**.
2.  **Environment Setup**: Ensure Flutter is installed and developer mode is enabled for Windows symlink support.
3.  **Install Dependencies**:
    ```bash
    flutter pub get
    ```
4.  **Run the App**:
    ```bash
    flutter run -d chrome
    ```

## 📄 Documentation

- [Architecture Overview](docs/ARCHITECTURE.md)
- [Project Checklist](docs/CHECKLIST.md)

---
*Empowering the backbone of India with Kurukshetra.*
