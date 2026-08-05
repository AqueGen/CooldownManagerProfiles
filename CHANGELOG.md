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
