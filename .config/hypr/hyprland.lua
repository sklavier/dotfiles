local source_path = debug.getinfo(1, "S").source
local config_dir = source_path:match("^@(.*/)") or ""

package.path = config_dir .. "?.lua;" .. package.path

package.loaded["hyprland.env"] = nil
package.loaded["hyprland.general"] = nil
package.loaded["hyprland.input"] = nil
package.loaded["hyprland.misc"] = nil
package.loaded["hyprland.animations"] = nil
package.loaded["hyprland.decoration"] = nil
package.loaded["hyprland.group"] = nil
package.loaded["hyprland.execs"] = nil
package.loaded["hyprland.rules"] = nil
package.loaded["hyprland.gestures"] = nil
package.loaded["hyprland.keybinds"] = nil

require("hyprland.env")
require("hyprland.general")
require("hyprland.input")
require("hyprland.misc")
require("hyprland.animations")
require("hyprland.decoration")
require("hyprland.group")
require("hyprland.execs")
require("hyprland.rules")
require("hyprland.gestures")
require("hyprland.keybinds")
