# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter plugin monorepo for **Network Service Discovery** (NSD/DNS-SD/Bonjour/mDNS), enabling Flutter apps to discover and register network services. The package is published on pub.dev as `nsd`.

## Packages

| Package | Description |
|---------|-------------|
| `nsd` | Public API — thin wrapper over the platform interface |
| `nsd_platform_interface` | Abstract interface + MethodChannel implementation |
| `nsd_android` | Android (Kotlin) implementation |
| `nsd_ios` | iOS (Swift) implementation |
| `nsd_macos` | macOS (Swift) implementation |
| `nsd_windows` | Windows (C++) implementation |

## Commands

All commands must be run from within the relevant package directory (e.g., `nsd_platform_interface/`).

```bash
flutter pub get           # Install dependencies
dart format .             # Format code
dart format --set-exit-if-changed .  # Check formatting (CI)
flutter analyze .         # Lint / static analysis
flutter test --no-pub     # Run unit tests
```

CI runs tests only for `nsd_platform_interface`. Integration tests live in `nsd/example/integration_test/`.

## Architecture

The plugin follows Flutter's standard **federated plugin** pattern:

```
nsd  (public API)
  └─ nsd_platform_interface  (abstract NsdPlatformInterface + MethodChannel)
       └─ nsd_android / nsd_ios / nsd_macos / nsd_windows  (native implementations)
```

### Dart layer (`nsd_platform_interface`)

- **`NsdPlatformInterface`** — abstract singleton (via `PlatformInterface`) defining `startDiscovery`, `stopDiscovery`, `register`, `unregister`, `resolve`
- **`MethodChannelNsdPlatform`** — concrete implementation over channel `com.haberey/nsd`; tracks in-flight operations by UUID **handle**
- **`Discovery`** — `ChangeNotifier` holding a live list of `Service` objects; also supports per-service `addServiceListener`
- **`Service`** — immutable value object: name, type, host, port, TXT records (`Map<String, Uint8List?>`), addresses
- **`serialization.dart`** — converts between Dart types and the channel's key-prefixed map format (e.g. `service.name`, `error.cause`, `handle`)

### Native layer

Each platform implements the same MethodChannel protocol (`com.haberey/nsd`) using its native DNS-SD API:

| Platform | Language | Native API |
|----------|----------|------------|
| Android | Kotlin | `NsdManager` + `WifiManager` multicast lock |
| iOS | Swift | `NetServiceBrowser` / `NetService` |
| macOS | Swift | `NetServiceBrowser` / `NetService` |
| Windows | C++ | DNS-SD / mDNS WinRT APIs |

Operations are handle-tracked with UUIDs so the channel can correlate async callbacks back to the correct Dart `Completer`.

## Linting Rules

Beyond `package:flutter_lints/flutter.yaml`, the project enforces:
- `prefer_single_quotes`
- `prefer_final_locals`
- `unawaited_futures`
