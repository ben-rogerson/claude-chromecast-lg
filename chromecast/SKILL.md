---
name: chromecast
description: Control LG TV and Chromecast via natural language. Triggers: tv on/off, music, yt/stremio [query], app names (netflix, plex, etc.), pause/resume/mute, volume.
---

# Chromecast

Control the Chromecast via `go-chromecast`.

Run all commands via the Bash tool. Report results concisely.

The skill loader provides the base directory above. Set this before running any scripts:
```bash
SCRIPTS="<base directory>/scripts"
```

**Volume/mute: always use `lgtv`** - go-chromecast and ADB volume/mute commands silently fail.

**App launching: always use `launch-app.sh`** - wraps ADB monkey with focus confirmation.

---

## Shorthand triggers

### "tv on"
```bash
$SCRIPTS/wake-if-needed.sh
```

### "tv off"
```bash
lgtv off
```

### "yt \<query\>"
```bash
$SCRIPTS/yt-search.sh "<query>"
```
If the user says just "yt" with no query, launch the YouTube app instead:
```bash
$SCRIPTS/launch-app.sh com.google.android.youtube.tv
```

### "stremio \<query\>"
```bash
$SCRIPTS/stremio-search.sh "<query>"
```
If no query, just launch Stremio:
```bash
$SCRIPTS/launch-app.sh com.stremio.one
```

### "music"
First run `wake-if-needed.sh` if the TV may be off, then:
```bash
$SCRIPTS/music.sh
```

### App launch (any app by name)
```bash
$SCRIPTS/launch-app.sh <package>
```

### Check power status
```bash
$SCRIPTS/check-power.sh
```

### Wait for app focus
```bash
$SCRIPTS/wait-for-app.sh <package> [timeout_seconds]
```

---

## Configuration

Edit `scripts/config.sh` to set your TV's IP:
```bash
TV_IP="192.168.0.x"
```
All scripts source this file. `$ADB` and `$CHROMECAST_ADDR` are derived automatically.

## Devices

| Device | Address |
|---|---|
| Chromecast (go-chromecast) | `$CHROMECAST_ADDR` (from config.sh) |
| Google TV (ADB) | `$ADB` (from config.sh) |
| LG TV (lgtv) | auto-discovered via WebSocket |

## Known ADB packages

| App | Package |
|---|---|
| YouTube | `com.google.android.youtube.tv` |
| Stremio | `com.stremio.one` |
| Netflix | `com.netflix.ninja` |
| Prime Video | `com.amazon.amazonvideo.livingroom` |
| Disney+ | `com.disney.disneyplus` |
| Plex | `com.plexapp.android` |
| Stan | `au.com.stan.and` |
| Binge | `com.streamotion.binge` |
| Kayo | `com.streamotion.kayosports` |
| Tubi | `com.tubitv` |
| Steam Link | `com.valvesoftware.steamlink` |
| Paramount+ | `com.cbs.ca` |

To find a package: `source $SCRIPTS/config.sh && $ADB shell pm list packages | grep -i <name>`

---

## go-chromecast commands

### Status
| Command | Description |
|---|---|
| `status` | Show current playback status |
| `ls` | List Chromecast devices on network |

Always check `status` first when the user asks what's playing.

### Playback
| Command | Description |
|---|---|
| `play` / `unpause` | Resume |
| `pause` | Pause |
| `stop` | Stop casting |
| `restart` | Restart from beginning |
| `next` | Next in playlist |
| `previous` | Previous in playlist |

### Media loading
| Command | Description |
|---|---|
| `load <path_or_url>` | Cast a local file or URL |
| `playlist <directory>` | Play all media in a directory |
| `transcode <file>` | Transcode and play via ffmpeg |

Supported formats: MP3, AVI, MKV, MP4, WebM, FLAC, WAV.

Playlist flags: `--select` (choose start), `--continue=false` (restart from beginning).

### Seeking
| Command | Description |
|---|---|
| `seek <seconds>` | Seek forward |
| `rewind <seconds>` | Rewind |
| `seek-to <seconds>` | Jump to exact timestamp |

---

## lgtv commands

### Power
| Command | Description |
|---|---|
| `lgtv power-status` | Check power state (`on`/`standby`) |
| `lgtv on` | Wake via Wake-on-LAN |
| `lgtv off` | Turn off |
| `lgtv power` | Toggle power |

### Volume
| Command | Description |
|---|---|
| `lgtv volume` | Get current volume |
| `lgtv volume set <0-100>` | Set volume — **confirm with user before setting above 5** |
| `lgtv volume up` | Volume up |
| `lgtv volume down` | Volume down |
| `lgtv volume mute` | Mute |
| `lgtv volume unmute` | Unmute |

After any volume change, report the new level.

### Playback
| Command | Description |
|---|---|
| `lgtv play` | Play/resume |
| `lgtv pause` | Pause |
| `lgtv stop` | Stop |
| `lgtv rewind` | Rewind |
| `lgtv ff` | Fast forward |
| `lgtv skip-forward` | Skip forward |
| `lgtv skip-back` | Skip back |

### Input
```bash
lgtv input <id>    # e.g. HDMI_1 or just 1
lgtv inputs        # list available inputs
```

### Display
| Command | Description |
|---|---|
| `lgtv screen-off` | Screen off, audio stays |
| `lgtv screen-on` | Screen back on |
| `lgtv subtitles` | Toggle subtitles |
| `lgtv audio-track` | Cycle audio track |

### Other
```bash
lgtv open-url <url>      # Open URL (YouTube URLs deep-link)
lgtv nav <key>           # Remote key: up/down/left/right/enter/back/home/menu
lgtv number <0-9>        # Send number key
lgtv app                 # Show currently running app (returns package name)
lgtv apps                # List installed apps
```

---

## ADB useful commands

```bash
# Send keypress
$ADB shell input keyevent KEYCODE_HOME
$ADB shell input keyevent KEYCODE_BACK

# Check focused app
$ADB shell dumpsys window | grep mCurrentFocus

# Force stop an app
$ADB shell am force-stop <package>
```
