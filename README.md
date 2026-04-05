# TV Remote - Claude Code Skill

Control your LG TV and Chromecast with Google TV using natural language through Claude Code.

This simple automation project wrangles together three tools to help you control your TV and Chromecast and uses a Claude Code skill to orchestrate the commands using natural language.

The three tools are:

- `lgtvremote-cli` for LG TV control (power, volume, apps)
- `adb` for Google TV control (app launching and search)
- `go-chromecast` for Chromecast control (media playback)

### Quick commands

| Say this                    | What happens                                                      |
| --------------------------- | ----------------------------------------------------------------- |
| `music`                     | Searches YouTube for a time-appropriate playlist, sets low volume |
| `tv off` / `tv on`          | Power the TV off or on                                            |
| `yt`                        | Launch YouTube                                                    |
| `yt lofi hip hop`           | Search YouTube for "lofi hip hop"                                 |
| `stremio`                   | Launch Stremio                                                    |
| `stremio severance`         | Search Stremio for "severance"                                    |
| `pause` / `resume`          | Pause or resume playback                                          |
| `mute`                      | Mute the TV                                                       |
| `volume up` / `volume down` | Adjust volume                                                     |

App launching: Say any app name to launch it: `netflix`, `disney+`, `prime`, `plex`, `stan`, `binge`, `kayo`, `tubi`, `spotify`, `steam`.

### Other controls

You can also ask Claude to do things like:

- "set volume to 15"
- "switch to HDMI 2"
- "skip forward"
- "rewind 30 seconds"
- "what's playing?"
- "turn the screen off but keep audio"

## How it works

The skill orchestrates three CLI tools behind the scenes:

| Tool            | Purpose                             |
| --------------- | ----------------------------------- |
| `lgtv`          | LG TV control (power, volume, apps) |
| `adb`           | Google TV app launching and search  |
| `go-chromecast` | Chromecast media playback           |

## Getting started

### Claude Code skill

```bash
claude code add-skill <path-to-skill>/SKILL.md
```

### lgtv (LG TV control)

```bash
pip install lgtvremote-cli
# or
pipx install lgtvremote-cli
```

### ADB (Google TV / Chromecast control)

```bash
# macOS
brew install android-platform-tools

# Ubuntu/Debian
sudo apt install adb
```

After installing, connect to your Google TV:

```bash
adb connect <tv-ip>                      # Approve on TV screen
adb -s <tv-ip>:5555 shell echo ok        # Verify
```

### go-chromecast (media casting)

```bash
brew install go-chromecast
```

## Network requirements

- Your computer and TV must be on the same local network
- Port 3001 (WSS) for LG TV control
- Port 5555 (TCP) for ADB

## License

MIT
