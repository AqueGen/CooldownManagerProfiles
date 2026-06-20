## [2.1.7] - 2026-06-21

### Changed

- Reworked auto-sync detection. It now compares the live Cooldown Manager against the
  current version of your auto-sync profile - by layout name (a different profile is
  loaded) and by a content hash (the profile or preset was edited since you applied it)
  - instead of relying on timestamps. It checks on login and on /reload, no longer nags
  when nothing changed, and prompts only when the Cooldown Manager is actually out of sync.
- Added a per-character "Mute" checkbox next to the Auto-Sync dropdown. The prompt's
  second button is now "Don't ask again", which mutes auto-sync for that profile on that
  character; un-check the box (or apply the profile) to re-enable it.

### Fixed

- Fixed a Lua error when viewing a profile with no layouts and then one that has layouts.
- A failed profile load now restores your previous Cooldown Manager layouts instead of
  leaving the Cooldown Manager empty.
- Importing class layouts with "Create Copies" no longer produces duplicate names when
  the same name appears more than once in a single import.
