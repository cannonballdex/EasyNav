# EasyNavGUI
Navigation GUI for MacroQuest
Setup:
Place the init.lua in the EasyNav folder
Place the zone_connections.ini in the EasyNav folder
Place the EasyNavGUI.lua in the lua folder

Command:
/lua run easynav shortzonename

or

Command To Start EasyNavGui:
/lua run EasyNavGui

You can create your own alias for yourself, group or all using eqbcs or dannet by typing the commands below.

Examples:
/alias /ez /lua run easynav
-To run easynav with the command /ez shortzonename

/alias /ezg /bcga //lua run easynav
-To tell your group to run easynav using eqbc /ezg shortzonename

/alias /eza /bcaa //lua run easynav
-To tell everyone connected to eqbc to run easynav /eza shortzonename

/alias /ezg /dgga /lua run easynav
-To tell your group to run easynav using dannet /ezg shortzonename

/alias /eza /dga /lua run easynav
-To tell everyone connected to dannet to run easynav /eza shortzonename

Running easynav without a specified zone will give you a list of available shortnames for the zone.
Will use Magus, Priest of Discord, Translocators, Griffon Handlers, Herald,
Provided you set up the alias as /ez
Most instance zone you can just run /ez leave
Some zones are set up to navigate floors, /ez floor1, /ez floor2 and so on.
Disclaimer: This is work in progress and use at your own risk. I will not be held responsible for broken links or missing zone connections or if you type /ez poknowledge and end up in the guild lobby.
I know braniac is working on easyfind, but until then...

UPDATE: Just a side note, there really is no need to edit the easynavgui unless you want to use eqbc for your group and all navigation. Then you would just change the' /dgge /lua run easynav' to '/bcga //lua run easynav' and the '/dga /lua run easynav' to '/bcaa //lua run easynav'
The default will already run DanNet without any any aliases.
