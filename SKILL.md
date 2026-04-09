---
name: chromecast
description: Control Chromecast, Google TV, and LG TV. Use when the user says an app name like "stremio" ("strem"), "youtube" ("yt"), "netflix" (launch via ADB/lgtv), says "tv off"/"tv on" (LG TV power), "pause"/"resume"/"mute" (playback control), says "yt <query>" to search YouTube on TV, says "stremio <query>" to search Stremio on TV, or wants to adjust volume, cast files or URLs, check what's playing, or control their Chromecast.
---

# Chromecast

Control the Chromecast via `go-chromecast`. Always use `--addr 192.168.0.136`.

## Usage pattern

```bash
go-chromecast <command> --addr 192.168.0.136
```

Run all commands via the Bash tool. Report results concisely.

**Volume/mute: always use `lgtv`** - go-chromecast and ADB volume/mute commands silently fail. Use `lgtv volume` commands for all volume control.

**App launching: always use ADB** - `lgtv launch` is unreliable for some apps. Prefer ADB `monkey` command to launch apps.

**"yt <query>" shorthand** - When the user says "yt <something>", search YouTube on the TV for that query via ADB. If the user says just "yt" with no query, launch the YouTube app instead of searching.

**"music" shorthand** - When the user says just "music" with no specifics, use `shuf -n 1` via Bash to randomly select one query from the pool matching the current time of day, then search YouTube for it. Set the volume to 3 via `lgtv volume set 3`. After the search loads, press `KEYCODE_ENTER` first, then select a random result by sending `KEYCODE_DPAD_RIGHT` between 0 and 15 times (use `shuf` to pick the count) then `KEYCODE_DPAD_CENTER` via ADB (with a short sleep to let results load).

Example of how to pick the query:

```bash
echo -e "evening synthwave playlist\njazz hop evening playlist\nneo soul evening playlist" | shuf -n 1
```

Playlist pools by time of day (pick one at random):

Morning (before noon):

- synthwave morning drive playlist
- drum and bass morning energy playlist
- progressive rock morning playlist
- grunge morning playlist
- liquid drum and bass morning playlist
- electro house morning playlist
- alternative rock morning playlist
- chillstep morning playlist

Afternoon (noon-5pm):

- progressive house afternoon playlist
- trance driving playlist
- drum and bass workout playlist
- EDM afternoon playlist
- electro house afternoon playlist
- progressive trance afternoon playlist
- djent afternoon playlist
- synthwave driving playlist
- future bass afternoon playlist
- stutter house playlist

Evening (5pm-10pm):

- synthwave evening playlist
- progressive trance evening playlist
- progressive house evening playlist
- liquid funk evening playlist
- chillstep evening playlist
- progressive rock evening playlist
- dubstep evening playlist
- drum and bass evening playlist

Late night (after 10pm):

- late night progressive trance playlist
- darkwave late night playlist
- djent late night playlist
- progressive metal deep cuts playlist
- dubstep late night playlist
- chillstep late night playlist
- drumstep late night playlist
- downtempo late night playlist
- progressive house late night playlist
- dark synthwave late night playlist

## Commands

### Status and discovery

| Command  | Description                        |
| -------- | ---------------------------------- |
| `status` | Show current playback status       |
| `ls`     | List Chromecast devices on network |
| `watch`  | Monitor device protobuf messages   |

Always check `status` first when the user asks what's playing.

### Playback control

| Command            | Description                          |
| ------------------ | ------------------------------------ |
| `play` / `unpause` | Resume playback                      |
| `pause`            | Pause playback                       |
| `stop`             | Stop casting                         |
| `restart`          | Restart current media from beginning |
| `next`             | Next item in playlist                |
| `previous`         | Previous item in playlist            |

### Loading media

| Command                | Description                                        |
| ---------------------- | -------------------------------------------------- |
| `load <path_or_url>`   | Cast a local file or URL                           |
| `playlist <directory>` | Play all media in a directory (sorted numerically) |
| `slideshow <images>`   | Image slideshow                                    |
| `transcode <file>`     | Transcode and play via ffmpeg                      |

**Supported formats:** MP3, AVI, MKV, MP4, WebM, FLAC, WAV. Unknown video formats auto-transcode to MP4 via ffmpeg.

**Playlist flags:**

- `--select` - choose starting position interactively
- `--continue=false` - restart from beginning (default: continues from last played)

### Seeking

| Command             | Description                        |
| ------------------- | ---------------------------------- |
| `seek <seconds>`    | Seek forward by N seconds          |
| `rewind <seconds>`  | Rewind by N seconds                |
| `seek-to <seconds>` | Jump to exact timestamp in seconds |

### Volume

| Command          | Description                      |
| ---------------- | -------------------------------- |
| `volume`         | Get current volume (0.0-1.0)     |
| `volume <float>` | Set volume (0.0 silent, 1.0 max) |
| `volume-up`      | Increase volume                  |
| `volume-down`    | Decrease volume                  |
| `mute`           | Mute audio                       |
| `unmute`         | Unmute audio                     |

Use `--step <float>` with `volume-up`/`volume-down` to control increment (e.g. `--step 0.10`).

After any volume change, report the new level.

---

# Google TV (ADB)

Control the Google TV (Chromecast with Google TV) via `adb`. Always use `-s 192.168.0.136:5555`.

## Connection

```bash
adb connect 192.168.0.136           # Connect (first time requires approval on TV)
adb -s 192.168.0.136:5555 shell ...  # Run commands
```

## Launch apps

```bash
adb -s 192.168.0.136:5555 shell monkey -p <package> -c android.intent.category.LAUNCHER 1
```

**Known packages:** stremio=`com.stremio.one`, netflix=`com.netflix.ninja`, youtube=`com.google.android.youtube.tv`, prime=`com.amazon.amazonvideo.livingroom`, disney+=`com.disney.disneyplus`, plex=`com.plexapp.android`, stan=`au.com.stan.and`, binge=`com.streamotion.binge`, kayo=`com.streamotion.kayosports`, tubi=`com.tubitv`, steam=`com.valvesoftware.steamlink`, paramount+=`com.cbs.ca`

To find a package name: `adb -s 192.168.0.136:5555 shell pm list packages | grep -i <name>`

## Search within apps

```bash
# YouTube launch (just "yt" with no query)
adb -s 192.168.0.136:5555 shell monkey -p com.google.android.youtube.tv -c android.intent.category.LAUNCHER 1

# YouTube search ("yt <query>")
adb -s 192.168.0.136:5555 shell am start -a android.intent.action.VIEW -d "https://www.youtube.com/results?search_query=<query>"

# Stremio search ("stremio <query>")
# 1. Open search screen via deep link
adb -s 192.168.0.136:5555 shell am start -a android.intent.action.VIEW -d "stremio:///search" -n com.stremio.one/com.stremio.tv.MainActivity
# 2. Wait, then navigate to input field, type query (spaces as %s), submit
sleep 0.5 && adb -s 192.168.0.136:5555 shell "input keyevent KEYCODE_DPAD_RIGHT && sleep 0.15 && input keyevent KEYCODE_DPAD_RIGHT && sleep 0.15 && input keyevent KEYCODE_DPAD_CENTER && sleep 0.5 && input text '<query with %s for spaces>' && sleep 0.15 && input keyevent KEYCODE_ENTER && sleep 0.15 && input keyevent KEYCODE_DPAD_DOWN && sleep 0.15 && input keyevent KEYCODE_DPAD_DOWN"
```

## Other useful commands

```bash
# List all installed packages
adb -s 192.168.0.136:5555 shell pm list packages

# Send keypress (home, back, etc.)
adb -s 192.168.0.136:5555 shell input keyevent KEYCODE_HOME
adb -s 192.168.0.136:5555 shell input keyevent KEYCODE_BACK

# Force stop an app
adb -s 192.168.0.136:5555 shell am force-stop <package>

# Reboot
adb -s 192.168.0.136:5555 reboot
```

---

# LG TV

Control the LG webOS TV via `lgtv`. Communicates over WebSocket (SSAP protocol).

## Usage pattern

```bash
lgtv <command> [args]
```

## Power

| Command        | Description                   |
| -------------- | ----------------------------- |
| `on`           | Wake via Wake-on-LAN          |
| `off`          | Turn off                      |
| `power`        | Toggle power                  |
| `power-status` | Check if TV is on (newer TVs) |

## App launching

```bash
lgtv launch <app>              # Launch by shortcut name or app ID
lgtv launch <app> key=value    # Launch with params
lgtv apps                      # List installed apps
lgtv app                       # Show currently running app
```

**Shortcuts:** stremio, youtube, netflix, amazon/prime, disney/disney+, apple/appletv, spotify, plex, hulu, hbo/hbomax, crunchyroll, twitch, browser, settings, tv/livetv

If the name isn't a shortcut, it fuzzy-matches against installed app titles, or falls back to treating it as a raw app ID.

## Input switching

```bash
lgtv input <id>                # Switch input (e.g., HDMI_1 or just 1)
lgtv inputs                    # List available inputs
```

## Volume

| Command                   | Description        |
| ------------------------- | ------------------ |
| `lgtv volume`             | Get current volume |
| `lgtv volume set <0-100>` | Set volume         |
| `lgtv volume up`          | Volume up          |
| `lgtv volume down`        | Volume down        |
| `lgtv volume mute`        | Mute               |
| `lgtv volume unmute`      | Unmute             |

## Playback

| Command             | Description  |
| ------------------- | ------------ |
| `lgtv play`         | Play/resume  |
| `lgtv pause`        | Pause        |
| `lgtv stop`         | Stop         |
| `lgtv rewind`       | Rewind       |
| `lgtv ff`           | Fast forward |
| `lgtv skip-forward` | Skip forward |
| `lgtv skip-back`    | Skip back    |

## Display (newer TVs)

| Command                    | Description             |
| -------------------------- | ----------------------- |
| `lgtv screen-off`          | Screen off, audio stays |
| `lgtv screen-on`           | Screen back on          |
| `lgtv picture-mode <mode>` | Set picture mode        |
| `lgtv sound-mode <mode>`   | Set sound mode          |
| `lgtv subtitles`           | Toggle subtitles        |
| `lgtv audio-track`         | Cycle audio track       |

## Other

```bash
lgtv open-url <url>            # Open URL (YouTube URLs deep-link)
lgtv nav <key>                 # Send remote key (up/down/left/right/enter/back/home/menu)
lgtv number <0-9>              # Send number key
lgtv raw <ssap://uri>          # Send raw SSAP command
lgtv scan                      # Discover TVs on network
```
