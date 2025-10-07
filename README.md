# {{ProjectName}} iOS Modular Template

This repository is a fully automated Swift 6 / Xcode 16-ready template designed to bootstrap modern, modular iOS 18 applications without relying on Tuist. The stack prioritizes MVVM, Clean Swift, and The Composable Architecture (TCA) while keeping everything wired through Swift Package Manager and reproducible shell scripts.

## Quick start

```bash
# Clone the template
git clone https://github.com/Ledzepdo2/Template.git MyNewApp
cd MyNewApp

# Rename every placeholder occurrence
./Scripts/rename_template.sh MyNewApp

# Install CLI tooling, resolve SPM dependencies, set up git hooks and CI
./Scripts/bootstrap.sh

# Open the generated project
open MyNewApp.xcodeproj
```

> ℹ️ The template targets **iOS 18**, **Swift 6**, and **Xcode 16–26**. Ensure the matching Xcode version is installed via the App Store or `xcodes`.

## Repository layout

```
.
├── App/                       # SwiftUI app target consuming local Swift packages
├── Modules/
│   ├── Core/CoreKit/          # Shared types (logging, DI, networking)
│   └── Features/              # Feature modules by architecture
│       ├── MVVMFeature/       # MVVM + Nuke example
│       ├── CleanFeature/      # Clean Swift VIP example + Lottie + Alamofire
│       └── TCAFeature/        # TCA example powered by swift-dependencies
├── Scripts/                   # Reproducible setup + automation scripts
├── Tests/                     # App-level integration tests referencing modules
├── .githooks/                 # Pre-commit/pre-push hooks (lint + tests)
├── .github/workflows/ci.yml   # macOS CI pipeline (lint + tests)
├── Package.swift              # Local Swift package exposing modules
└── {{ProjectName}}.xcodeproj  # SwiftUI app project already wired to SPM
```

## Scripts

| Script | Description |
| --- | --- |
| `Scripts/bootstrap.sh` | Orchestrates tooling installation, dependency resolution, git hooks, and CI bootstrapping. |
| `Scripts/install_tools.sh` | Installs/updates SwiftLint and SwiftFormat via Homebrew and writes default configs. |
| `Scripts/setup_modules.sh` | Runs `swift package resolve`, prepares DerivedData cache, ensures Swift 6 toolchain present. |
| `Scripts/run_format.sh` | Runs SwiftFormat (`--lint` mode optionally). |
| `Scripts/run_lint.sh` | Runs SwiftLint (strict when requested). |
| `Scripts/run_tests.sh` | Executes `xcodebuild` tests (or `swift test` with `--spm`). |
| `Scripts/setup_ci.sh` | Generates the GitHub Actions workflow if missing. |
| `Scripts/install_git_hooks.sh` | Symlinks hooks from `.githooks` into `.git/hooks`. |
| `Scripts/rename_template.sh` | Performs placeholder replacement and renames the `.xcodeproj`. |

All scripts are POSIX-compliant and safe to re-run.

## Architectures included

- **MVVM (`MVVMFeature`)** – demonstrates image fetching with [Nuke](https://github.com/kean/Nuke) and logging via `swift-log` through `CoreKit`.
- **Clean Swift (`CleanFeature`)** – VIP stack with async workers using `Alamofire` + `swift-dependencies` networking injection and a SwiftUI wrapper view with Lottie animations.
- **The Composable Architecture (`TCAFeature`)** – counter domain showing reducer composition, dependency injection, and deterministic testing using `swift-dependencies` + `swift-case-paths` + `swift-identified-collections`.

Each feature is exposed as an independent Swift package product and consumed from the main SwiftUI app.

## Dependency matrix

All packages are resolved with Swift Package Manager in `Package.swift`:

- `pointfreeco/swift-dependencies`
- `pointfreeco/swift-case-paths`
- `pointfreeco/swift-identified-collections`
- `pointfreeco/swift-macro-testing`
- `apple/swift-log`
- `pointfreeco/swift-composable-architecture`
- `kean/Nuke`
- `airbnb/lottie-ios`
- `Alamofire/Alamofire`
- Optional (pre-added, ready to link when needed):
  - `apollographql/apollo-ios`
  - `RevenueCat/purchases-ios`
  - `launchdarkly/ios-client-sdk`

Homebrew-only developer tools:

- `SwiftLint`
- `SwiftFormat`

## Git hooks and CI

- `.githooks/pre-commit` → SwiftFormat (lint mode) + SwiftLint strict.
- `.githooks/pre-push` → Executes `swift test` across the Swift package modules.
- `.githooks/prepare-commit-msg` → Prefixes the commit message with the current branch name.
- `Scripts/install_git_hooks.sh` installs the hooks (automatically invoked by `bootstrap`).
- `.github/workflows/ci.yml` runs on push + PR, uses macOS 15 runners, installs tooling, formats, lints, and runs tests with iOS 18 simulator destination.

## Customising the template

1. Clone the repository and rename all placeholders:
   ```bash
   Scripts/rename_template.sh MyAwesomeApp
   ```
2. Review bundle identifiers in `App/Info.plist` and update signing in Xcode if required.
3. Update the GitHub Actions matrix (`.github/workflows/ci.yml`) to match the simulator/device list you intend to support.
4. Replace demo assets (`LottieLoopView` expects an animation named `Loading.json` in your bundle) with your actual resources.

### Adding new feature modules

1. Duplicate one of the feature folders in `Modules/Features`.
2. Update `Package.swift` with a new target + product entry.
3. Add the new product under the `{{ProjectName}}` app target via Xcode’s `Project > Package Dependencies` panel or by editing the `project.pbxproj` (mirroring the existing product dependency entries).
4. Create SwiftUI previews and tests replicating the architecture patterns.

### Using optional dependencies

The optional packages are already declared in `Package.swift`, meaning you only need to add them to a target’s dependency list to begin using them (e.g. GraphQL with Apollo or revenue tracking with RevenueCat). Comment the relevant dependency in `Package.swift` if you prefer to exclude it before resolution.

## Testing locally

```bash
Scripts/run_format.sh --lint
Scripts/run_lint.sh --strict
Scripts/run_tests.sh       # Uses xcodebuild by default
Scripts/run_tests.sh --spm # Package-only tests (CI preflight, Linux)
```

## Compatibility notes

- **Xcode 16+**: The `.xcodeproj` is configured with `objectVersion 60` and build settings matching Swift 6 / iOS 18.
- **Swift 6 concurrency**: All async features compile with strict concurrency checks enabled.
- **Package plugins**: Not required; pure SwiftPM targets keep compile times predictable.
- **Lottie assets**: Provide a `Loading.json` animation file inside `App/Resources/Assets.xcassets` or replace `LottieLoopView` with your custom placeholder.
- **Apollo, RevenueCat, LaunchDarkly**: Left unused by default to avoid additional build steps. Remove from `Package.swift` if you do not need them.

## Troubleshooting

- `brew: command not found` → Install Homebrew (`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`).
- `xcodebuild: error: SDK "iphonesimulator18.0" cannot be located` → Confirm Xcode 16+ is selected via `sudo xcode-select -s /Applications/Xcode.app` and run `xcodebuild -showsdks`.
- SwiftLint/SwiftFormat not updating → `brew update && brew upgrade swiftlint swiftformat`.
- CI simulator issues → Update `destination` in `Scripts/run_tests.sh` and `.github/workflows/ci.yml` to match installed runtimes.

## License

MIT License. See [LICENSE](LICENSE).
