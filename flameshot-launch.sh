#!/usr/bin/env bash
# Use Wayland-friendly clipboard path for flameshot.
flameshot gui --raw | wl-copy
