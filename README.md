# Antripe Flutter Assignment — Qunova

Flutter contacts (phonebook) app Qunova, built to match the provided Figma and consume the provided GET API.

- Figma: https://www.figma.com/design/rtRcWLCvXI1BapaupLmOHK/Task?node-id=0-1&p=f&t=uRJlJYJe8uT59cj1-0
- API (GET): https://api.antripe.com/v1/contact/api.json

## Features

- Splash screen with a smooth branded animation
- Contacts home with loading / empty / error states
- Category chips (horizontal scroll) with selected/unselected UI
- Search by name or phone (debounced) and works with category filtering
- Add contact via bottom sheet; saved locally and merged with API list
- Recent tab shows recently opened contacts (persisted locally)
- Tap a contact to open a detail page (actions + contact info)
- A–Z indexed contacts list (Contacts tab)

## Flutter / Dart

- Flutter: **stable 3.41.2**
- Dart: **3.11.0**

## Setup

1. Install Flutter stable and set up an emulator/device
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```

## Run

```bash
flutter run
```

## Architecture (clean + feature-based)

- `lib/features/*` contains feature modules (contacts, splash)
- `lib/core/*` contains shared utilities (network, persistence, router, theme, widgets)
- Presentation uses **BLoC** (events/states) to manage:
  - initial load from API
  - search + category filtering
  - recent contacts tracking
  - adding local contacts

## Libraries used (and why)

- `flutter_bloc`: predictable state management for UI + filtering
- `equatable`: simpler state comparisons
- `get_it`: dependency injection
- `go_router`: declarative navigation (contacts → detail)
- `http`: API requests
- `shared_preferences`: local persistence (first launch flag, recent IDs, locally added contacts)
- `cached_network_image`: avatar image caching
- `azlistview`: A–Z indexed list UI
- `intl`: date formatting
- `flutter_svg`: SVG assets

## Assumptions

- API returns the documented structure; contacts with `isEmpty: true` are ignored
- Newly added contacts are stored locally (SharedPreferences) and merged with remote data
- Recent list stores up to 20 most recently opened contacts
- “Get Started” onboarding bottom sheet is shown only on first launch
- Made Contact detail page as the contact comes with enough informations

## Preview & Install (Drive)

Google Drive (video preview + APK):
https://drive.google.com/drive/folders/1SwHIKt3avNka0rejhUXei9nZqPWlnUup?usp=sharing

- Open the link to watch the video preview
- Download the APK from the same link to install the app
