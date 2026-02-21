# Cooldown Manager Profiles

[![CurseForge](https://img.shields.io/badge/CurseForge-CooldownManagerProfiles-orange)](https://www.curseforge.com/wow/addons/cooldownmanagerprofiles)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![WoW Version](https://img.shields.io/badge/WoW-12.0.1+-brightgreen)](https://worldofwarcraft.com)

Unlimited profiles for the Blizzard Cooldown Manager with global template library, cross-character profiles, and full import/export.

## Features

- **Global Profiles** — Create account-wide profiles that store layouts organized by class. Load any profile onto any character and it automatically applies the layouts for your current class.
- **Template Library** — Save individual layouts into a reusable template library organized by class and spec. Drag templates into profiles or use them standalone.
- **Import / Export** — Full import/export support for profiles, class layouts, individual layouts, and raw CDM strings. Share setups with friends or back them up.
- **Conflict Resolution** — When importing a profile or class layouts that already exist, choose to create a copy or overwrite.
- **Sync from Blizzard** — Capture your current in-game Blizzard CDM layouts into a profile with one click.
- **Load to Blizzard** — Push profile layouts for your current class back into the Blizzard Cooldown Manager.
- **Minimap Button** — Quick access via minimap icon (left-click to open, right-click for settings).
- **Resizable UI** — Three-column layout with drag-to-resize.

## Installation

1. Download and extract into `Interface/AddOns/CooldownManagerProfiles`
2. Restart World of Warcraft or `/reload`
3. Type `/cm` to open the main window

## Slash Commands

| Command            | Description                                  |
| ------------------ | -------------------------------------------- |
| `/cm`              | Toggle the main window                       |
| `/cm save <name>`  | Save current Blizzard CDM state as a profile |
| `/cm load <name>`  | Load a profile (replaces Blizzard layouts)   |
| `/cm list`         | List all profiles and stored layouts         |
| `/cm import`       | Open the import window                       |
| `/cm export`       | Quick-export the active Blizzard layout      |
| `/cm settings`     | Open the addon settings panel                |
| `/cm help`         | Show available commands                      |

## UI Overview

The main window is split into three columns:

- **Left — Profiles**: Your global profiles. Click to select, use inline Rename/Delete buttons, or create a new profile with the "New" button.
- **Center — Profile Contents**: Layouts stored in the selected profile, grouped by class. Below that, your current Blizzard CDM layouts with sync/load controls.
- **Right — Template Library**: Individual saved layouts you can add to any profile. Import CDM strings here.

## Import / Export Formats

| Prefix   | Type           | Description                                  |
| -------- | -------------- | -------------------------------------------- |
| `CM2P:`  | Global Profile | All class layouts in a profile               |
| `CM2C:`  | Class Layouts  | Layouts for one class from a profile         |
| `CM2L:`  | Single Layout  | One individual layout                        |
| `CM2T:`  | Template       | One template from the library                |
| `1\|...` | Raw CDM        | Blizzard Cooldown Manager serialized string  |

## Data Storage

All data is stored in `CooldownManagerProfilesDB` (WoW SavedVariables):

- **Account-wide**: Global profiles, template library
- **Per-character**: Active profile selection, Blizzard layout snapshots, stored layouts

## Migrating from CooldownMaster

The addon was renamed from **CooldownMaster** to **CooldownManagerProfiles**. Your saved data is not lost, but WoW won't transfer it automatically because the addon folder name changed.

To migrate manually:

1. **Close WoW completely** (not just `/reload`).
2. Open the `WTF/Account/<YourAccount>/SavedVariables/` folder.
3. Open `CooldownMaster.lua` in a text editor.
4. Replace `CooldownMasterDB` with `CooldownManagerProfilesDB` (there should be one occurrence at the top).
5. Save the file as `CooldownManagerProfiles.lua` in the same folder.
6. Launch WoW — all your profiles and templates will be back.

## Requirements

- World of Warcraft: The War Within (Retail 12.0.x)
- Blizzard Cooldown Manager must be available (ships with the game)
