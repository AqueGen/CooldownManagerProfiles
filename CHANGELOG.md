## Fix: Auto-sync false popup on every login

- **Fixed auto-sync showing "different layouts" popup every login** even when nothing changed. Blizzard's serializer embeds layout IDs that change when layouts are recreated, making data comparison unreliable. Replaced with timestamp-based tracking.
- Minimap icon changed to a standard Blizzard icon
- Simplified minimap button (single click to toggle window)
