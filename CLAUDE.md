# Sax Buddy Client

Mobile client of Sax Buddy

## Development Practice

1. Act as a pairing partner for the user. Do not commit anything until explicit consent is given
2. **STRICT TDD PRACTICE - RED/GREEN/REFACTOR CYCLE:**
  * **RED**: Write a failing test that describes the intended behavior FIRST
  * **GREEN**: Write minimal code to make that specific test pass
  * **REFACTOR**: Clean up code while keeping tests green
  * **NEVER** write implementation before tests
  * **ALWAYS** see the test fail first to validate it works
  * Run test after each step: `flutter test`
3. Update this document with up-to-date project structures and architecture.
4. **TDD Reminder**: If you find yourself writing implementation code before seeing a failing test, STOP and write the test first.

## Frameworks

* Flutter

## Backend

https://sax-buddy-service.onrender.com

## Project Structure

```
lib/
├── models/
│   └── api_models.dart         # Data models for API requests/responses
├── services/
│   ├── api_client.dart         # HTTP client for Sax Buddy API
│   ├── auth_service.dart       # Firebase/Google authentication
│   ├── logging_service.dart    # Centralized logging
│   └── sax_buddy_service.dart  # High-level service layer
└── screens/
    ├── home_screen.dart
    └── sign_in_screen.dart

test/
├── models/
│   └── api_models_test.dart    # Unit tests for data models
├── services/
│   └── api_client_test.dart    # Unit tests for API client
└── ...
```

## API Integration

* **ApiClient**: Low-level HTTP client using Dio
  * Configurable base URL via `.env` file or compile-time environment variable
  * Default: `http://0.0.0.0:8000` (development)
  * Uses Google OAuth access token for authentication
  * Comprehensive error handling with user-friendly messages
  * Integrated with LoggingService for request/response logging

* **SaxBuddyService**: High-level service layer
  * Integrates ApiClient with Firebase Auth
  * Provides simplified methods for common operations
  * Automatic token management

* **Authentication**: Google OAuth via Firebase
  * Access token used as bearer token for API calls
  * Automatic token refresh and management

## Environment Configuration

The app uses a `.env` file for configuration. Copy `.env.example` to `.env` and update values:

```bash
cp .env.example .env
```

Configuration options:
- `SAX_BUDDY_API_BASE_URL`: API base URL
- `ENVIRONMENT`: development, staging, or production
- `DEBUG_MODE`: Enable/disable debug features

The app loads `.env` at startup via `flutter_dotenv` package.

## Note

Use `flutterfire configure` command to configure mobile apps for Firebase