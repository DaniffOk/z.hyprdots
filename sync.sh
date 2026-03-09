#!/usr/bin/env bash

# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                                                                  ┃
# ┃      ZUSQII  -  M A S T E R   D O T   S Y N C                    ┃
# ┃                                                                  ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

REPO_DIR="/home/zusqii/z.hyprdots"
CONF_DIR="$HOME/.config"

echo "🚀 Starting backup..."
mkdir -p "$REPO_DIR"/.config

items=(cava clock-rs fastfetch hypr kitty rofi swaync waybar wayclick wlogout)

for item in "${items[@]}"; do
    if [ -d "$CONF_DIR/$item" ]; then
        cp -r "$CONF_DIR/$item" "$REPO_DIR/.config/"
        echo "✅ Copied .config/$item"
    else
        echo "⚠️  Warning: $item not found in .config"
    fi
done

cp "$HOME/.zshrc" "$REPO_DIR/"
cp -r "$HOME/.scripts" "$REPO_DIR/"
cp -r "$HOME/.themes" "$REPO_DIR/"
cp -r "$HOME/Pictures/Wallpapers" "$REPO_DIR/"

echo "✅ Copied .zshrc, .scripts, .themes, and Wallpapers"

echo "📤 Pushing to GitHub..."
cd "$REPO_DIR" || exit

# Add all changes
git add .

# Only commit if there are changes to avoid error messages
if git diff-index --quiet HEAD --; then
    echo "✨ No changes detected. Repository is already up to date."
else
    git commit -m "Update dots & wallpapers: $(date +'%Y-%m-%d %H:%M')"
    git push origin main
    echo "🎉 Everything successfully pushed to GitHub!"
fi
