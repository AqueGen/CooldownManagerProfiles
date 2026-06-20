local _, ns = ...

---------------------------------------------------------------------------
-- Layout Metadata Capture
-- Stores layout names/class/spec info alongside profile blob for preview
---------------------------------------------------------------------------

--- Capture current Blizzard layout metadata (names, specs, classes)
function ns.CaptureLayoutMeta()
    local lm = ns.GetLayoutManager()
    if not lm or not lm.EnumerateLayouts then return nil end
    local meta = {}
    local ok = pcall(function()
        for layoutID, layout in lm:EnumerateLayouts() do
            local entry = { id = layoutID }
            if CooldownManagerLayout_GetName then
                pcall(function() entry.name = CooldownManagerLayout_GetName(layout) end)
            end
            if CooldownManagerLayout_GetClassAndSpecTag then
                pcall(function()
                    local raw = CooldownManagerLayout_GetClassAndSpecTag(layout)
                    entry.specTagNum = raw  -- numeric: classID * 10 + specIndex
                    entry.specTag = raw and tostring(raw) or ""
                end)
            end
            entry.name = entry.name or ("Layout " .. layoutID)
            entry.specTag = entry.specTag or ""
            meta[#meta + 1] = entry
        end
    end)
    if not ok or #meta == 0 then return nil end
    return meta
end

---------------------------------------------------------------------------
-- PROFILES (blob swap — each profile = full Blizzard state, up to 5 layouts)
---------------------------------------------------------------------------

--- Save current Blizzard state as a named profile
function ns.SaveProfile(name, overwrite)
    if not name or name == "" then return false, "Name cannot be empty." end
    if #name > 50 then return false, "Name too long (max 50)." end
    if not ns.charKey then return false, "Character not ready." end
    if not C_CooldownViewer then return false, "CDM not available." end

    ns.EnsureCharTables()
    local profiles = ns.db.profiles[ns.charKey]
    if profiles[name] and not overwrite then
        return false, "Profile '" .. name .. "' already exists."
    end

    local data = C_CooldownViewer.GetLayoutData()
    if not data or data == "" then
        return false, "No layout data. Configure the Cooldown Manager first."
    end

    profiles[name] = {
        data = data,
        created = profiles[name] and profiles[name].created or time(),
        modified = time(),
        layoutInfo = ns.CaptureLayoutMeta(),
    }
    ns.db.activeProfile[ns.charKey] = name

    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

--- Load a profile into Blizzard (replaces all 5 slots)
function ns.LoadProfile(name)
    if not name or name == "" then return false, "Name cannot be empty." end
    if not ns.charKey then return false, "Character not ready." end
    if InCombatLockdown() then
        ns.pendingProfileLoad = name
        return false, "In combat. Queued for after."
    end
    if not ns.dataLoaded then return false, "CDM data not loaded yet." end

    ns.EnsureCharTables()
    local profile = ns.db.profiles[ns.charKey][name]
    if not profile then return false, "Profile '" .. name .. "' not found." end
    if not profile.data or profile.data == "" then return false, "Profile has no data." end

    -- Auto-save current state to active profile before switching
    local active = ns.db.activeProfile[ns.charKey]
    if active and active ~= name and ns.db.profiles[ns.charKey][active] then
        local curData = C_CooldownViewer.GetLayoutData()
        if curData and curData ~= "" then
            ns.db.profiles[ns.charKey][active].data = curData
            ns.db.profiles[ns.charKey][active].modified = time()
            ns.db.profiles[ns.charKey][active].layoutInfo = ns.CaptureLayoutMeta()
        end
    end

    C_CooldownViewer.SetLayoutData(profile.data)
    ns.db.activeProfile[ns.charKey] = name
    -- Clear stale name overrides (new blob has its own layout IDs)
    ns.db.layoutNameOverrides[ns.charKey] = {}
    StaticPopup_Show("CMP_RELOAD_UI")
    return true
end

function ns.DeleteProfile(name)
    if not name or not ns.charKey then return false, "Invalid." end
    ns.EnsureCharTables()
    if not ns.db.profiles[ns.charKey][name] then
        return false, "Profile not found."
    end
    if ns.db.activeProfile[ns.charKey] == name then
        return false, "Cannot delete active profile. Switch first."
    end
    ns.db.profiles[ns.charKey][name] = nil
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

function ns.RenameProfile(oldName, newName)
    if not oldName or not newName or newName == "" then return false, "Invalid names." end
    if #newName > 50 then return false, "Name too long." end
    if not ns.charKey then return false, "Character not ready." end
    ns.EnsureCharTables()
    local profiles = ns.db.profiles[ns.charKey]
    if not profiles[oldName] then return false, "Profile not found." end
    if profiles[newName] then return false, "Name already taken." end

    profiles[newName] = profiles[oldName]
    profiles[oldName] = nil
    if ns.db.activeProfile[ns.charKey] == oldName then
        ns.db.activeProfile[ns.charKey] = newName
    end
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

function ns.GetActiveProfileName()
    if not ns.charKey then return nil end
    return ns.db.activeProfile[ns.charKey]
end

function ns.GetProfileList()
    if not ns.charKey then return {} end
    ns.EnsureCharTables()
    local list = {}
    for name, info in pairs(ns.db.profiles[ns.charKey]) do
        list[#list + 1] = { name = name, created = info.created or 0, modified = info.modified or 0 }
    end
    table.sort(list, function(a, b) return a.name < b.name end)
    return list
end

function ns.GetProfileLayoutInfo(profileName)
    if not ns.charKey or not profileName then return nil end
    ns.EnsureCharTables()
    local profile = ns.db.profiles[ns.charKey][profileName]
    if not profile then return nil end
    return profile.layoutInfo
end

function ns.GetProfileCount()
    local n = 0
    if ns.charKey and ns.db.profiles[ns.charKey] then
        for _ in pairs(ns.db.profiles[ns.charKey]) do n = n + 1 end
    end
    return n
end

---------------------------------------------------------------------------
-- BLIZZARD LAYOUTS (individual layouts within active profile)
-- NOTE: LayoutManager API (EnumerateLayouts, GetSerializer, etc.) is
-- internal Blizzard API that may not exist. All calls are pcall-guarded.
---------------------------------------------------------------------------

function ns.GetBlizzardLayouts()
    local lm = ns.GetLayoutManager()
    if not lm or not lm.EnumerateLayouts then return {} end
    local layouts = {}
    local ok, err = pcall(function()
        for layoutID, layout in lm:EnumerateLayouts() do
            local name = "Layout " .. layoutID
            local specTag = ""
            local isDef = false
            if CooldownManagerLayout_GetName then
                name = CooldownManagerLayout_GetName(layout) or name
            end
            local specTagNum
            if CooldownManagerLayout_GetClassAndSpecTag then
                local raw = CooldownManagerLayout_GetClassAndSpecTag(layout)
                specTagNum = raw
                specTag = raw and tostring(raw) or ""
            end
            if CooldownManagerLayout_IsDefaultLayout then
                isDef = CooldownManagerLayout_IsDefaultLayout(layout) or false
            end
            layouts[#layouts + 1] = {
                id = layoutID, name = name, specTag = specTag,
                specTagNum = specTagNum, isDefault = isDef,
                class = ns.GetClassToken(),
            }
        end
    end)
    if not ok then return {} end
    table.sort(layouts, function(a, b) return a.id < b.id end)
    -- Apply local name overrides
    local overrides = ns.charKey and ns.db.layoutNameOverrides
        and ns.db.layoutNameOverrides[ns.charKey]
    if overrides then
        for _, l in ipairs(layouts) do
            if overrides[l.id] then l.name = overrides[l.id] end
        end
    end
    return layouts
end

function ns.GetBlizzardLayoutCount()
    local lm = ns.GetLayoutManager()
    if not lm or not lm.EnumerateLayouts then return 0 end
    local n = 0
    local ok = pcall(function()
        for layoutID, layout in lm:EnumerateLayouts() do
            local isDef = false
            if CooldownManagerLayout_IsDefaultLayout then
                isDef = CooldownManagerLayout_IsDefaultLayout(layout) or false
            end
            if not isDef and lm.IsDefaultLayoutID then
                local dOk, isDefID = pcall(lm.IsDefaultLayoutID, lm, layoutID)
                if dOk and isDefID then isDef = true end
            end
            if not isDef then n = n + 1 end
        end
    end)
    return ok and n or 0
end

function ns.HasFreeBlizzardSlot()
    return ns.GetBlizzardLayoutCount() < 5
end


---------------------------------------------------------------------------
-- Sync: capture current Blizzard state into active profile
---------------------------------------------------------------------------

function ns.SyncFromBlizzard(silent)
    if not ns.charKey then return false, "Character not ready." end
    if not C_CooldownViewer then return false, "CDM not available." end
    local data = C_CooldownViewer.GetLayoutData()
    if not data or data == "" then return false, "No layout data from Blizzard." end

    ns.EnsureCharTables()
    local active = ns.db.activeProfile[ns.charKey]
    local meta = ns.CaptureLayoutMeta()
    if not active then
        active = "Default"
        ns.db.profiles[ns.charKey][active] = {
            data = data, created = time(), modified = time(),
            layoutInfo = meta,
        }
        ns.db.activeProfile[ns.charKey] = active
        if not silent then ns.Print("Created 'Default' profile from Blizzard state.") end
    else
        ns.db.profiles[ns.charKey][active].data = data
        ns.db.profiles[ns.charKey][active].modified = time()
        ns.db.profiles[ns.charKey][active].layoutInfo = meta
        if not silent then ns.Print("Synced Blizzard state into profile: " .. active) end
    end
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

---------------------------------------------------------------------------
-- Export helpers
---------------------------------------------------------------------------

function ns.ExportBlizzardLayout(layoutID)
    local lm = ns.GetLayoutManager()
    if not lm then return nil, "Not available." end
    local ok, layout = pcall(lm.GetLayout, lm, layoutID)
    if not ok or not layout then return nil, "Not found." end
    if not lm.GetSerializer then return nil, "Serializer not available." end
    local serOk, serializer = pcall(lm.GetSerializer, lm)
    if not serOk or not serializer or not serializer.SerializeLayouts then
        return nil, "Serializer not available."
    end
    local dataOk, data = pcall(serializer.SerializeLayouts, serializer, layoutID)
    if not dataOk or not data or data == "" then return nil, "Serialize failed." end
    return data
end

function ns.ExportActiveProfile()
    if not ns.charKey then return nil, "Character not ready." end
    ns.EnsureCharTables()
    local name = ns.GetActiveProfileName()
    if not name then return nil, "No active profile." end
    local profile = ns.db.profiles[ns.charKey][name]
    if not profile then return nil, "Profile not found." end
    return profile.data
end

---------------------------------------------------------------------------
-- Auto-save: keep active profile blob in sync with Blizzard
---------------------------------------------------------------------------

function ns.AutoSaveActiveProfile()
    if not ns.charKey or not ns.dataLoaded then return end
    local name = ns.db.activeProfile[ns.charKey]
    if not name then return end
    local profile = ns.db.profiles[ns.charKey] and ns.db.profiles[ns.charKey][name]
    if not profile then return end
    local data = C_CooldownViewer.GetLayoutData()
    if data and data ~= "" then
        profile.data = data
        profile.modified = time()
        profile.layoutInfo = ns.CaptureLayoutMeta()
    end
end

---------------------------------------------------------------------------
-- TEMPLATE LIBRARY (global, account-wide individual layouts)
---------------------------------------------------------------------------

function ns.AddTemplate(name, class, spec, data)
    if not name or name == "" then return nil, "Name cannot be empty." end
    if #name > 50 then return nil, "Name too long (max 50)." end
    if not data or data == "" then return nil, "No data." end
    class = class or "UNKNOWN"

    local uuid = ns.GenerateUUID()
    ns.db.templateLibrary[uuid] = {
        name = name,
        class = class,
        spec = spec,
        data = data,
        created = time(),
        modified = time(),
    }
    if ns.RefreshUI then ns.RefreshUI() end
    return uuid
end

function ns.DeleteTemplate(uuid)
    if not uuid or not ns.db.templateLibrary[uuid] then
        return false, "Template not found."
    end
    ns.db.templateLibrary[uuid] = nil
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

function ns.RenameTemplate(uuid, newName)
    if not newName or newName == "" then return false, "Empty name." end
    if #newName > 50 then return false, "Name too long (max 50)." end
    local tmpl = ns.db.templateLibrary[uuid]
    if not tmpl then return false, "Template not found." end
    tmpl.name = newName
    tmpl.modified = time()
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

function ns.UpdateTemplateClass(uuid, class)
    local tmpl = ns.db.templateLibrary[uuid]
    if not tmpl then return false, "Template not found." end
    tmpl.class = class or "UNKNOWN"
    tmpl.modified = time()
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

function ns.UpdateTemplate(uuid, name, class, spec, data)
    if not name or name == "" then return false, "Empty name." end
    if #name > 50 then return false, "Name too long (max 50)." end
    local tmpl = ns.db.templateLibrary[uuid]
    if not tmpl then return false, "Template not found." end
    tmpl.name = name
    tmpl.class = class or "UNKNOWN"
    tmpl.spec = spec
    tmpl.data = data or tmpl.data
    tmpl.modified = time()
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

function ns.GetTemplateList(classFilter)
    local list = {}
    for uuid, tmpl in pairs(ns.db.templateLibrary) do
        if not classFilter or tmpl.class == classFilter then
            list[#list + 1] = {
                uuid = uuid,
                name = tmpl.name,
                class = tmpl.class,
                spec = tmpl.spec,
                created = tmpl.created or 0,
                modified = tmpl.modified or 0,
            }
        end
    end
    table.sort(list, function(a, b)
        if a.class ~= b.class then return a.class < b.class end
        return a.name < b.name
    end)
    return list
end

function ns.GetTemplateByUUID(uuid)
    return ns.db.templateLibrary[uuid]
end

function ns.GetTemplateCount()
    local n = 0
    for _ in pairs(ns.db.templateLibrary) do n = n + 1 end
    return n
end

---------------------------------------------------------------------------
-- GLOBAL PROFILES (account-wide, layouts organized by class)
---------------------------------------------------------------------------

function ns.CreateGlobalProfile(name, description)
    if not name or name == "" then return nil, "Name cannot be empty." end
    if #name > 50 then return nil, "Name too long (max 50)." end

    local uuid = ns.GenerateUUID()
    ns.db.globalProfiles[uuid] = {
        name = name,
        description = description or "",
        created = time(),
        modified = time(),
        layouts = {},
    }
    if ns.RefreshUI then ns.RefreshUI() end
    return uuid
end

function ns.DeleteGlobalProfile(uuid)
    if not uuid or not ns.db.globalProfiles[uuid] then
        return false, "Profile not found."
    end
    -- Clear activeGlobalProfile references and applied fingerprints
    for charKey, charData in pairs(ns.db.characters) do
        if charData.activeGlobalProfile == uuid then
            charData.activeGlobalProfile = nil
        end
        if charData.autoSyncMuted then
            charData.autoSyncMuted[uuid] = nil
        end
        if charData.autoSyncApplied then
            charData.autoSyncApplied[uuid] = nil
        end
    end
    -- Drop dangling auto-sync target so it doesn't reference a deleted profile
    if ns.db.autoSyncProfile == uuid then
        ns.db.autoSyncProfile = nil
    end
    ns.db.globalProfiles[uuid] = nil
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

function ns.RenameGlobalProfile(uuid, newName)
    if not newName or newName == "" then return false, "Empty name." end
    if #newName > 50 then return false, "Name too long (max 50)." end
    local profile = ns.db.globalProfiles[uuid]
    if not profile then return false, "Profile not found." end
    profile.name = newName
    profile.modified = time()
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

function ns.GetGlobalProfileList()
    local list = {}
    for uuid, profile in pairs(ns.db.globalProfiles) do
        local layoutCount = 0
        local classCount = 0
        for classToken, layouts in pairs(profile.layouts) do
            classCount = classCount + 1
            layoutCount = layoutCount + #layouts
        end
        list[#list + 1] = {
            uuid = uuid,
            name = profile.name,
            description = profile.description,
            created = profile.created or 0,
            modified = profile.modified or 0,
            layoutCount = layoutCount,
            classCount = classCount,
        }
    end
    table.sort(list, function(a, b) return a.name < b.name end)
    return list
end

function ns.GetGlobalProfile(uuid)
    return ns.db.globalProfiles[uuid]
end

function ns.GetGlobalProfileCount()
    local n = 0
    for _ in pairs(ns.db.globalProfiles) do n = n + 1 end
    return n
end

---------------------------------------------------------------------------
-- PROFILE LAYOUT MANAGEMENT
---------------------------------------------------------------------------

--- Add a layout directly to a profile (copies data)
function ns.AddLayoutToProfile(profileUUID, class, name, spec, data, sourceTemplate)
    local profile = ns.db.globalProfiles[profileUUID]
    if not profile then return false, "Profile not found." end
    if not class or not ns.CLASS_TOKEN_SET[class] then return false, "Invalid class." end
    if not data or data == "" then return false, "No data." end

    if not profile.layouts[class] then profile.layouts[class] = {} end
    local layouts = profile.layouts[class]

    layouts[#layouts + 1] = {
        name = name or "Layout",
        spec = spec,
        sourceTemplate = sourceTemplate,
        data = data,
        created = time(),
        modified = time(),
    }
    profile.modified = time()
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

--- Add a template from the library to a profile (copies data)
function ns.AddTemplateToProfile(profileUUID, templateUUID)
    local tmpl = ns.db.templateLibrary[templateUUID]
    if not tmpl then return false, "Template not found." end
    return ns.AddLayoutToProfile(
        profileUUID, tmpl.class, tmpl.name, tmpl.spec, tmpl.data, templateUUID
    )
end

--- Remove a layout from a profile
function ns.RemoveLayoutFromProfile(profileUUID, class, index)
    local profile = ns.db.globalProfiles[profileUUID]
    if not profile then return false, "Profile not found." end
    local layouts = profile.layouts[class]
    if not layouts or not layouts[index] then return false, "Layout not found." end

    table.remove(layouts, index)
    if #layouts == 0 then profile.layouts[class] = nil end
    profile.modified = time()
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

--- Rename a layout within a profile
function ns.RenameLayoutInProfile(profileUUID, class, index, newName)
    if not newName or newName == "" then return false, "Empty name." end
    if #newName > 50 then return false, "Name too long (max 50)." end
    local profile = ns.db.globalProfiles[profileUUID]
    if not profile then return false, "Profile not found." end
    local layouts = profile.layouts[class]
    if not layouts or not layouts[index] then return false, "Layout not found." end

    layouts[index].name = newName
    layouts[index].modified = time()
    profile.modified = time()
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

--- Get layouts for a profile, optionally filtered by class
function ns.GetProfileLayouts(profileUUID, classFilter)
    local profile = ns.db.globalProfiles[profileUUID]
    if not profile then return {} end

    local result = {}
    for classToken, layouts in pairs(profile.layouts) do
        if not classFilter or classToken == classFilter then
            for i, entry in ipairs(layouts) do
                result[#result + 1] = {
                    class = classToken,
                    index = i,
                    name = entry.name,
                    spec = entry.spec,
                    sourceTemplate = entry.sourceTemplate,
                    data = entry.data,
                    created = entry.created or 0,
                    modified = entry.modified or 0,
                }
            end
        end
    end

    table.sort(result, function(a, b)
        if a.class ~= b.class then return a.class < b.class end
        return a.index < b.index
    end)
    return result
end

--- Save a profile layout back to the template library
function ns.SaveLayoutAsTemplate(profileUUID, class, index)
    local profile = ns.db.globalProfiles[profileUUID]
    if not profile then return nil, "Profile not found." end
    local layouts = profile.layouts[class]
    if not layouts or not layouts[index] then return nil, "Layout not found." end

    local entry = layouts[index]
    return ns.AddTemplate(entry.name, class, entry.spec, entry.data)
end

--- Refresh a profile layout from its source template
function ns.RefreshLayoutFromTemplate(profileUUID, class, index)
    local profile = ns.db.globalProfiles[profileUUID]
    if not profile then return false, "Profile not found." end
    local layouts = profile.layouts[class]
    if not layouts or not layouts[index] then return false, "Layout not found." end

    local entry = layouts[index]
    if not entry.sourceTemplate then return false, "No source template linked." end

    local tmpl = ns.db.templateLibrary[entry.sourceTemplate]
    if not tmpl then return false, "Source template no longer exists." end

    entry.data = tmpl.data
    entry.modified = time()
    profile.modified = time()
    if ns.RefreshUI then ns.RefreshUI() end
    return true
end

---------------------------------------------------------------------------
-- PRESET PROFILE ACCESSORS
---------------------------------------------------------------------------

--- Check if an ID refers to a preset profile
function ns.IsPresetProfile(id)
    if not id then return false end
    return id:sub(1, 7) == "preset:" and ns.presets[id] ~= nil
end

--- Get a preset profile by ID (same shape as globalProfiles entry)
function ns.GetPresetProfile(presetId)
    return ns.presets[presetId]
end

--- Get ordered list of preset profiles for UI display
function ns.GetPresetProfileList()
    local list = {}
    for _, id in ipairs(ns.presetOrder or {}) do
        local preset = ns.presets[id]
        if preset then
            local layoutCount = 0
            local classCount = 0
            for _, layouts in pairs(preset.layouts) do
                classCount = classCount + 1
                layoutCount = layoutCount + #layouts
            end
            list[#list + 1] = {
                uuid = id,
                name = preset.name,
                description = preset.description,
                author = preset.author,
                layoutCount = layoutCount,
                classCount = classCount,
                isPreset = true,
            }
        end
    end
    return list
end

--- Get layouts from a preset profile, optionally filtered by class
function ns.GetPresetLayouts(presetId, classFilter)
    local preset = ns.presets[presetId]
    if not preset then return {} end

    local result = {}
    for classToken, layouts in pairs(preset.layouts) do
        if not classFilter or classToken == classFilter then
            for i, entry in ipairs(layouts) do
                result[#result + 1] = {
                    class = classToken,
                    index = i,
                    name = entry.name,
                    spec = entry.spec,
                    data = entry.data,
                    isPreset = true,
                }
            end
        end
    end

    table.sort(result, function(a, b)
        if a.class ~= b.class then return a.class < b.class end
        return a.index < b.index
    end)
    return result
end

---------------------------------------------------------------------------
-- PRESET PROFILE ACTIONS
---------------------------------------------------------------------------

--- Copy an entire preset profile into a new editable user profile
function ns.CopyPresetToUserProfile(presetId)
    local preset = ns.presets[presetId]
    if not preset then return nil, "Preset not found." end

    local name = preset.name .. " (Copy)"
    local uuid, err = ns.CreateGlobalProfile(name, preset.description)
    if not uuid then return nil, err end

    local profile = ns.db.globalProfiles[uuid]
    local totalLayouts = 0

    for classToken, classLayouts in pairs(preset.layouts) do
        profile.layouts[classToken] = {}
        for _, entry in ipairs(classLayouts) do
            if entry.data and entry.data ~= "" then
                profile.layouts[classToken][#profile.layouts[classToken] + 1] = {
                    name = entry.name or "Layout",
                    spec = entry.spec,
                    data = entry.data,
                    created = time(),
                    modified = time(),
                }
                totalLayouts = totalLayouts + 1
            end
        end
    end

    if ns.RefreshUI then ns.RefreshUI() end
    return uuid, totalLayouts
end

--- Copy a single layout from a preset into the Template Library
function ns.CopyPresetLayoutToLibrary(presetId, class, index)
    local preset = ns.presets[presetId]
    if not preset then return nil, "Preset not found." end
    local layouts = preset.layouts[class]
    if not layouts or not layouts[index] then return nil, "Layout not found." end

    local entry = layouts[index]
    return ns.AddTemplate(entry.name, class, entry.spec, entry.data)
end

---------------------------------------------------------------------------
-- LOAD GLOBAL PROFILE INTO BLIZZARD
---------------------------------------------------------------------------

function ns.GetActiveGlobalProfileUUID()
    if not ns.charKey then return nil end
    ns.EnsureCharTables()
    return ns.db.characters[ns.charKey].activeGlobalProfile
end

function ns.SetActiveGlobalProfileUUID(uuid)
    if not ns.charKey then return end
    ns.EnsureCharTables()
    ns.db.characters[ns.charKey].activeGlobalProfile = uuid
end

--- Load a global profile: applies layouts for the current character's class to Blizzard CDM
function ns.LoadGlobalProfile(profileUUID)
    if not profileUUID then return false, "No profile specified." end
    if not ns.charKey then return false, "Character not ready." end
    if InCombatLockdown() then
        ns.pendingGlobalProfileLoad = profileUUID
        return false, "In combat. Queued for after."
    end
    if not ns.dataLoaded then return false, "CDM data not loaded yet." end

    local profile
    if ns.IsPresetProfile(profileUUID) then
        profile = ns.GetPresetProfile(profileUUID)
    else
        profile = ns.db.globalProfiles[profileUUID]
    end
    if not profile then return false, "Profile not found." end

    local classToken = ns.GetClassToken()
    local classLayouts = profile.layouts[classToken]

    if not classLayouts or #classLayouts == 0 then
        return false, "Profile has no layouts for " .. classToken .. "."
    end

    local lm = ns.GetLayoutManager()
    if not lm then return false, "Layout manager not available." end

    -- Auto-save current state into active profile before switching
    if ns.AutoSaveActiveProfile then ns.AutoSaveActiveProfile() end

    -- Clear stale name overrides before replacing layouts
    ns.EnsureCharTables()
    ns.db.layoutNameOverrides[ns.charKey] = {}

    -- Snapshot current C-level layout data so a failed load can be rolled back
    -- instead of leaving the character with no Cooldown Manager layouts.
    local preLoadSnapshot = C_CooldownViewer.GetLayoutData()

    -- Remove all existing Blizzard layouts
    local existingLayouts = ns.GetBlizzardLayouts()
    for i = #existingLayouts, 1, -1 do
        pcall(lm.RemoveLayout, lm, existingLayouts[i].id)
    end

    -- Add each layout from the profile and rename to match profile names
    local loaded = 0
    for _, entry in ipairs(classLayouts) do
        if entry.data and entry.data ~= "" and loaded < 5 then
            if lm.CreateLayoutsFromSerializedData then
                -- Snapshot existing layout IDs before creating
                local beforeIDs = {}
                pcall(function()
                    for layoutID in lm:EnumerateLayouts() do
                        beforeIDs[layoutID] = true
                    end
                end)

                local ok = pcall(lm.CreateLayoutsFromSerializedData, lm, entry.data)
                if ok then
                    loaded = loaded + 1

                    -- Find newly created layout and rename it
                    if entry.name and entry.name ~= "" then
                        pcall(function()
                            for layoutID, layout in lm:EnumerateLayouts() do
                                if not beforeIDs[layoutID] then
                                    if CooldownManagerLayout_SetName then
                                        pcall(CooldownManagerLayout_SetName, layout, entry.name)
                                    end
                                    ns.EnsureCharTables()
                                    ns.db.layoutNameOverrides[ns.charKey][layoutID] = entry.name
                                    break
                                end
                            end
                        end)
                    end
                end
            end
        end
    end

    if loaded == 0 then
        -- Roll back to the pre-load layouts (C-API write, no taint) so a failed
        -- load does not wipe the user's Cooldown Manager.
        if preLoadSnapshot and preLoadSnapshot ~= "" then
            pcall(C_CooldownViewer.SetLayoutData, preLoadSnapshot)
        end
        return false, "Failed to load any layouts. Data may be incompatible."
    end

    -- Persist Lua LayoutManager state to C level before reload
    pcall(lm.SaveLayouts, lm)

    ns.SetActiveGlobalProfileUUID(profileUUID)
    -- CDM now runs this exact version of the profile: record it as the applied baseline
    -- and clear any prior Mute for it.
    ns.EnsureCharTables()
    local cd = ns.db.characters[ns.charKey]
    ns.GetAutoSyncAppliedTable(cd)[profileUUID] = ns.ProfileDataHash(profile, classToken)
    ns.GetAutoSyncMuteTable(cd)[profileUUID] = nil
    if ns.RefreshUI then ns.RefreshUI() end
    StaticPopup_Show("CMP_RELOAD_UI")
    return true, loaded .. " layout(s) loaded for " .. classToken .. "."
end

--- Capture current Blizzard layouts into a global profile for the current class
function ns.SyncBlizzardToGlobalProfile(profileUUID)
    if not profileUUID then return false, "No profile specified." end
    if not ns.charKey then return false, "Character not ready." end
    if not ns.dataLoaded then return false, "CDM not loaded." end

    local profile = ns.db.globalProfiles[profileUUID]
    if not profile then return false, "Profile not found." end

    local classToken = ns.GetClassToken()
    local lm = ns.GetLayoutManager()
    if not lm then return false, "Layout manager not available." end

    local blizzLayouts = ns.GetBlizzardLayouts()
    if #blizzLayouts == 0 then return false, "No Blizzard layouts to capture." end

    -- Replace class layouts in profile with current Blizzard state
    profile.layouts[classToken] = {}
    local captured = 0

    for _, l in ipairs(blizzLayouts) do
        local data = nil
        if lm.GetSerializer then
            local serOk, serializer = pcall(lm.GetSerializer, lm)
            if serOk and serializer and serializer.SerializeLayouts then
                local dataOk, result = pcall(serializer.SerializeLayouts, serializer, l.id)
                if dataOk then data = result end
            end
        end
        if data and data ~= "" then
            profile.layouts[classToken][#profile.layouts[classToken] + 1] = {
                name = l.name or ("Layout " .. l.id),
                spec = ns.SpecFromSpecTag(l.specTag),
                specTagNum = l.specTagNum,
                data = data,
                created = time(),
                modified = time(),
            }
            captured = captured + 1
        end
    end

    profile.modified = time()
    -- Profile now mirrors the live CDM: record this version as the applied baseline and
    -- clear any prior Mute for it.
    ns.EnsureCharTables()
    local cd = ns.db.characters[ns.charKey]
    ns.GetAutoSyncAppliedTable(cd)[profileUUID] = ns.ProfileDataHash(profile, classToken)
    ns.GetAutoSyncMuteTable(cd)[profileUUID] = nil
    if ns.RefreshUI then ns.RefreshUI() end
    return true, captured .. " layout(s) captured for " .. classToken .. "."
end

---------------------------------------------------------------------------
-- Auto-Sync
---------------------------------------------------------------------------

--- Per-character map { [profileUUID] = true } of auto-sync targets the user has MUTED
--- on this character. Muted targets never prompt until un-muted (the "Mute" checkbox
--- next to the Auto-Sync dropdown). Cleared automatically when the profile is applied.
function ns.GetAutoSyncMuteTable(charData)
    if not charData.autoSyncMuted then charData.autoSyncMuted = {} end
    return charData.autoSyncMuted
end

--- Order-independent signature of a list of layout-name strings.
local function nameSignature(names)
    table.sort(names)
    return table.concat(names, "\31")
end

--- Signature of the layout NAMES a profile defines for one class. Names survive
--- apply/import unchanged (unlike serialized data, whose Blizzard layout IDs change),
--- so they reliably identify which profile a set of Cooldown Manager layouts came from.
function ns.ProfileNameSignature(profile, classToken)
    local layouts = profile and profile.layouts and profile.layouts[classToken]
    if not layouts or #layouts == 0 then return nil end
    local names = {}
    for _, entry in ipairs(layouts) do names[#names + 1] = entry.name or "" end
    return nameSignature(names)
end

--- Signature of the layout names currently live in the Blizzard Cooldown Manager.
function ns.CurrentCDMNameSignature()
    local names = {}
    for _, l in ipairs(ns.GetBlizzardLayouts()) do names[#names + 1] = l.name or "" end
    return nameSignature(names)
end

--- Per-character map { [profileUUID] = dataHash } recording the VERSION of a target
--- profile at the moment it was last applied/adopted on this character. Lets us detect
--- "the profile was edited since I applied it" (push profile updates to alts).
function ns.GetAutoSyncAppliedTable(charData)
    if not charData.autoSyncApplied then charData.autoSyncApplied = {} end
    return charData.autoSyncApplied
end

--- Content hash (djb2) of a profile's stored layouts for one class: name + spec + data.
--- This is a stored-vs-stored fingerprint (never re-serializes live CDM), so it is
--- robust to Blizzard's unstable layout IDs. It changes only when the profile is
--- genuinely edited (layout added/removed/renamed/reconfigured) or a preset is bumped.
function ns.ProfileDataHash(profile, classToken)
    local layouts = profile and profile.layouts and profile.layouts[classToken]
    if not layouts or #layouts == 0 then return nil end
    local MODULUS = 2147483648  -- 2^31, keeps the running hash within double precision
    local hash = 5381           -- djb2 seed
    local total = 0
    for _, entry in ipairs(layouts) do
        local sig = (entry.name or "") .. "\30" .. (entry.spec or "") .. "\31" .. (entry.data or "")
        total = total + #sig
        for i = 1, #sig do
            hash = (hash * 33 + sig:byte(i)) % MODULUS
        end
        hash = (hash * 33 + 1) % MODULUS  -- per-layout separator: fixes order and count
    end
    return string.format("%d:%x", total, hash)
end

--- Pure decision for auto-sync. No side effects, so it is safe to call from a
--- debug command. Returns an info table; info.decision is one of:
---   "no-target"        - auto-sync disabled
---   "missing-profile"  - target UUID no longer resolves
---   "no-class-layouts" - target profile has nothing for this class
---   "in-sync"          - the CDM already runs the target (or the user dismissed it)
---   "prompt"           - the CDM differs from the target -> show popup
function ns.EvaluateAutoSync()
    local info = { charKey = ns.charKey }

    local uuid = ns.db and ns.db.autoSyncProfile
    info.uuid = uuid
    if not uuid then info.decision = "no-target"; return info end

    local isPreset = ns.IsPresetProfile(uuid)
    info.isPreset = isPreset
    local profile = isPreset and ns.GetPresetProfile(uuid) or ns.GetGlobalProfile(uuid)
    if not profile then info.decision = "missing-profile"; return info end
    info.name = profile.name

    local classToken = ns.GetClassToken()
    info.class = classToken
    local layouts = profile.layouts and profile.layouts[classToken]
    if not layouts or #layouts == 0 then info.decision = "no-class-layouts"; return info end

    if not ns.charKey then info.decision = "no-target"; return info end
    ns.EnsureCharTables()
    local charData = ns.db.characters[ns.charKey]

    -- Detection: the CDM is out of sync if a DIFFERENT profile is loaded (layout names
    -- differ) OR the target was edited since it was applied here (version hash differs).
    -- Names read the live CDM; the version hash is stored-vs-stored (no unstable IDs).
    local targetSig = ns.ProfileNameSignature(profile, classToken)
    local cdmSig = ns.CurrentCDMNameSignature()
    local targetHash = ns.ProfileDataHash(profile, classToken)
    local appliedVer = ns.GetAutoSyncAppliedTable(charData)[uuid]
    info.targetSig = targetSig
    info.cdmSig = cdmSig
    info.targetHash = targetHash
    info.appliedVer = appliedVer

    local namesMatch = (cdmSig == targetSig)
    local versionStale = (appliedVer ~= nil and appliedVer ~= targetHash)
    info.outOfSync = (not namesMatch) or versionStale
    info.muted = ns.GetAutoSyncMuteTable(charData)[uuid] == true

    if not info.outOfSync then
        info.decision = "in-sync"
        -- Adopt the current version as the baseline the first time the CDM matches, so a
        -- later edit to the profile is detected as out-of-sync (recorded in CheckAutoSync).
        info.adoptVersion = (appliedVer == nil)
    elseif info.muted then
        info.decision = "in-sync"           -- suppressed by the per-character Mute
    else
        info.decision = "prompt"
        info.reason = namesMatch and "profile-updated" or "wrong-profile"
    end
    return info
end

--- Check if auto-sync should trigger. Runs once per session -- on a full login AND on
--- a /reload (the isInitialLogin gate was removed so reloads are covered). The per-
--- character Mute persists, so a muted profile never prompts until un-muted.
function ns.CheckAutoSync()
    if ns.autoSyncCheckedThisSession then return end

    -- Readiness guard: on /reload the data-loaded event can fire before the LayoutManager
    -- has enumerated the CDM layouts. Comparing names then sees an EMPTY live CDM and
    -- produces a false "differs". If the C-level store has layout data but lm reports
    -- none yet, retry shortly (bounded) instead of prompting -- and do NOT consume the
    -- once-per-session flag until we have a real reading.
    if #ns.GetBlizzardLayouts() == 0 and C_CooldownViewer then
        local okData, data = pcall(C_CooldownViewer.GetLayoutData)
        if okData and data and data ~= "" then
            ns.autoSyncReadyRetries = (ns.autoSyncReadyRetries or 0) + 1
            if ns.autoSyncReadyRetries <= 10 then
                C_Timer.After(0.5, ns.CheckAutoSync)
                return
            end
        end
    end

    ns.autoSyncCheckedThisSession = true

    local info = ns.EvaluateAutoSync()

    -- Adopt the current version as the baseline the first time we see the CDM already
    -- running the target (so later edits to the profile are detected as out-of-sync).
    if info.adoptVersion and info.uuid and info.targetHash and ns.charKey then
        ns.EnsureCharTables()
        ns.GetAutoSyncAppliedTable(ns.db.characters[ns.charKey])[info.uuid] = info.targetHash
    end

    if info.decision ~= "prompt" then return end
    -- Pass the evaluated target so the popup acts on exactly what was judged, not a live
    -- db.autoSyncProfile that may change before the user clicks.
    StaticPopup_Show("CMP_AUTO_SYNC", info.name, nil, { uuid = info.uuid })
end

--- Is the current auto-sync target muted on THIS character?
function ns.IsAutoSyncMuted()
    local uuid = ns.db and ns.db.autoSyncProfile
    if not uuid or not ns.charKey then return false end
    ns.EnsureCharTables()
    return ns.GetAutoSyncMuteTable(ns.db.characters[ns.charKey])[uuid] == true
end

--- Set or clear the Mute for the current target on this character. Un-muting re-runs the
--- check immediately, so the prompt reappears at once if the CDM is out of sync.
function ns.SetAutoSyncMuted(muted)
    local uuid = ns.db and ns.db.autoSyncProfile
    if not uuid or not ns.charKey then return end
    ns.EnsureCharTables()
    local muteTable = ns.GetAutoSyncMuteTable(ns.db.characters[ns.charKey])
    if muted then
        muteTable[uuid] = true
    else
        muteTable[uuid] = nil
        ns.autoSyncCheckedThisSession = false
        ns.autoSyncReadyRetries = 0
        if ns.CheckAutoSync then ns.CheckAutoSync() end
    end
end

--- Debug: clear this character's auto-sync mutes and applied-version baselines
--- (/cm debug reset). Use to re-arm the prompt after muting; the next check is fresh.
function ns.ResetAppliedHashes()
    if not ns.charKey then ns.Print("No character ready."); return end
    ns.EnsureCharTables()
    ns.db.characters[ns.charKey].autoSyncMuted = {}
    ns.db.characters[ns.charKey].autoSyncApplied = {}
    ns.db.characters[ns.charKey].autoSyncAck = nil  -- drop obsolete field
    ns.db.characters[ns.charKey].appliedProfileHash = nil  -- drop obsolete field
    ns.db.characters[ns.charKey].lastAppliedProfileModified = nil  -- drop obsolete field
    ns.Print("Cleared auto-sync state (mutes + applied versions) for this character.")
    ns.PrintAutoSyncDebug()
end

--- Debug: run the login auto-sync check on demand, exactly as a fresh login would
--- (/cm debug sync). Temporarily forces the login gate so the real CheckAutoSync ->
--- StaticPopup path runs without having to relog. Restores the flags afterward so the
--- real session is unaffected. Shows the popup if (and only if) it would genuinely nag.
function ns.SimulateAutoSyncCheck()
    ns.Print("Simulating login auto-sync check (forcing initial-login gate)...")
    local prevChecked = ns.autoSyncCheckedThisSession
    local prevInitial = ns.isInitialLogin
    ns.autoSyncCheckedThisSession = false
    ns.isInitialLogin = true
    ns.CheckAutoSync()
    ns.isInitialLogin = prevInitial
    ns.autoSyncCheckedThisSession = prevChecked
    ns.PrintAutoSyncDebug()
end

--- Print the auto-sync decision inputs for verification (/cm debug).
function ns.PrintAutoSyncDebug()
    local info = ns.EvaluateAutoSync()
    ns.Print("=== Auto-Sync Debug ===")
    print("  char: " .. tostring(info.charKey) .. "   class: " .. tostring(info.class))
    print("  target: " .. tostring(info.name) .. " (" .. tostring(info.uuid) .. ")"
        .. (info.isPreset and " |cFFE6CC80preset|r" or ""))
    print("  target names: |cFFFFFFFF" .. tostring(info.targetSig) .. "|r")
    print("  CDM names:    |cFFFFFFFF" .. tostring(info.cdmSig) .. "|r")
    print("  target version: |cFFFFFFFF" .. tostring(info.targetHash) .. "|r"
        .. "   applied: |cFFFFFFFF" .. tostring(info.appliedVer) .. "|r")
    print("  muted: |cFFFFFFFF" .. tostring(info.muted) .. "|r")
    if info.reason then print("  reason: |cFFFF9933" .. tostring(info.reason) .. "|r") end
    local willPrompt = info.decision == "prompt"
    local color = willPrompt and "|cFFFF4444" or "|cFF00FF00"
    print("  DECISION: " .. color .. tostring(info.decision) .. "|r"
        .. (willPrompt and "  (popup WOULD show)" or "  (no popup)"))
end

---------------------------------------------------------------------------
-- Print all
---------------------------------------------------------------------------

function ns.PrintAll()
    local active = ns.GetActiveProfileName()
    ns.Print("=== Profiles ===")
    local profiles = ns.GetProfileList()
    if #profiles == 0 then
        print("  (none)")
    else
        for _, p in ipairs(profiles) do
            local m = p.name == active and " |cFF00FF00(active)|r" or ""
            print("  " .. p.name .. m)
        end
    end

    ns.Print("=== Blizzard Layouts (active profile) ===")
    local blizz = ns.GetBlizzardLayouts()
    if #blizz == 0 then
        print("  (none)")
    else
        for _, l in ipairs(blizz) do
            print(string.format("  [%d] %s |cFF888888(%s)|r", l.id, l.name, l.specTag))
        end
    end

end

---------------------------------------------------------------------------
-- StaticPopup Dialogs
---------------------------------------------------------------------------

StaticPopupDialogs["CMP_RELOAD_UI"] = {
    text = "CM Profiles\n\nProfile loaded successfully.\nUI reload is required to apply layout changes.\n\n|cFF888888Blizzard's Cooldown Manager does not support live layout updates from addons. This workaround may be improved in future versions.|r",
    button1 = "Reload Now", button2 = "Later",
    timeout = 0, whileDead = true, hideOnEscape = true,
    OnAccept = function() ReloadUI() end,
}

StaticPopupDialogs["CMP_AUTO_SYNC"] = {
    text = "CM Profiles\n\nProfile \"%s\" has different layouts for your class.\n\n|cFFFF4444WARNING:|r Applying will replace ALL current\nCooldown Manager layouts and reload the UI.",
    button1 = "Apply & Reload",
    button2 = "Don't ask again",
    timeout = 0, whileDead = true, hideOnEscape = true,
    OnAccept = function(self, data)
        local uuid = data and data.uuid
        if uuid then
            local ok = ns.LoadGlobalProfile(uuid)  -- also clears the Mute for this profile
            if ok then ReloadUI() end
        end
    end,
    OnCancel = function(self, data)
        -- "Don't ask again" / ESC: mute auto-sync for this profile on this character. The
        -- "Mute" checkbox next to the Auto-Sync dropdown reflects and toggles this.
        if data and data.uuid and ns.charKey then
            ns.EnsureCharTables()
            ns.GetAutoSyncMuteTable(ns.db.characters[ns.charKey])[data.uuid] = true
            if ns.RefreshAutoSyncUI then ns.RefreshAutoSyncUI() end
        end
    end,
}

StaticPopupDialogs["CMP_SAVE_PROFILE"] = {
    text = "CM Profiles\nSave current state as profile:",
    button1 = "Save", button2 = "Cancel",
    hasEditBox = true, timeout = 0, whileDead = true, hideOnEscape = true,
    OnShow = function(self)
        local active = ns.GetActiveProfileName()
        self.EditBox:SetText(active or "")
        self.EditBox:HighlightText()
        self.EditBox:SetFocus()
    end,
    OnAccept = function(self)
        local name = (self.EditBox:GetText() or ""):match("^%s*(.-)%s*$")
        if name == "" then return end
        local ok, err = ns.SaveProfile(name, true)
        if not ok then ns.Print("|cFFFF0000Error:|r " .. err) end
    end,
    EditBoxOnEnterPressed = function(self)
        local p = self:GetParent()
        StaticPopupDialogs["CMP_SAVE_PROFILE"].OnAccept(p)
        p:Hide()
    end,
    EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}

StaticPopupDialogs["CMP_NEW_PROFILE"] = {
    text = "CM Profiles\nNew profile name:",
    button1 = "Create", button2 = "Cancel",
    hasEditBox = true, timeout = 0, whileDead = true, hideOnEscape = true,
    OnShow = function(self) self.EditBox:SetText(""); self.EditBox:SetFocus() end,
    OnAccept = function(self)
        local name = (self.EditBox:GetText() or ""):match("^%s*(.-)%s*$")
        if name == "" then return end
        local ok, err = ns.SaveProfile(name, false)
        if not ok and err then
            ns.Print("|cFFFF0000Error:|r " .. err)
        end
    end,
    EditBoxOnEnterPressed = function(self)
        local p = self:GetParent()
        StaticPopupDialogs["CMP_NEW_PROFILE"].OnAccept(p)
        p:Hide()
    end,
    EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}

StaticPopupDialogs["CMP_DELETE_PROFILE"] = {
    text = "CM Profiles\nDelete profile '%s'?",
    button1 = "Delete", button2 = "Cancel",
    timeout = 0, whileDead = true, hideOnEscape = true, showAlert = true,
    OnAccept = function(self, data)
        if not data then return end
        local ok, err = ns.DeleteProfile(data.name)
        if not ok then ns.Print("|cFFFF0000Error:|r " .. err) end
    end,
}

StaticPopupDialogs["CMP_RENAME_PROFILE"] = {
    text = "CM Profiles\nRename profile '%s':",
    button1 = "Rename", button2 = "Cancel",
    hasEditBox = true, timeout = 0, whileDead = true, hideOnEscape = true,
    OnShow = function(self, data)
        self.EditBox:SetText(data and data.oldName or "")
        self.EditBox:HighlightText()
        self.EditBox:SetFocus()
    end,
    OnAccept = function(self, data)
        if not data then return end
        local newName = (self.EditBox:GetText() or ""):match("^%s*(.-)%s*$")
        if newName == "" then return end
        local ok, err = ns.RenameProfile(data.oldName, newName)
        if not ok then ns.Print("|cFFFF0000Error:|r " .. err) end
    end,
    EditBoxOnEnterPressed = function(self)
        local p = self:GetParent()
        StaticPopupDialogs["CMP_RENAME_PROFILE"].OnAccept(p, p.data)
        p:Hide()
    end,
    EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}

---------------------------------------------------------------------------
-- Global Profile StaticPopup Dialogs
---------------------------------------------------------------------------

StaticPopupDialogs["CMP_NEW_GLOBAL_PROFILE"] = {
    text = "CM Profiles\nNew global profile name:",
    button1 = "Create", button2 = "Cancel",
    hasEditBox = true, timeout = 0, whileDead = true, hideOnEscape = true,
    OnShow = function(self) self.EditBox:SetText(""); self.EditBox:SetFocus() end,
    OnAccept = function(self)
        local name = (self.EditBox:GetText() or ""):match("^%s*(.-)%s*$")
        if name == "" then return end
        local uuid, err = ns.CreateGlobalProfile(name)
        if not uuid then
            ns.Print("|cFFFF0000Error:|r " .. (err or "unknown"))
        end
    end,
    EditBoxOnEnterPressed = function(self)
        local p = self:GetParent()
        StaticPopupDialogs["CMP_NEW_GLOBAL_PROFILE"].OnAccept(p)
        p:Hide()
    end,
    EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}

StaticPopupDialogs["CMP_DELETE_GLOBAL_PROFILE"] = {
    text = "CM Profiles\nDelete global profile '%s'?\nThis will remove it for all characters.",
    button1 = "Delete", button2 = "Cancel",
    timeout = 0, whileDead = true, hideOnEscape = true, showAlert = true,
    OnAccept = function(self, data)
        if not data then return end
        local ok, err = ns.DeleteGlobalProfile(data.uuid)
        if not ok then ns.Print("|cFFFF0000Error:|r " .. err) end
    end,
}

StaticPopupDialogs["CMP_RENAME_GLOBAL_PROFILE"] = {
    text = "CM Profiles\nRename global profile '%s':",
    button1 = "Rename", button2 = "Cancel",
    hasEditBox = true, timeout = 0, whileDead = true, hideOnEscape = true,
    OnShow = function(self, data)
        self.EditBox:SetText(data and data.oldName or "")
        self.EditBox:HighlightText(); self.EditBox:SetFocus()
    end,
    OnAccept = function(self, data)
        if not data then return end
        local n = (self.EditBox:GetText() or ""):match("^%s*(.-)%s*$")
        if n == "" then return end
        local ok, err = ns.RenameGlobalProfile(data.uuid, n)
        if not ok then ns.Print("|cFFFF0000Error:|r " .. err) end
    end,
    EditBoxOnEnterPressed = function(self)
        local p = self:GetParent()
        StaticPopupDialogs["CMP_RENAME_GLOBAL_PROFILE"].OnAccept(p, p.data)
        p:Hide()
    end,
    EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}

StaticPopupDialogs["CMP_DELETE_TEMPLATE"] = {
    text = "CM Profiles\nDelete template '%s'?",
    button1 = "Delete", button2 = "Cancel",
    timeout = 0, whileDead = true, hideOnEscape = true, showAlert = true,
    OnAccept = function(self, data)
        if not data then return end
        local ok, err = ns.DeleteTemplate(data.uuid)
        if not ok then ns.Print("|cFFFF0000Error:|r " .. err) end
    end,
}

StaticPopupDialogs["CMP_RENAME_TEMPLATE"] = {
    text = "CM Profiles\nRename template '%s':",
    button1 = "Rename", button2 = "Cancel",
    hasEditBox = true, timeout = 0, whileDead = true, hideOnEscape = true,
    OnShow = function(self, data)
        self.EditBox:SetText(data and data.oldName or "")
        self.EditBox:HighlightText(); self.EditBox:SetFocus()
    end,
    OnAccept = function(self, data)
        if not data then return end
        local n = (self.EditBox:GetText() or ""):match("^%s*(.-)%s*$")
        if n == "" then return end
        local ok, err = ns.RenameTemplate(data.uuid, n)
        if not ok then ns.Print("|cFFFF0000Error:|r " .. err) end
    end,
    EditBoxOnEnterPressed = function(self)
        local p = self:GetParent()
        StaticPopupDialogs["CMP_RENAME_TEMPLATE"].OnAccept(p, p.data)
        p:Hide()
    end,
    EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}

StaticPopupDialogs["CMP_RENAME_PROFILE_LAYOUT"] = {
    text = "CM Profiles\nRename layout '%s':",
    button1 = "Rename", button2 = "Cancel",
    hasEditBox = true, timeout = 0, whileDead = true, hideOnEscape = true,
    OnShow = function(self, data)
        self.EditBox:SetText(data and data.oldName or "")
        self.EditBox:HighlightText(); self.EditBox:SetFocus()
    end,
    OnAccept = function(self, data)
        if not data then return end
        local n = (self.EditBox:GetText() or ""):match("^%s*(.-)%s*$")
        if n == "" then return end
        local ok, err = ns.RenameLayoutInProfile(data.profileUUID, data.class, data.index, n)
        if not ok then ns.Print("|cFFFF0000Error:|r " .. err) end
    end,
    EditBoxOnEnterPressed = function(self)
        local p = self:GetParent()
        StaticPopupDialogs["CMP_RENAME_PROFILE_LAYOUT"].OnAccept(p, p.data)
        p:Hide()
    end,
    EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}

---------------------------------------------------------------------------
-- Import Conflict Resolution Dialogs
---------------------------------------------------------------------------

StaticPopupDialogs["CMP_IMPORT_PROFILE_CONFLICT"] = {
    text = "CM Profiles\nA profile named '%s' already exists.",
    button1 = "Create a Copy", button2 = "Cancel", button3 = "Overwrite",
    timeout = 0, whileDead = true, hideOnEscape = true,
    OnAccept = function(self, data)
        if not data then return end
        local ok, msg = ns.ApplyImportProfile(data.decoded, "copy")
        ns.Print(ok and ("|cFF00FF00" .. msg .. "|r") or ("|cFFFF0000Error:|r " .. msg))
    end,
    OnAlt = function(self, data)
        if not data then return end
        local ok, msg = ns.ApplyImportProfile(data.decoded, "overwrite", data.existingUUID)
        ns.Print(ok and ("|cFF00FF00" .. msg .. "|r") or ("|cFFFF0000Error:|r " .. msg))
    end,
}

StaticPopupDialogs["CMP_IMPORT_LAYERS_CONFLICT"] = {
    text = "CM Profiles\nThese layers already exist:\n%s",
    button1 = "Create Copies", button2 = "Cancel", button3 = "Overwrite",
    timeout = 0, whileDead = true, hideOnEscape = true,
    OnAccept = function(self, data)
        if not data then return end
        local ok, msg = ns.ApplyImportClassLayouts(data.decoded, data.profileUUID, "copy")
        ns.Print(ok and ("|cFF00FF00" .. msg .. "|r") or ("|cFFFF0000Error:|r " .. msg))
    end,
    OnAlt = function(self, data)
        if not data then return end
        local ok, msg = ns.ApplyImportClassLayouts(data.decoded, data.profileUUID, "overwrite")
        ns.Print(ok and ("|cFF00FF00" .. msg .. "|r") or ("|cFFFF0000Error:|r " .. msg))
    end,
}

StaticPopupDialogs["CMP_AUTHOR_URL"] = {
    text = "CM Profiles\nAuthor website — copy the URL below:",
    hasEditBox = true, button1 = "Close", timeout = 0, whileDead = true, hideOnEscape = true,
    OnShow = function(self)
        self.EditBox:SetText(self.data or "")
        self.EditBox:HighlightText()
        self.EditBox:SetFocus()
    end,
    EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
}
