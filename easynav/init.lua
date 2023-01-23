-- easynav.lua - v1.2 - 08/18/2021
-- Thanks to Vsab for getting me started on this, he said "Populating the ini is a ballache" He was right.
-- TODO: Finish Zone Connections
-- updated 08/25/2021 - Boards the boats in TDS
-- updated 09/12/2021 - Magus travel to butcher with now say Butcherblock to Magus
-- Added entrance zones for LDON to the connections ini for easynavgui
-- updated 09/13/2021 - Boards the Blimp between argath and steamfont mountains

local mq = require('mq')
local arg = {...}
--print(arg[1])
print('\agRunning \apEasy Nav \at1.5 \ayby \agCannonballdex')
local zone_id = mq.TLO.Zone.ID()
print('\atStarting \apZone ID \ay=\ag ' .. tostring(zone_id))
local ini_file = mq.TLO.MacroQuest.Path() .. "\\lua\\easynav\\zone_connections.ini"
local destination = arg[1]
local function isempty(s)
    return s == nil or s == ''
end
if isempty(destination) then
    destination = ""
    print('\arYou need to specify a destination')
  end

local active_zone

if active_zone ~= mq.TLO.Zone.ID() then
    active_zone = mq.TLO.Zone.ID()
end
local zone_name = mq.TLO.Ini(ini_file,tostring(zone_id),'ZoneName')()

if isempty(zone_name) then
    print('\ayNo Entries for ' .. mq.TLO.Zone.ShortName() .. '(' .. tostring(zone_id)..')')
    mq.exit()
else
    print('\atFinding \apConnection \ayin \ag ' .. zone_name)
end
print('\atRequested \apDestination \ay=\ag ' ..  tostring(destination))
local item_count = mq.TLO.Ini(ini_file, tostring(zone_id), 'Connections')()
local connections = {}
-- Iterate now
for i=1, item_count do
    local myzone = mq.TLO.Ini(ini_file, tostring(zone_id), 'Connection' .. tostring(i).. 'Zone')()
    if not isempty(myzone) then
        local zone = mq.TLO.Ini(ini_file, tostring(zone_id), 'Connection' .. tostring(i).. 'Zone')()
        local loc = mq.TLO.Ini(ini_file, tostring(zone_id), 'Connection' .. tostring(i).. 'Loc')()
        local face = mq.TLO.Ini(ini_file, tostring(zone_id), 'Connection' .. tostring(i).. 'Face')()
        local obj = mq.TLO.Ini(ini_file, tostring(zone_id), 'Connection' .. tostring(i).. 'Object')()
        local clickwindow = mq.TLO.Ini(ini_file, tostring(zone_id), 'Connection' .. tostring(i).. 'ClickWindow')()
        local twoclickwindow = mq.TLO.Ini(ini_file, tostring(zone_id), 'Connection' .. tostring(i).. 'TwoClickWindow')()
        local threeclickwindow = mq.TLO.Ini(ini_file, tostring(zone_id), 'Connection' .. tostring(i).. 'ThreeClickWindow')()
        local npcname = mq.TLO.Ini(ini_file, tostring(zone_id), 'Connection' .. tostring(i).. 'NPCName')()

        connections[zone] = {
            Zone=zone,
            Loc=loc,
            Face=face,
            Obj=obj,
            ClickWindow=clickwindow,
            TwoClickWindow=twoclickwindow,
            ThreeClickWindow=threeclickwindow,
            NPCName=npcname
        }
    end
end

-- If object CLICKDOOR nav first to platform then click door
if connections[destination].Loc ~= 'NULL' then
print('Moving to '.. connections[destination].Loc)
mq.cmdf('/nav loc %s', connections[destination].Loc)
mq.delay(2000)
    while mq.TLO.Me.Moving() do
        mq.delay(1000)
    end
end

if connections[destination].Loc == 'NULL' then
    print('Moving to '.. connections[destination].NPCName)
    mq.cmdf('/nav spawn %s', connections[destination].NPCName)
    mq.delay(2000)
        while mq.TLO.Me.Moving() do
            mq.delay(1000)
        end
    end

if connections[destination].ClickWindow == 'NULL' and connections[destination].Obj == 'NULL' and connections[destination].NPCName == 'NULL' and connections[destination].Loc ~= 'NULL' then
    if connections[destination].Face ~='NULL' then
        mq.cmdf('/face fast heading %s', connections[destination].Face)
        mq.delay(1000)
    end
    mq.cmd('/keypress forward hold')
    mq.delay(2000)
    mq.cmd('/keypress forward')
end

if connections[destination].ClickWindow == 'NULL' and connections[destination].Loc == 'NULL' and connections[destination].Obj ~= 'NULL' and connections[destination].NPCName == 'NULL' then
    print('Moving to '.. connections[destination].Obj)
    mq.cmdf('/nav door %s', connections[destination].Obj)
    mq.delay(2000)
    while mq.TLO.Me.Moving() do
        mq.delay(1000)
    end
end

if connections[destination].ClickWindow == 'NULL' and connections[destination].Obj =='EXITDOOR' and connections[destination].NPCName == 'NULL' then
    mq.cmdf('/doortarget')
    mq.delay(1000)
    mq.cmd('/click left door')
    print('Zoning...')
end

if connections[destination].ClickWindow == 'NULL' and connections[destination].Obj =='CLICKDOOR' and connections[destination].NPCName == 'NULL' then
    if connections[destination].Face ~='NULL' then
        mq.cmdf('/face fast heading %s', connections[destination].Face)
        mq.delay(1000)
    end
    mq.cmd('/keypress forward hold')
    mq.delay(2000)
    mq.cmd('/keypress forward')
    mq.cmd.doortarget()
    mq.delay(1000)
    mq.cmd('/click left door')
    print('Zoning...')
end
if connections[destination].ClickWindow == 'NULL' and connections[destination].Obj =='THECHASTEBARON' and connections[destination].NPCName == 'NULL' then
    while not mq.TLO.Spawn("The Chaste Baron")() or mq.TLO.Spawn("The Chaste Baron").Distance() > 80 do
        mq.delay(1000)
      end
    if mq.TLO.Spawn("The Chaste Baron").Distance() < 80 then
        if connections[destination].Face ~='NULL' then
            mq.cmdf('/face fast heading %s', connections[destination].Face)
            mq.delay(1000)
        end
        mq.cmd('/keypress forward hold')
        mq.delay(1000)
        mq.cmd('/keypress forward')
        mq.exit()
    end
end
if connections[destination].ClickWindow == 'NULL' and connections[destination].Obj =='INDESTRUCTIBLE' and connections[destination].NPCName == 'NULL' then
    while not mq.TLO.Spawn("Indestructible Veilbreaker Mk.II")() or mq.TLO.Spawn("Indestructible Veilbreaker Mk.II").Distance() > 115 do
        mq.delay(1000)
      end
    if mq.TLO.Spawn("Indestructible Veilbreaker Mk.II").Distance() < 115 then
        if connections[destination].Face ~='NULL' then
            mq.cmdf('/face fast heading %s', connections[destination].Face)
            mq.delay(1000)
        end
        mq.delay(12000)
        mq.cmd('/keypress forward hold')
        mq.delay(1000)
        mq.cmd('/keypress forward')
        mq.exit()
    end
end
if connections[destination].ClickWindow == 'NULL' and connections[destination].Obj =='BLOODWAIL' and connections[destination].NPCName == 'NULL' then
    while not mq.TLO.Spawn("Bloodwail")() or mq.TLO.Spawn("Bloodwail").Distance() > 100 do
        mq.delay(1000)
      end
    if mq.TLO.Spawn("Bloodwail").Distance() < 100 then
        if connections[destination].Face ~='NULL' then
            mq.cmdf('/face fast heading %s', connections[destination].Face)
            mq.delay(1000)
        end
        mq.cmd('/keypress forward hold')
        mq.delay(1000)
        mq.cmd('/keypress forward')
        mq.exit()
    end
end
-- Special Considerations for other methods of traveling Magus, Translocator, Priest, Griffon Handlers, Elevators
if not isempty(connections[destination].Obj) and connections[destination].Obj ~='NULL' and connections[destination].Obj ~='CLICKDOOR' then
    mq.cmdf('/doortarget %s', connections[destination].Obj)
    mq.delay(2000)
    mq.cmd('/click left door')
    print('Zoning...')
end

if not isempty(connections[destination].ClickWindow) and connections[destination].ClickWindow ~='NULL' then
    print('Clicking the '.. connections[destination].ClickWindow ..' button')
    mq.delay(3000)
    mq.cmdf('/notify LargeDialogWindow %s leftmouseup', connections[destination].ClickWindow)
end

if not isempty(connections[destination].TwoClickWindow) and connections[destination].TwoClickWindow ~='NULL' then
    print('Clicking the '.. connections[destination].TwoClickWindow ..' button')
    mq.delay(3000)
    mq.cmdf('/notify RealEstateNeighborhoodWnd %s leftmouseup', connections[destination].TwoClickWindow)
end

if not isempty(connections[destination].ThreeClickWindow) and connections[destination].ThreeClickWindow ~='NULL' then
    print('Clicking the '.. connections[destination].ThreeClickWindow ..' button')
    mq.delay(3000)
    mq.cmdf('/notify RealEstateNeighborhoodWnd %s leftmouseup', connections[destination].ThreeClickWindow)
    print('Zoning...')
end

if not isempty(connections[destination].NPCName) and connections[destination].NPCName ~='NULL' then
    mq.cmd('/makemevisible')
    print('Talking to '.. connections[destination].NPCName)
    mq.cmdf('/target %s', connections[destination].NPCName)
    mq.delay(2000)
    mq.cmd('/say hail')
    mq.delay(2000)
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='nexus' and mq.TLO.Zone.ID() ~=(794) then
        mq.cmd('/makemevisible')
        mq.cmd('/say journey to luclin')
        mq.delay(2000)
        mq.cmd.autoinventory()
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='nexus' and mq.TLO.Zone.ID() ==(794) then
        mq.cmd('/makemevisible')
        mq.cmd('/say spire stone of lceanium')
        mq.delay(2000)
        mq.cmd.autoinventory()
        mq.cmd('/nav loc 1349.50 1457.24 -55.39')
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='lceanium' and mq.TLO.Zone.ID() ==(152) then
        mq.cmd('/makemevisible')
        mq.cmd('/say spire stone of lceanium')
        mq.delay(2000)
        mq.cmd.autoinventory()
        mq.cmd('/nav loc 0.69 -4.05 -30.24')
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='southro' then
        mq.cmd('/makemevisible')
        mq.cmd('/say South Ro')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='butcher' then
        mq.cmd('/makemevisible')
        mq.cmd('/say Butcherblock')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='iceclad' then
        mq.cmd('/makemevisible')
        mq.cmd('/say travel to Iceclad')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='timorous' then
        mq.cmd('/makemevisible')
        mq.cmd('/say travel to Timorous Deep')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) 
        and connections[destination].Zone =='northro' 
        and mq.TLO.Zone.ID() ~=(824) then
        mq.cmd('/makemevisible')
        mq.cmd('/say North Ro')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='oceanoftears' then
        mq.cmd('/makemevisible')
        mq.cmd('/say Ocean of Tears')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='instance' then
        mq.cmd('/makemevisible')
        mq.cmd('/say i am ready to board the ship')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='dragonscale' then
        mq.cmd('/makemevisible')
        mq.cmd('/say depart')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='potimea' then
        mq.cmd('/makemevisible')
        mq.cmd('/say time')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) 
        and connections[destination].Zone =='poknowledge' 
        and mq.TLO.Zone.ID() ==(219) then
        mq.cmd('/makemevisible')
        mq.cmd('/say send')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone =='abysmal' then
        mq.cmd('/makemevisible')
        mq.cmd('/say abysmal sea')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) 
        and connections[destination].Zone =='draniksscar' 
        and (mq.TLO.Zone.ID() ==(202) or mq.TLO.Zone.ID() ==(203)) then
        mq.cmd('/makemevisible')
        mq.cmd('/say wish to go to discord')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) 
        and connections[destination].Zone =='qvic' 
        and mq.TLO.Zone.ID() ==(280) then
        mq.cmd('/makemevisible')
        mq.cmd('/say wish to travel')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) 
        and (connections[destination].Zone =='northro' or connections[destination].Zone =='eastwastestwo') 
        and (mq.TLO.Zone.ID() ==(392) or mq.TLO.Zone.ID() ==(824)) then
        mq.cmd('/makemevisible')
        mq.cmd('/say get on')
        print('Zoning...')
    end

    if not isempty(connections[destination].Zone) 
        and connections[destination].Zone =='poknowledge' 
        and mq.TLO.Zone.ID() ==(302) then
        mq.cmd('/makemevisible')
        mq.cmd('/say go home')
        print('Zoning...')
    end
    if not isempty(connections[destination].Zone) and connections[destination].Zone ~='oceanoftears' 
        and connections[destination].Zone ~='northro' 
        and connections[destination].Zone ~='southro' 
        and connections[destination].Zone ~='nexus' 
        and connections[destination].Zone ~='instance' 
        and connections[destination].Zone ~='dragonscale' 
        and connections[destination].Zone ~='potimea' 
        and connections[destination].Zone ~='poknowledge' 
        and connections[destination].Zone ~='draniksscar' 
        and connections[destination].Zone ~='eastwastestwo' 
        and connections[destination].Zone ~='qvic' 
        and connections[destination].Zone ~='abysmal' 
        and connections[destination].Zone ~='lceanium' 
        and connections[destination].Zone ~='iceclad' 
        and connections[destination].Zone ~='timorous' 
        and connections[destination].Zone ~='butcher' then
        mq.cmd('/makemevisible')
        mq.cmdf('/say %s', connections[destination].Zone)
        print('Zoning...')
    end
end




