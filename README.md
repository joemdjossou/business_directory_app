# Business Directory App

A Flutter mini-app that displays a list of businesses with search functionality, detail screens, offline persistence, and robust state management using Provider and Dio.

## Features

- ✅ **Business List**: Display businesses with search functionality
- ✅ **Detail Screens**: Full business information with contact actions
- ✅ **Provider State Management**: Comprehensive state management with clear transitions
- ✅ **Dio Networking**: Network abstraction layer for future API integration
- ✅ **Reusable Components**: Generic BaseCard widget with composition pattern
- ✅ **Offline Persistence**: Local storage with SharedPreferences
- ✅ **Data Normalization**: Clean domain models from messy JSON keys
- ✅ **Error Handling**: Loading, empty, error, and retry states
- ✅ **Search Functionality**: Real-time search with debouncing
- ✅ **Accessibility**: Screen reader support and semantic labels

## Architecture

### State Management

- **Provider Pattern** for lightweight, testable state management
- Clear state transitions: `initial` → `loading` → `loaded/error/empty`
- Offline-first strategy with background refresh

### Data Layer

```
UI Layer (Widgets)
    ↓
Provider (State Management)
    ↓
Repository (Data Coordination)
    ↓
Services (API + Local Storage)
```

### Reusable Components

- `BaseCard<T>` - Generic abstract widget for any data type
- `BusinessCard` - Concrete implementation for Business model
- `ServiceCard` - Future implementation for Service model

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**

```bash
git clone <repository-url>
cd business_directory_app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Run the app**

```bash
flutter run
```

### Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Analyze code
flutter analyze
```

### Building

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# iOS (on macOS)
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart                          # App entry point with Provider setup
├── data/
│   ├── models/
│   │   ├── business.dart              # Business domain model
│   │   └── service.dart               # Service model (future)
│   ├── repositories/
│   │   └── business_repository.dart   # Data access layer
│   ├── services/
│   │   ├── api_service.dart          # Dio network service
│   │   └── local_storage_service.dart # SharedPreferences wrapper
│   └── local/
│       └── businesses.json           # Local data file
├── providers/
│   └── business_provider.dart        # State management
├── widgets/
│   ├── common/
│   │   ├── loading_widget.dart       # Loading states
│   │   ├── error_widget.dart         # Error states
│   │   └── empty_state_widget.dart   # Empty states
│   └── cards/
│       ├── base_card.dart            # Generic card base
│       ├── business_card.dart        # Business card implementation
│       └── service_card.dart         # Service card (future)
├── screens/
│   ├── business_list_screen.dart     # Main list view
│   ├── business_detail_screen.dart   # Detail view
│   └── search_screen.dart            # Search interface
└── utils/
    ├── constants.dart                # App constants
    └── validators.dart               # Data validation
```

## Git History

This project follows a structured development approach with meaningful commits:

1. **Initial project setup and architecture scaffold** - Project structure, dependencies, models
2. **Implement Provider state management and data normalization** - Core business logic
3. **Build UI screens and reusable card components** - User interface and networking
4. **Add final polish, error handling, and documentation** - Production ready

## Key Technical Decisions

### Data Normalization

Transforms messy JSON keys into clean domain models:

```dart
// Raw JSON: {"biz_name": "...", "bss_location": "...", "contct_no": "..."}
// Becomes: Business(name: "...", location: "...", contactNumber: "...")
```

### Generic Card System

Reusable components through composition:

```dart
abstract class BaseCard<T> extends StatelessWidget {
  Widget buildContent(BuildContext context, T item);
}

class BusinessCard extends BaseCard<Business> { ... }
class ServiceCard extends BaseCard<Service> { ... }
```

### Offline-First Strategy

1. Load from cache immediately (if available)
2. Fetch fresh data in background
3. Update UI when fresh data arrives
4. Handle offline scenarios gracefully

## Dependencies

- **provider**: State management
- **dio**: HTTP client for networking
- **shared_preferences**: Local storage
- **path_provider**: File system access
- **url_launcher**: External URL/phone launching

## Performance Features

- Lazy loading of detail screens
- Debounced search (500ms)
- Memory-efficient JSON parsing
- Cached data for offline usage
- Minimal rebuilds with Provider

## Future Enhancements

- **Advanced Search**: Filters, sorting, fuzzy search
- **Maps Integration**: Location-based features
- **Favorites**: User favorites with sync
- **Dark Mode**: Theme switching
- **Internationalization**: Multi-language support
- **API Integration**: Real backend connectivity

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
