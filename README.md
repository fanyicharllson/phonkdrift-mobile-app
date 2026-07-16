# PhonkDrift

> "Welcome to the drift station."

PhonkDrift is a premium, phonk-focused music streaming app for Android/iOS built with Flutter, backed by a Go microservices platform speaking gRPC. Beyond streaming, it has a real-time community chat where drifters (the app's term for its users) hang out, react, and build reputation through join-order badges — all wrapped in a dark, neon red/purple "premium" visual identity.

## What it does

- **Stream & discover** — trending tracks, search, recently played, and playlists, with a full-featured player (background audio, lock-screen controls, waveform seek bar, repeat/loop, queue).
- **Community chat** — a WhatsApp-style live chat room for the whole community: optimistic sending, reply threads, long-press message actions (reply / copy / report), sender badges (e.g. founding-member/"OG" status based on join rank), and a join/leave flow with dedicated onboarding, rejoin, and error states.
- **Accounts** — email/OTP verification, phonk-level onboarding quiz, profile management, ban handling.
- **Push notifications** — Firebase Cloud Messaging wired to a typed routing table (trending tracks, engagement nudges, profile updates, chat messages/replies, community joins, announcements), correctly distinguishing a tapped notification (safe to navigate) from one received in the foreground (must never yank the user away from what they're doing).

## Architecture

- **Client**: Flutter, feature-first structure under `lib/features/{auth,track,community}`, each split into `data/repositories` (gRPC calls) and `presentation/{screens,widgets,controllers}`. Shared code (network client, theming, storage, push handling) lives in `lib/core`.
- **State management**: plain `ChangeNotifier` controllers (e.g. `TrackController`) rather than a framework like Bloc/Riverpod — kept intentionally simple.
- **Backend**: a separate Go services platform (`phonkdrift-backend`) — `auth-service`, `track-service`, and `chat-service` (community), all reached through a single gRPC gateway. Generated protobuf/gRPC stubs live in `lib/core/network/generated/*.pb*.dart`.
- **Auth**: token-based, stored via `flutter_secure_storage`; every authenticated gRPC call attaches auth `CallOptions`.
- **Audio**: `just_audio` + `just_audio_background`/`audio_service` for background playback and system media controls.

## Getting started

1. Install the Flutter SDK (`^3.9.2` per `pubspec.yaml`) and run:

   ```sh
   flutter pub get
   ```

2. Configure the backend endpoint. The gRPC gateway host/port are read from `.env` (see `GRPC_HOST` / `GRPC_PORT` in `lib/core/constants/app_config.dart`) — copy `.env` locally with your own gateway address; don't commit real infrastructure endpoints.
3. Firebase is required for push notifications — add your own `google-services.json` (Android) / `GoogleService-Info.plist` (iOS) if you're standing up your own backend/project.
4. Run the app:

   ```sh
   flutter run
   ```

## Project status

Actively in development — both the mobile client and backend are being built out feature by feature, with a strong focus on getting the small details (loading states, error handling, empty states, animations) to feel deliberate rather than default.
