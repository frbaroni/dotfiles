-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Theme handling library
local beautiful = require("beautiful")
-- Standard awesome library
-- Define theme font
local font_family = "CaskaydiaCove Nerd Font Mono"
local theme_font = font_family .. " 10"
local icon_font = font_family .. " 14"
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local lain = require("lain")
local markup = lain.util.markup
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "zenburn/theme.lua")
-- Set up font with icons
beautiful.font = theme_font

-- This is used later as the default terminal and editor to run.
local terminal = "kitty"
local editor = os.getenv("EDITOR") or "nvim"
local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile.right,
    awful.layout.suit.floating,
    awful.layout.suit.tile.top,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

-- Create a power management menu
local powermenu = {
    { "Shutdown Now", "systemctl poweroff" },
    { "Restart Now", "systemctl reboot" },
    { "Shutdown in 30 min", "shutdown -h +30" },
    { "Cancel Scheduled Shutdown", "shutdown -c" },
    { "Suspend", "systemctl suspend" },
    { "Hibernate", "systemctl hibernate" },
    { "Lock Screen", "bash -c '~/dotfiles/lock.sh'" },
}

-- Function to get all applications from .desktop files with icons
local function get_applications()
    local apps = {}
    local desktop_dirs = {
        os.getenv("HOME") .. "/.local/share/applications/",
        "/usr/share/applications/"
    }
    
    -- Function to find icon path
    local function find_icon(icon_name)
        if not icon_name then return nil end
        
        -- If icon path is absolute
        if icon_name:sub(1, 1) == "/" and gears.filesystem.file_readable(icon_name) then
            return icon_name
        end
        
        -- Remove file extension if present
        local name = icon_name:gsub("%.png$", ""):gsub("%.svg$", ""):gsub("%.xpm$", "")
        
        -- Common icon directories
        local icon_dirs = {
            "/usr/share/icons/hicolor/scalable/apps/",
            "/usr/share/icons/hicolor/48x48/apps/",
            "/usr/share/icons/hicolor/32x32/apps/",
            "/usr/share/icons/hicolor/24x24/apps/",
            "/usr/share/icons/hicolor/16x16/apps/",
            "/usr/share/pixmaps/",
            "/usr/share/icons/",
            os.getenv("HOME") .. "/.local/share/icons/hicolor/scalable/apps/",
            os.getenv("HOME") .. "/.local/share/icons/hicolor/48x48/apps/",
            os.getenv("HOME") .. "/.local/share/icons/hicolor/32x32/apps/",
            os.getenv("HOME") .. "/.local/share/icons/hicolor/24x24/apps/",
            os.getenv("HOME") .. "/.local/share/icons/hicolor/16x16/apps/",
            os.getenv("HOME") .. "/.local/share/icons/",
        }
        
        -- Check for icon in all directories
        for _, dir in ipairs(icon_dirs) do
            local extensions = { "", ".png", ".svg", ".xpm" }
            for _, ext in ipairs(extensions) do
                local icon_path = dir .. name .. ext
                if gears.filesystem.file_readable(icon_path) then
                    return icon_path
                end
            end
        end
        
        -- Try to find icon in current icon theme
        local icon_theme = "Adwaita" -- Default fallback theme
        local theme_file = io.open(os.getenv("HOME") .. "/.config/gtk-3.0/settings.ini", "r")
        if theme_file then
            for line in theme_file:lines() do
                if line:match("^gtk%-icon%-theme%-name=") then
                    icon_theme = line:match("^gtk%-icon%-theme%-name=(.+)$")
                    break
                end
            end
            theme_file:close()
        end
        
        local theme_dirs = {
            "/usr/share/icons/" .. icon_theme .. "/scalable/apps/",
            "/usr/share/icons/" .. icon_theme .. "/48x48/apps/",
            "/usr/share/icons/" .. icon_theme .. "/32x32/apps/",
            "/usr/share/icons/" .. icon_theme .. "/24x24/apps/",
            "/usr/share/icons/" .. icon_theme .. "/16x16/apps/",
        }
        
        for _, dir in ipairs(theme_dirs) do
            local extensions = { "", ".png", ".svg", ".xpm" }
            for _, ext in ipairs(extensions) do
                local icon_path = dir .. name .. ext
                if gears.filesystem.file_readable(icon_path) then
                    return icon_path
                end
            end
        end
        
        return nil
    end
    
    -- Process desktop files
    for _, dir in ipairs(desktop_dirs) do
        local p = io.popen('find "' .. dir .. '" -name "*.desktop" 2>/dev/null')
        if p then
            for file in p:lines() do
                local f = io.open(file, "r")
                if f then
                    local name, exec, icon_name = nil, nil, nil
                    local hidden, no_display = false, false
                    
                    for line in f:lines() do
                        if line:match("^Name=") then
                            name = line:match("^Name=(.+)$")
                        elseif line:match("^Exec=") then
                            exec = line:match("^Exec=(.+)$"):gsub("%%[fFuUdDnNickvm]", ""):gsub("%s+$", "")
                        elseif line:match("^Icon=") then
                            icon_name = line:match("^Icon=(.+)$")
                        elseif line:match("^Hidden=true") then
                            hidden = true
                        elseif line:match("^NoDisplay=true") then
                            no_display = true
                        end
                    end
                    
                    f:close()
                    
                    if name and exec and not hidden and not no_display then
                        local icon = find_icon(icon_name)
                        table.insert(apps, { name, exec, icon })
                    end
                end
            end
            p:close()
        end
    end
    
    -- Sort applications alphabetically
    table.sort(apps, function(a, b) return a[1] < b[1] end)
    
    -- Group applications by category
    local categories = {
        ["Internet"] = {},
        ["Development"] = {},
        ["Office"] = {},
        ["Graphics"] = {},
        ["Multimedia"] = {},
        ["Games"] = {},
        ["System"] = {},
        ["Accessories"] = {},
        ["Other"] = {}
    }
    
    -- Categorize applications
    for _, app in ipairs(apps) do
        local name = app[1]:lower()
        
        if name:match("browser") or name:match("firefox") or name:match("chrome") or 
           name:match("vivaldi") or name:match("opera") or name:match("thunderbird") or 
           name:match("mail") or name:match("transmission") or name:match("torrent") then
            table.insert(categories["Internet"], app)
        elseif name:match("code") or name:match("editor") or name:match("ide") or 
               name:match("vim") or name:match("emacs") or name:match("terminal") or 
               name:match("git") or name:match("develop") then
            table.insert(categories["Development"], app)
        elseif name:match("office") or name:match("libre") or name:match("writer") or 
               name:match("calc") or name:match("excel") or name:match("word") or 
               name:match("powerpoint") or name:match("impress") or name:match("pdf") then
            table.insert(categories["Office"], app)
        elseif name:match("gimp") or name:match("inkscape") or name:match("photo") or 
               name:match("draw") or name:match("paint") or name:match("image") then
            table.insert(categories["Graphics"], app)
        elseif name:match("media") or name:match("audio") or name:match("video") or 
               name:match("music") or name:match("sound") or name:match("player") then
            table.insert(categories["Multimedia"], app)
        elseif name:match("game") or name:match("steam") then
            table.insert(categories["Games"], app)
        elseif name:match("system") or name:match("settings") or name:match("config") or 
               name:match("control") or name:match("setup") then
            table.insert(categories["System"], app)
        elseif name:match("util") or name:match("tool") or name:match("calc") or 
               name:match("archive") or name:match("compress") or name:match("zip") or 
               name:match("text") then
            table.insert(categories["Accessories"], app)
        else
            table.insert(categories["Other"], app)
        end
    end
    
    -- Build final menu structure
    local menu_items = {}
    for category, apps in pairs(categories) do
        if #apps > 0 then
            table.insert(menu_items, { category, apps })
        end
    end
    
    -- Sort categories
    table.sort(menu_items, function(a, b) return a[1] < b[1] end)
    
    return menu_items
end

-- Create the main menu
local mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu, beautiful.awesome_icon },
        { "terminal", terminal },
        { "applications", get_applications() },
        { "power", powermenu }  -- Add the power management submenu
    },
    theme = { 
        width = 200,  -- Increase default width from 100 to 200
        height = 25   -- Slightly increase height for better readability
    }
})

local function themed_icon(color, icon, label)
  return markup.fontfg(icon_font, color, icon) .. markup.fontfg(theme_font, color, " " .. label .. " ")
end

local mylauncher = wibox.widget {
    markup = themed_icon("#50fa7b", "", ""),
    widget = wibox.widget.textbox,
}
mylauncher:buttons(gears.table.join(
    awful.button({}, 1, function() mymainmenu:toggle() end)
))

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}


local function create_stand_timer_widget(config)
    config = config or {}
    local sit_time = config.sit_time or 30 * 60  -- seconds
    local stand_time = config.stand_time or 30 * 60  -- seconds
    local font = config.font or "Sans 12"

    local is_paused = false
    local is_standing = false
    local remaining = sit_time

    local timer_widget = wibox.widget {
        widget = wibox.widget.textbox,
        align = "center",
        valign = "center",
        font = font
    }

    local function update_text()
        local minutes = math.floor(remaining / 60)
        local seconds = remaining % 60
        local status = is_paused and "⏸️" or (is_standing and "🧍" or "🪑")
        timer_widget.text = string.format("%s%02d:%02d ", status, minutes, seconds)
    end

    local function toggle_state()
        is_standing = not is_standing
        remaining = is_standing and stand_time or sit_time
        local message = is_standing and "Time to stand up!" or "Time to sit down!"
        naughty.notify({ title = "Posture Reminder", text = message, timeout = 5 })
    end

    local function reset_timer()
        remaining = is_standing and stand_time or sit_time
        update_text()
    end

    local function configure_timer()
        local was_paused = is_paused
        is_paused = true
        update_text()
        local default_input = string.format("%d\n%d", math.floor(sit_time / 60), math.floor(stand_time / 60))

        local cmd = string.format([[
            echo -e %q | zenity --forms \
                --title="Configure Stand Timer" \
                --text="Set your sit and stand durations (minutes)" \
                --add-entry="Sit time (minutes)" \
                --add-entry="Stand time (minutes)"
        ]], default_input)

        awful.spawn.easy_async_with_shell(cmd, function(stdout, _, _, exit_code)
            if exit_code == 0 then
                -- Parse the output
                local new_sit_time, new_stand_time = stdout:match("([^|]+)|([^|]+)")
                new_sit_time = tonumber(new_sit_time)
                new_stand_time = tonumber(new_stand_time)
                if new_sit_time and new_stand_time and 
                   new_sit_time > 0 and new_stand_time > 0 then
                    sit_time = new_sit_time * 60
                    stand_time = new_stand_time * 60
                    reset_timer()
                    naughty.notify({ 
                        title = "Timer Updated", 
                        text = "Sit: " .. new_sit_time .. " min, Stand: " .. new_stand_time .. " min",
                        timeout = 3 
                    })
                else
                    naughty.notify({ 
                        title = "Invalid Input", 
                        text = "Please enter positive numbers for both durations.",
                        timeout = 3 
                    })
                end
            end
            is_paused = was_paused
            update_text()
        end)
    end

    local main_timer = gears.timer {
        timeout = 1,
        autostart = true,
        callback = function()
            if not is_paused then
                remaining = remaining - 1
                if remaining <= 0 then
                    toggle_state()
                end
            end
            update_text()
        end
    }

    timer_widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            is_paused = not is_paused
            update_text()
        end),
        awful.button({}, 3, function()
            configure_timer()
        end)
    ))

    update_text()
    return timer_widget
end

local stand_timer = create_stand_timer_widget({
    sit_time = 25 * 60,
    stand_time = 5 * 60,
    font = theme_font,
})


-- Keyboard map indicator and switcher
local kbdcfg = {}
kbdcfg.cmd = "setxkbmap"
kbdcfg.layout = { { "us", "" }, { "br", "" } }
kbdcfg.current = 2  -- default layout
kbdcfg.widget = wibox.widget.textbox()
kbdcfg.widget:set_markup("KB")
kbdcfg.switch = function ()
  kbdcfg.current = kbdcfg.current % #(kbdcfg.layout) + 1
  local t = kbdcfg.layout[kbdcfg.current]
  kbdcfg.widget:set_markup(themed_icon("#A96EA9", "󰌌", t[1]))
  os.execute( kbdcfg.cmd .. " " .. t[1] .. " " .. t[2] )
end
kbdcfg.current = kbdcfg.current - 1
kbdcfg.switch()

kbdcfg.widget:buttons(
 awful.util.table.join(awful.button({ }, 1, function () kbdcfg.switch() end))
)
local mykeyboardlayout = kbdcfg.widget

-- {{{ Wibar
-- Define colors for our beautiful taskbar
local colors = {
    bg_gradient_transparency = "#00000000", -- Fully transparent
    bg_gradient_from = "#28282833",         -- Dark gray with 20% opacity
    bg_gradient_mid = "#00000022",          -- Black with 13% opacity
    bg_gradient_to = "#28282833",           -- Dark gray with 20% opacity
    task_border = "#6272A422",              -- Soft blue with 13% opacity
    task_bg_normal = "#6272A415",           -- Soft blue with 8% opacity
    task_bg_focus = "#00000015",            -- Very subtle black with 8% opacity
}

-- Create a textclock widget
local mytextclock = wibox.widget.textclock()
mytextclock:set_timezone("America/Sao_Paulo")
local month_calendar = awful.widget.calendar_popup.month({
    position = "tr",
    opacity = 1,
    bg = beautiful.bg_normal,
    font = beautiful.font,
})
month_calendar:attach(mytextclock, "tr")

-- CPU all stats below from copycats
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(themed_icon("#FF6E67", "󰻠", cpu_now.usage .. "%"))
    end
})

-- Create tooltip for CPU
local cpu_tooltip = awful.tooltip({
    objects = { cpu.widget },
    timer_function = function()
        local result = "CPU Usage: " .. cpu_now.usage .. "%\n"
        for i in pairs(cpu_now) do
            if i ~= 'usage' and i ~= 0 then
              result = result .. "Core " .. i .. ": " .. cpu_now[i].usage .. "%\n"
            end
        end

        return result
    end,
    delay_show = 0.5
})

-- Coretemp
local temp = lain.widget.temp({
    settings = function()
        widget:set_markup(themed_icon("#FFB86C", "󰔏", coretemp_now .. "°C"))
    end
})

-- Create tooltip for temperature
local temp_tooltip = awful.tooltip({
    objects = { temp.widget },
    timer_function = function()
        -- Try to get more detailed temperature info
        local temps = ""
        local f = io.popen("sensors")
        if f then
            temps = f:read("*all")
            f:close()
        end
        
        if temps == "" then
            return "CPU Temperature: " .. coretemp_now .. "°C"
        else
            return temps
        end
    end,
    delay_show = 0.5
})

-- Battery laptop
local bat = lain.widget.bat({
    settings = function()
        local perc = bat_now.perc ~= "N/A" and bat_now.perc .. "%" or bat_now.perc
        local color = "#8BE9FD"
        local icon
        if bat_now.ac_status == 1 then
            icon = "󰂄"
        else
            icon = "󰁹"
        end
        widget:set_markup(themed_icon(color, icon, perc))
    end
})

-- Create tooltip for battery
local bat_tooltip = awful.tooltip({
    objects = { bat.widget },
    timer_function = function()
        local text = "Battery Status:\n" ..
                     "Charge: " .. bat_now.perc .. "%\n" ..
                     "Status: " .. (bat_now.ac_status == 1 and "Charging" or "Discharging") .. "\n"
        
        if bat_now.time then
            text = text .. "Time remaining: " .. bat_now.time .. "\n"
        end
        
        if bat_now.watt then
            text = text .. "Power: " .. bat_now.watt .. "W\n"
        end
        
        -- Add more detailed battery info
        local f = io.popen("acpi -i")
        if f then
            local acpi = f:read("*all")
            f:close()
            text = text .. "\nDetailed Info:\n" .. acpi
        end
        
        return text
    end,
    delay_show = 0.5
})

-- Bluetooth battery (Soundbar/Mouse)
local btsoundbar = wibox.widget.textbox()
local btmouse = wibox.widget.textbox()

-- Create tooltips for bluetooth devices
local btsoundbar_tooltip = awful.tooltip({
    objects = { btsoundbar },
    timer_function = function()
        local text = "Bluetooth Soundbar:\n"
        
        -- Get detailed bluetooth info
        local f = io.popen("bluetoothctl info | grep -E 'Name|Connected|Paired|Battery'")
        if f then
            local btinfo = f:read("*all")
            f:close()
            if btinfo and btinfo ~= "" then
                text = text .. btinfo
            else
                text = text .. "No detailed information available"
            end
        end
        
        return text
    end,
    delay_show = 0.5
})

local btmouse_tooltip = awful.tooltip({
    objects = { btmouse },
    timer_function = function()
        local text = "Bluetooth Mouse:\n"
        
        -- Get detailed bluetooth info
        local f = io.popen("bluetoothctl info | grep -E 'Name|Connected|Paired|Battery'")
        if f then
            local btinfo = f:read("*all")
            f:close()
            if btinfo and btinfo ~= "" then
                text = text .. btinfo
            else
                text = text .. "No detailed information available"
            end
        end
        
        return text
    end,
    delay_show = 0.5
})

awful.widget.watch("upower -d", 2, function(widget, stdout)
  local box = nil
  local color = ""
  local icon = ""
  local pct = ""
  local chrg = ""
  local switchDevice = function(dwidget, dcolor, dicon)
    if box ~= nil then
      box:set_markup(themed_icon(color, icon, chrg .. pct .. "%"))
    end
    box = dwidget
    icon = dicon
    color = dcolor
    pct = ""
    chrg = ""
  end
  btsoundbar:set_markup("")
  btmouse:set_markup("")
  for line in stdout:gmatch("[^\r\n]+") do
    if line:match("model:") and line:match("SoundCore") then
      switchDevice(btsoundbar, "#50FA7B", "󰗾")
    elseif line:match("model:") and line:match("Mouse") then
      switchDevice(btmouse, "#FFB86C", "󰍽")
    elseif line:match("model:") or line:match("Device:") then
      switchDevice(nil, "", "")
    elseif line:match("percentage:") then
      pct = line:match("(%d?%d?%d)%%")
    elseif line:match("state:") and line:match("charging") and not line:match("discharging") then
      chrg = "󰚥"
    end
  end
  switchDevice(nil, "", "")
end, nil)

-- ALSA volume
local volume = lain.widget.alsa({
    settings = function()
        local color = "#BD93F9"
        local icon
        if volume_now.status == "off" then
          icon = "󰝟"
        else
          icon = "󰕾"
        end
    widget:set_markup(themed_icon(color, icon, volume_now.level .. "%"))
    end
})

-- Create tooltip for volume
local volume_tooltip = awful.tooltip({
    objects = { volume.widget },
    timer_function = function()
        local text = "Volume:\n" ..
                     "Level: " .. volume_now.level .. "%\n" ..
                     "Status: " .. (volume_now.status == "off" and "Muted" or "Unmuted") .. "\n"
        
        -- Add more detailed volume info
        local f = io.popen("amixer get " .. volume.channel)
        if f then
            local amixer = f:read("*all")
            f:close()
            text = text .. "\nDetailed Info:\n" .. amixer
        end
        
        return text
    end,
    delay_show = 0.5
})

-- Net
local netdowninfo = wibox.widget.textbox()
local netupinfo = wibox.widget.textbox()

local net = lain.widget.net({
    settings = function()
        netdowninfo:set_markup(themed_icon("#50FA7B", "󰇚", net_now.received))
        netupinfo:set_markup(themed_icon("#FF79C6", "󰕒", net_now.sent .. " "))
    end
})

local netupdown_tooltip = awful.tooltip({
    objects = { netdowninfo, netupinfo },
    timer_function = function()
        local text =   "Download: " .. net_now.received .. "\n"
        text = text .. "Upload: " .. net_now.sent .. "\n"
        return text
    end,
    delay_show = 0.5
})

-- MEM
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(themed_icon("#F1FA8C", "󰍛", mem_now.perc .. "%"))
    end
})

-- Create tooltip for memory
local mem_tooltip = awful.tooltip({
    objects = { memory.widget },
    timer_function = function()
        return "Memory Usage:\n" ..
               "Used: " .. mem_now.used .. " (" .. mem_now.perc .. "%)\n" ..
               "Free: " .. mem_now.free .. "\n" ..
               "Total: " .. mem_now.total .. "\n" ..
               "Swap: " .. (mem_now.swapused or "N/A")
    end,
    delay_show = 0.5
})


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.noempty,
        buttons = taglist_buttons
    }

    -- Create the wibox with our beautiful styling
    s.mywibox = awful.wibar({
        position = "top",
        screen   = s,
        bg       = colors.bg_gradient_transparency,
        fg       = beautiful.fg_normal,
    })

    -- Create a gradient background for the wibar
    s.mywibox.bgimage = function(context, cr, width, height)
        local grad = gears.color.create_linear_pattern({
            type = "linear",
            from = { 0, 0, 0 },
            to = { 0, height / 2, height },
            stops = {
                { 0, colors.bg_gradient_from },
                { 1, colors.bg_gradient_mid },
                { 2, colors.bg_gradient_to }
            }
        })
        cr:set_source(grad)
        cr:paint()
    end

    -- Custom tasklist with beautiful styling
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        style   = {
            shape = function(cr, width, height)
                gears.shape.rounded_rect(cr, width, height, 3) -- Slight rounding
            end,
            shape_border_width = 1,
            shape_border_color = colors.task_border,
            bg_normal = colors.task_bg_normal,
            bg_focus = colors.task_bg_focus,
            font = theme_font,
            spacing = 2, -- 2px gap between tasks
        },
        layout = {
            spacing = 2,
            layout = wibox.layout.flex.horizontal
        },
        widget_template = {
            {
                {
                    {
                        {
                            id     = 'icon_role',
                            widget = wibox.widget.imagebox,
                        },
                        margins = 2,
                        widget  = wibox.container.margin,
                    },
                    {
                        id     = 'text_role',
                        widget = wibox.widget.textbox,
                        ellipsize = "end",
                        max_width_chars = 20, -- Limit width of task names
                    },
                    layout = wibox.layout.fixed.horizontal,
                },
                margins = 2, -- Inner padding
                widget  = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        },
    }

    beautiful.bg_systray = colors.bg_gradient_mid
    beautiful.systray_icon_spacing = 4
    local mysystray = wibox.widget.systray()
    mysystray.opacity = 0

    -- Add widgets to the wibox with padding
    -- Create a padded container for all widgets
    local padded_wibar = wibox.container.margin(
        wibox.widget{
        },
        2, 2, 1, 1  -- left, right, top, bottom padding
    )
    
    -- Apply the gradient background to the wibar
  s.mywibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      mylauncher,
      s.mytaglist,
      s.mypromptbox,
    },
    s.mytasklist, -- Middle widget (expands to fill space)
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      mytextclock,
      stand_timer,
      mykeyboardlayout,
      bat.widget,
      btmouse,
      btsoundbar,
      cpu.widget,
      temp.widget,
      memory.widget,
      netdowninfo,
      netupinfo,
      volume.widget,
      s.mylayoutbox,
      mysystray,
    },
  }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
local globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "[",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "z", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    -- Custom
      awful.key({ modkey,           }, "p", function () awful.spawn.with_shell("echo 'sh ~/.screenlayout/$(zenity --timeout 3 --info $(for f in `ls ~/.screenlayout`; do echo \"--extra-button $f\"; done) --text Select)' > /tmp/chooser && bash /tmp/chooser") end, {description = "arandr", group = "launcher"}),

      awful.key({ modkey }, ".", function () awful.util.spawn("bash -c '~/dotfiles/lock.sh'") end,
                 {description = "lock", group = "launcher"}),

      awful.key({ modkey }, "d", function () awful.util.spawn("vivaldi") end,
                 {description = "vivaldi", group = "launcher"}),

      awful.key({ modkey }, "v", function () awful.util.spawn("pavucontrol") end,
                 {description = "pavucontrol", group = "launcher"}),

      awful.key({ }, "Print", function () awful.util.spawn("flatpak run org.flameshot.Flameshot launcher") end,
                 {description = "flameshot", group = "launcher"}),

      awful.key({ }, "XF86AudioPlay", function () awful.util.spawn("mpc toggle") end),
      awful.key({ }, "XF86AudioNext", function () awful.util.spawn("mpc next") end),
      awful.key({ }, "XF86AudioPrev", function () awful.util.spawn("mpc prev") end),
      awful.key({ }, "XF86AudioRaiseVolume", function ()
            os.execute(string.format("amixer -q set %s 1%%+", volume.channel))
            volume.update()
      end),
      awful.key({ }, "XF86AudioLowerVolume", function ()
            os.execute(string.format("amixer -q set %s 1%%-", volume.channel))
            volume.update()
      end),
      awful.key({ }, "XF86AudioMute", function ()
            os.execute(string.format("amixer -q set %s toggle", volume.togglechannel or volume.channel))
            volume.update()
      end),
      
      awful.key({ modkey, "Shift" }, "b", function () 
            awful.spawn.with_shell("export DEVICE='F4:2B:7D:49:A2:EC' && bluetoothctl disconnect $DEVICE && sleep 1 && bluetoothctl connect $DEVICE")
      end, {description = "restart bluetooth device", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "MEGAMU",
          "Blueman-manager",
          "Gpick",
          "KeePassXC",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Do not add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    { rule = { class = "Vivaldi-stable" },
      properties = { screen = 1, tag = "2" } },

    { rule = { class = "Code" },
      properties = { screen = 1, tag = "1" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

beautiful.useless_gap = 4
beautiful.border_focus = "#00ffff"

local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pkill -fx '%s'; %s", cmd, cmd))
    end
end

awful.spawn.with_shell([[ps -x | grep -E "activitywatch|aw-qt|aw-server|aw-watcher-window|aw-watcher-afk" | awk '{print $1}' | xargs kill -9]])
awful.spawn.with_shell("~/dotfiles/bin/persistent-ssh-agent")

run_once({
   "nm-applet",
   "syncthing --no-browser",
   "picom --backend glx",
   "lxpolkit",
   "~/activitywatch/aw-qt",
   "variety --resume",
   "xautolock -time 30 -locker ~/dotfiles/lock.sh"
})
