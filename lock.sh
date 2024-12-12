#!/bin/bash

# Directory to store the screenshot
IMAGE=/tmp/screen_locked.png

# Take a screenshot
scrot "$IMAGE"

# Blur the screenshot (requires imagemagick)
convert "$IMAGE" -blur 0x2 "$IMAGE"

# Lock the screen with the blurred screenshot
i3lock -i "$IMAGE"

# Clean up
rm "$IMAGE"
