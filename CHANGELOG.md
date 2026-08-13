# Changelog

## [2.2.0](https://github.com/AqueGen/CooldownManagerProfiles/compare/v2.1.9...v2.2.0) (2026-08-13)


### Features

* add Made in Ukraine footer to settings panel ([#6](https://github.com/AqueGen/CooldownManagerProfiles/issues/6)) ([d5a85da](https://github.com/AqueGen/CooldownManagerProfiles/commit/d5a85da9aad73a97e27a96a5daa118303a40b9b0))


### Bug Fixes

* never build a realm-less character key ([#7](https://github.com/AqueGen/CooldownManagerProfiles/issues/7)) ([be3732b](https://github.com/AqueGen/CooldownManagerProfiles/commit/be3732b5a89e3d8d37b1918a779b56e16aac2087))

## [2.1.9](https://github.com/AqueGen/CooldownManagerProfiles/compare/v2.1.8...v2.1.9) (2026-08-12)


### Bug Fixes

* update Luxthos presets to latest 12.1.0 layouts ([#4](https://github.com/AqueGen/CooldownManagerProfiles/issues/4)) ([7a4623b](https://github.com/AqueGen/CooldownManagerProfiles/commit/7a4623b99b102d9bae8d2364183d74a90e5351b1))

## [2.1.8] - 2026-08-05

### Added

- Support for WoW 12.1.0.
- Adding a template to a read-only preset now offers to copy the preset into
  My Profiles and add the template to the copy, in one click ("Copy & Add").

### Fixed

- "+Profile" in the Template Library no longer fails with "Profile not found."
  when a preset is selected.
- Import now rejects export strings made with a newer addon version with a clear
  message instead of silently accepting incompatible data.
- Exported data containing infinite numeric values no longer fails to import.
