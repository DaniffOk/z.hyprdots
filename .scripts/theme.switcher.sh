#!/usr/bin/env bash

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                                                                  ┃
# ┃      ZUSQII  -  T H E M E   S W I T C H E R                      ┃
# ┃                                                                  ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃      FUNCTIONS                                                   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Function to update VSCodium theme based on selection
update_vscodium() {
    local theme=$1[cite: 4]
    case "$theme" in[cite: 4]
        "gruvbox")    vsc_theme="Gruvbox Dark Soft" ;;[cite: 4]
        "catppuccin") vsc_theme="Catppuccin Mocha" ;;[cite: 4]
        "everforest") vsc_theme="Everforest Dark Soft" ;;[cite: 4]
        "Matugen")    vsc_theme="Default Dark Modern" ;;[cite: 4]
        *)            vsc_theme="Default Dark Modern" ;;[cite: 4]
    esac
    
    # Update settings.json silently
    sed -i "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$vsc_theme\"/" "$HOME/.config/VSCodium/User/settings.json"[cite: 4]
}

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃      SELECTION & SETUP                                           ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

PRESET_DIR="$HOME/.themes/presets"[cite: 4]
ROFI_CONF="$HOME/.config/rofi/config.rasi"[cite: 4]

# List presets + Add Matugen option
CHOICE=$(ls "$PRESET_DIR" | { cat; echo "Matugen"; } | rofi -dmenu -i -p "󰃟 Theme" -config "$ROFI_CONF")[cite: 4]

# Exit if no choice made
[[ -z "$CHOICE" ]] && exit 0[cite: 4]

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃      WALLPAPER HANDLING                                          ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

if [ "$CHOICE" == "Matugen" ]; then[cite: 4]
    WALL_DIR="$HOME/Pictures/Wallpapers"[cite: 4]
else
    WALL_DIR="$HOME/.themes/wallpapers/$CHOICE"[cite: 4]
fi

RANDOM_WALL=$(ls "$WALL_DIR" | shuf -n 1)[cite: 4]
FULL_PATH="$WALL_DIR/$RANDOM_WALL"[cite: 4]

# Apply Wallpaper with SWWW
swww img "$FULL_PATH" --transition-type center --transition-fps 60[cite: 4]

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃      COLOR GENERATION & SYMLINKING                               ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

if [ "$CHOICE" == "Matugen" ]; then[cite: 4]
    # 1. Generate colors with Matugen
    matugen image "$FULL_PATH"[cite: 4]
    
    # 2. Symlink to Matugen's generated outputs
    ln -sf "$HOME/.config/matugen/generated/colors.rasi" "$HOME/.config/rofi/colors.rasi"[cite: 4]
    ln -sf "$HOME/.config/matugen/generated/theme.css" "$HOME/.config/waybar/theme.css"[cite: 4]
    ln -sf "$HOME/.config/matugen/generated/kitty.conf" "$HOME/.config/kitty/theme.conf"[cite: 4]
    
    # 3. Update Spotify to use the Matugen Color Scheme
    if pgrep -x "spotify" > /dev/null; then[cite: 4]
        spicetify config current_theme Sleek color_scheme Matugen[cite: 4]
        spicetify apply -q[cite: 4]
    fi
else
    # 1. Symlink to Hardcoded Presets
    ln -sf "$PRESET_DIR/$CHOICE/rofi/colors.rasi" "$HOME/.config/rofi/colors.rasi"[cite: 4]
    ln -sf "$PRESET_DIR/$CHOICE/waybar/theme.css" "$HOME/.config/waybar/theme.css"[cite: 4]
    ln -sf "$PRESET_DIR/$CHOICE/kitty/theme.conf" "$HOME/.config/kitty/theme.conf"[cite: 4]
    
    # 2. Update VSCodium
    update_vscodium "$CHOICE"[cite: 4]
    
    # 3. Update Spotify (Spicetify)
    if pgrep -x "spotify" > /dev/null; then[cite: 4]
        case "$CHOICE" in[cite: 4]
            "gruvbox")    spicetify config current_theme Sleek color_scheme gruvbox ;;[cite: 4]
            "catppuccin") spicetify config current_theme Sleek color_scheme mocha ;;[cite: 4]
            "everforest") spicetify config current_theme Sleek color_scheme everforest ;;[cite: 4]
            *)            spicetify config current_theme Sleek color_scheme ultra-dark ;;[cite: 4]
        esac
        spicetify apply -q[cite: 4]
    fi
fi

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃      REFRESH INTERFACE                                           ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# Refresh Waybar
killall waybar && waybar &[cite: 4]

# Refresh Kitty colors without closing terminal
if pgrep -x "kitty" > /dev/null; then[cite: 4]
    kill -SIGUSR1 $(pgrep kitty)[cite: 4]
fi

# Send notification with the new wallpaper as icon
notify-send -a "System" "Theme updated to $CHOICE" -i "$FULL_PATH"[cite: 4]
