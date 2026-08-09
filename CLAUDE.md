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

Releases are driven by [release-please](https://github.com/googleapis/release-please) from **Conventional Commits**. Nothing is versioned by hand.

- Write commits as `feat: ...` (minor), `fix: ...` (patch), `feat!: ...` or a `BREAKING CHANGE:` footer (major). Anything else (`chore:`, `docs:`, `ci:`, `refactor:`) does not trigger a release on its own.
- On every push to `main`, `release-please.yml` opens or updates a **release PR** that bumps `## Version:` in `CooldownManagerProfiles.toc`, updates `CHANGELOG.md`, and updates `.release-please-manifest.json`.
- **Merging that PR** publishes everything: the `v<semver>` tag, the GitHub release, and - in the same workflow run - the CurseForge/Wago upload.
- The packaging job lives in `release-please.yml` on purpose. A tag pushed with the default `GITHUB_TOKEN` does **not** trigger other workflows, so `release.yml` would never fire for a release-please tag. `release.yml` is now `workflow_dispatch` only and exists for manual builds.
- `CHANGELOG.md` is **generated and accumulating** — release-please owns it. Do NOT hand-edit it and do NOT overwrite it with a single release's notes. The packager gets only the newest section, via `RELEASE_NOTES.md`, which CI extracts from `CHANGELOG.md` before packaging (it is gitignored and excluded from the zip).
- Never edit the `## Version:` line in `CooldownManagerProfiles.toc` by hand — it sits inside `# x-release-please-start-version` / `# x-release-please-end` markers. The TOC holds bare semver (`2.1.8`); tags keep the `v` prefix (`v2.1.8`).
- **NEVER** delete, force-push, or recreate tags/releases. CurseForge picks up every tag push and creates duplicate entries that cannot be removed. Always let a new release PR produce the next version instead.
- `version-check.yml` is now only a safety net (it tolerates a leading `v` on either side); release-please keeps the TOC and the tag in sync by construction.
