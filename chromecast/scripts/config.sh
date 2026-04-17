#!/usr/bin/env bash
# Chromecast skill configuration
# Set TV_IP to your Google TV / Chromecast IP address.

TV_IP="192.168.0.136"

# Volume to set when waking the TV (0-100)
WAKE_VOLUME=1

# Derived
ADB="adb -s ${TV_IP}:5555"
CHROMECAST_ADDR="--addr ${TV_IP}"
