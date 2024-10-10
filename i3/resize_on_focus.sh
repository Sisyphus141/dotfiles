#!/bin/bash
# Resize all windows back to normal size
i3-msg "[class=.*] resize set width 800 px, height 600 px"

# Resize the focused window slightly larger
i3-msg "[con_id=$(i3-msg -t get_tree | jq '.. | objects | select(.focused? == true) | .id')] resize set width 820 px, height 620 px"

