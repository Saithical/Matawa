-- MTW: GUI functions

mtw_struct.load_external("GUI/geyser")

mtw_struct.load_external("GUI/config")

function mtw.GUI_toggle()
 if mtw.cgui.enabled then
  mtw.gui_mt = mtw.gui_mt or {}
  mtw.cgui.enabled = false
  for k,_ in pairs(mtw.gui.win_list) do
   if mtw.cgui[k.."_enabled"] then
    mtw.gui.disable_window(k)
   end
  end
  mtw.gui_mt.__call = function (...) return nil end
  mtw.gui_mt.__index = function (k,v)
    local z = {}
    return setmetatable(z, mtw.gui_mt)
   end
  mtw.gui_mt.__newindex = function (k,v,t)
   end
  setmetatable(mtw.gui, mtw.gui_mt)
  cecho("\n<red>WARNING:\n<green>All windows have been hidden. to disable the whole GUI, please restart your client.\n")
 else
  mtw.cgui.enabled = true
  mtw.gui_mt = mtw.gui_mt or {}
  mtw.gui_mt.__newindex = nil
  mtw.gui_mt.__call = nil
  mtw.gui_mt.__index = nil
  setmetatable(mtw.gui, mtw.gui_mt)
  mtw_struct.reload_external("GUI/init")
  for k,_ in pairs(mtw.gui.win_list) do
   if not mtw.cgui[k.."_enabled"] then
    mtw.gui.enable_window(k)
   end
  end
 end
end

function mtw.GUI_aliases()
 cecho("\n<green>GUI commands:")
 echo("\n ?gui: this alias")
 echo("\n tgui: enable/disable the GUI. Disabling the GUI needs a client restart.")
 echo("\n rgui: refresh the GUI. If there's a problem, it forces all redrawing.")
 cecho("\n <yellow>Window resizing:")
 echo("\n  tgui-lbar/tgui-rbar/tgui-bbar <Xpx or X%>: left/right/bottom bar")
 echo("\n  tgui-chat-height X / tgui-ih-height X / tgui-aff-height X: chat window/IH window/afflictions window relative heights")
 cecho("\n <yellow>Window toggling:")
 echo("\n  tgui-chat / tgui-mapper: right sided windows")
 echo("\n  tgui-gauges: the status gauges. tgui-Ygauge where Y is either hp/ep/ap/pp/xp toggles a specific gauge")
 echo("\n  tgui-loc: the bottom bar with information on the current room")
 echo("\n  tgui-ih / tgui-aff / tgui-who: the large left sided windows")
 echo("\n  tgui-info / tgui-version / tgui-targ: the small left top windows")
 echo("\n  tgui-map-type: toggle between geyser mapper and window using MAP output")
 cecho("\n <yellow>Other commands:")
 echo("\n  tgui-chat-font-size X: Change the chat window font size (requires a restart)")
 echo("\n  tgui-chat-labels-per-line X: Change the number of labels printed on one line of tabs, for the chat window (requires a restart)")
 echo("\n  tgui-exp-ih y/n: Enable or not the possibility to expand each item in the IH window to get their ID")
 echo("\n  tgui-click-name X: Sets to X the action to do when you click a name in the WHO HERE window. %s will be replaced by the name")
 echo("\n  tgui-add-chat-tab X [n]: Adds a chat tab named X at position n (or at the end if you didn't specify a position) (requires a restart)")
 echo("\n  tgui-rm-chat-tab X: Removes chat tab named X (requires a restart)")
 echo("\n  tgui-mv-chat-tab X n: Moves a chat tab named X at position n (requires a restart)")
end

if mtw.cgui.enabled then
 mtw.gui = mtw.gui or {}

 mtw_struct.load_external("GUI/utils")
 mtw.gui.update_window_size()

 mtw_struct.load_external("GUI/rootwin")

 --here happens the magic!
 mtw_struct.load_external("GUI/windows")

 --we construct the three main containers (left/right/bottom) in there
 mtw_struct.load_external("GUI/mainwindows")

 --now we create the actual windows :)
 mtw_struct.load_external("GUI/bars")
 mtw_struct.load_external("GUI/chat")
 mtw_struct.load_external("GUI/mapper")
 mtw_struct.load_external("GUI/infobar")

 mtw.gui.root:resize_children()

 --this one needs to be loaded after all the windows have been created
 mtw_struct.load_external("GUI/toggle")

else
 -- we just want to prevent any call to the GUI when it's not enabled
 mtw.gui = {}
 mtw.gui_mt = {}
 mtw.gui_mt.__newindex = function (k,v,t)
  end
 mtw.gui_mt.__call = function (...) return nil end
 mtw.gui_mt.__index = function (k,v)
   local z = {}
   return setmetatable(z, mtw.gui_mt)
  end
 setmetatable(mtw.gui,mtw.gui_mt)
end
