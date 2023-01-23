-- easynavgui.lua by Cannonballdex
-- With a Big thank you to SpecialED
-- This is set up to be used as a gui for the easynav.lua
-- Provided you set up the alias /ez or /ezg or eza or you can simply use the default /lua run easynav
-- Change "mq.cmdf('/dgga ) to the alias you want to use /ez /ezg /eza /bcga
-- The default will use dannet
-- Added the Stop command to stop navigation on all
-- Version 1.4 Sept 8, 2021 Cannonballdex
-- Column titles will displayed again
-- ShortName column is now adjustable width
-- EasyNavGui will now close when logging out of game
-- Added Nav to my zone using easyfind all or group
---@type Mq
local mq = require('mq')
require 'ImGui'
local ini_file = mq.TLO.MacroQuest.Path() .. "\\lua\\easynav\\zone_connections.ini"
local TEXT_BASE_HEIGHT = ImGui.GetTextLineHeightWithSpacing();
local openGUI = true
local shouldDrawGUI = true
local zone_items
local active_zone
local Travelto = ""

local load_zone_connections = function(zone_id)
    local connections = {}
    local connection
    local i = 1
    repeat
        connection = mq.TLO.Ini(ini_file, zone_id, string.format('Connection%dZone', i))()
        if connection ~= nil then
            table.insert(connections, { ShortName = connection })
            i  = i + 1
        end
    until connection == nil
    return connections
end

local ColumnID_ShortName = 0
local ColumnID_Me = 1
local ColumnID_Group = 2
local ColumnID_All = 3

local function ShowTableZone()
    if ImGui.TreeNode('Zone Connections') then
        if active_zone ~= mq.TLO.Zone.ID() then
            active_zone = mq.TLO.Zone.ID()
            zone_items = load_zone_connections(active_zone)
        end
        local flags = bit32.bor(ImGuiTableFlags.Resizable, ImGuiTableFlags.Reorderable, ImGuiTableFlags.Hideable, ImGuiTableFlags.MultiSortable,
            ImGuiTableFlags.RowBg, ImGuiTableFlags.BordersOuter, ImGuiTableFlags.BordersV, ImGuiTableFlags.NoBordersInBody, ImGuiTableFlags.ScrollY)
        if ImGui.BeginTable('##table', 4, flags, 0, TEXT_BASE_HEIGHT * 15, 0.0) then
            -- Declare columns
            ImGui.TableSetupColumn('ShortName', bit32.bor(ImGuiTableColumnFlags.NoSort, ImGuiTableColumnFlags.WidthFixed), -1.0, ColumnID_ShortName)
            ImGui.TableSetupColumn('Send', bit32.bor(ImGuiTableColumnFlags.NoSort, ImGuiTableColumnFlags.WidthFixed), -1.0, ColumnID_Me)
            ImGui.TableSetupColumn('Send', bit32.bor(ImGuiTableColumnFlags.NoSort, ImGuiTableColumnFlags.WidthFixed), -1.0, ColumnID_Group)
            ImGui.TableSetupColumn('Send', bit32.bor(ImGuiTableColumnFlags.NoSort, ImGuiTableColumnFlags.WidthFixed), -1.0, ColumnID_All)
            ImGui.TableSetupScrollFreeze(0, 1) -- Make row always visible

            -- Display zone data
            ImGui.TableHeadersRow()
            ImGui.TableNextColumn()

            local clipper = ImGuiListClipper.new()
            clipper:Begin(#zone_items)
            while clipper:Step() do
                for row_n = clipper.DisplayStart, clipper.DisplayEnd - 1, 1 do
                    local item = zone_items[row_n + 1]
                    ImGui.PushID(item)
                    ImGui.TableNextColumn()
                    ImGui.Text(item.ShortName)
                    ImGui.TableNextColumn()
                    if ImGui.Button('Me') then
                        mq.cmdf('/lua run easynav %s', item.ShortName)
                        print('\ayGoing solo to \ag' .. item.ShortName)
                    end
                    ImGui.TableNextColumn()
                    if ImGui.Button('Group') then
                        mq.cmdf('/dgge /lua run easynav %s', item.ShortName)
                        print('\aySending group to \ag' .. item.ShortName)
                    end
                    ImGui.TableNextColumn()
                    if ImGui.Button('Everyone') then
                        mq.cmdf('/dga /lua run easynav %s', item.ShortName)
                        print('\ayEveryone is going to \ag' .. item.ShortName)
                    end
                    ImGui.PopID()
                end
            end
            ImGui.EndTable()
        end
        ImGui.TreePop()
    end
end

-- Converted from imgui_demo.cpp
local function WindowTables()
    if not ImGui.CollapsingHeader('Available Zones for ' .. mq.TLO.Zone.ShortName()) then
        return
    end
    ImGui.Separator()
    if ImGui.Button('Stop Me') then
        mq.cmd('/lua stop easynav')
        mq.cmd('/nav stop')
        print('\ayStopping Navigation')
    end
    ImGui.SameLine()
    if ImGui.Button('GrpToMyZone') then
        mq.cmd('/dgge /travelto', mq.TLO.Zone.ShortName())
        print('\ayGroup Nav To My Zone')
    end
    ImGui.SameLine()
    if ImGui.Button('GrpNavToMe') then
        mq.cmd('/dgge /nav spawn', mq.TLO.Me.CleanName())
        print('\ayGroup Move To Me')
    end
    ImGui.Separator()
    if ImGui.Button('Stop All') then
        mq.cmd('/lua stop easynav')
        mq.cmd('/nav stop')
        mq.cmd('/dge /lua stop easynav')
        mq.cmd('/dge /nav stop')
        print('\ayStopping Navigation')
    end
    ImGui.SameLine()
    if ImGui.Button('AllToMyZone') then
        mq.cmd('/dge /travelto', mq.TLO.Zone.ShortName())
        print('\ayEveryone To My Zone')
    end
    ImGui.SameLine()
    if ImGui.Button('AllNavToMe') then
        mq.cmd('/dge /nav spawn', mq.TLO.Me.CleanName())
        print('\ayEveryone Move To Me')
    end
    ImGui.Separator()
    ImGui.Text('Travelto: ')
    ImGui.SameLine()
    ImGui.SetCursorPosX(65)
    ImGui.PushItemWidth(125)
    Travelto,_ = ImGui.InputText('##Travelto', Travelto)
    ImGui.SameLine()
    if ImGui.Button('Me') then
        mq.cmd('/travelto', Travelto)
    end
    ImGui.SameLine()
    if ImGui.Button('Grp') then
        mq.cmd('/dgge /travelto', Travelto)
    end
    ImGui.SameLine()
    if ImGui.Button('All') then
        mq.cmd('/dge /travelto', Travelto)
    end
    ImGui.Separator()
    ImGui.PushID('Tables')
    ShowTableZone()
    ImGui.PopID()
end
function ZoneTablesGUI()
    if not openGUI then return end
    openGUI, shouldDrawGUI = ImGui.Begin('EasyNavGui v1.5 by Cannonballdex', openGUI)
    if shouldDrawGUI then
        WindowTables()
    end
    ImGui.End()
end
ImGui.Register('ZoneTablesGUI', ZoneTablesGUI)

local function CheckGameState()
    if mq.TLO.MacroQuest.GameState() ~= 'INGAME' then
        print('\arNot in game, stopping easynavgui.\ax')
        openGUI = false
        shouldDrawGUI = false
        mq.imgui.destroy('ZoneTablesGUI')
        mq.exit()
    end
end
while openGUI do
    CheckGameState()
    mq.delay(2000) -- equivalent to '2s'
end