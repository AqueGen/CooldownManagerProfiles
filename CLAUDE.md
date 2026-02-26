# CooldownManagerProfiles

WoW addon: save, switch, and share Cooldown Manager layout profiles.

## Reference Sources
- Blizzard UI source: `G:\Games\wow-ui-source-live`
- C_CooldownViewer API: `Blizzard_APIDocumentationGenerated/CooldownViewerDocumentation.lua`

## WoW Addon Rules

### Taint Prevention
- **NEVER** call `EventRegistry:TriggerEvent()` or fire Blizzard internal events from addon code. Any Lua-level call into Blizzard's event/method system from addon context taints the execution, causing "secret value" errors in combat.
- **NEVER** call methods directly on Blizzard UI frames (e.g. `viewer:RefreshData()`, `viewer:CacheLayoutSettings()`). This taints the frame's cached data.
- **USE** Blizzard's C API functions (e.g. `C_CooldownViewer.SetLayoutData()`) — these are C-level and handle internal notifications without taint.
- When LayoutManager Lua methods (`lm:RemoveLayout`, `lm:CreateLayoutsFromSerializedData`) are unavoidable, **always follow with `ReloadUI()`** — there is no way to refresh CooldownViewer frames from addon context without taint. The only clean path is a full UI reload.
- **NEVER** use `GetLayoutData`/`SetLayoutData` round-trip to refresh viewers after Lua-level lm operations. `GetLayoutData` reads from the C-level store which is NOT updated by Lua lm calls. Use `lm:SaveLayouts()` instead — it serializes from the Lua LayoutManager and writes to C level.
- Tainted values on Blizzard frame fields persist until overwritten by secure (C-level) code or `/reload`. The only way to clear them is through C API (`SetLayoutData` or `SaveLayouts`).

### Lua Compatibility
- WoW's Lua supports `goto`/`::label::` syntax, but `goto` **cannot jump over local variable declarations** into their scope. Use `if/else` blocks instead.

## Release Process

- `CHANGELOG.md` is a **manual changelog** used by BigWigsMods/packager for both GitHub releases and CurseForge.
- Before each release, **overwrite** `CHANGELOG.md` with the notes for the current version only (packager uses the entire file as the release body).
- Do NOT accumulate old versions in the file — only the latest release notes.
- **NEVER** delete, force-push, or recreate tags/releases. CurseForge picks up every tag push and creates duplicate entries that cannot be removed. Always bump the version and create a new tag instead.
