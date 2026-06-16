# UE5 MRQ Auto Render

Batch script to automate git pull, Unreal Engine 5.5 standalone launch, and Movie Render Queue execution for CI-style render automation on Windows.

---

## Overview

This script automates the full render pipeline on Windows — pulling the latest changes from a git repository, validating local paths, and launching Unreal Engine 5.5 in standalone mode to execute a Movie Render Queue preset. It aborts on uncommitted or staged changes to prevent dirty-state renders, captures the UE exit code for error handling, and pipes stdout verbosity directly to the console for live feedback during the render.

---

## Requirements

- Windows 10/11
- [Git for Windows](https://git-scm.com/download/win)
- Unreal Engine 5.5 installed via Epic Games Launcher
- A valid `.uproject` with a saved MRQ preset asset (`.uasset`)

---

## Configuration

Open `RunMRQ.bat` and edit the five variables at the top before first use:

| Variable | Description | Example |
|----------|-------------|---------|
| `UE` | Full path to `UnrealEditor.exe` | `C:\Program Files\Epic Games\UE_5.5\Engine\Binaries\Win64\UnrealEditor.exe` |
| `PROJECT` | Full path to your `.uproject` file | `C:\Projects\MyProject\MyProject.uproject` |
| `REPO_DIR` | Root of the git repository | `C:\Projects\MyProject` |
| `MAP` | In-engine path to the map to load | `/Game/Maps/MyMap` |
| `QUEUE` | In-engine asset path to your MRQ preset | `/Game/Cinematics/MyRenderPreset.MyRenderPreset` |

---

## Usage

Double-click `RunMRQ.bat` or run it from the command line:

```bat
RunMRQ.bat
```

The script will:

1. Check the repo for uncommitted or staged changes — aborts if any are found
2. Run `git pull --ff-only` to fetch the latest changes
3. Validate that `UnrealEditor.exe` and the `.uproject` exist
4. Launch Unreal Engine in standalone (`-game`) mode with the specified MRQ preset
5. Report success or failure on exit

---

## Git Conflict Behaviour

The script uses `--ff-only` for the pull, meaning it will only update if the local branch can be fast-forwarded. If there are local changes or a diverged history, it aborts with a descriptive message rather than auto-merging or force-resetting. Resolve any conflicts manually and re-run.

---

## Unreal Launch Flags

| Flag | Purpose |
|------|---------|
| `-game` | Launches in standalone mode, no editor UI |
| `-MoviePipelineConfig` | Path to the MRQ preset asset to execute |
| `-windowed` | Renders in a window rather than fullscreen |
| `-StdOut` | Pipes UE log output to the console |
| `-allowStdOutLogVerbosity` | Enables verbose log categories in stdout |
| `-Unattended` | Suppresses dialog boxes that would block execution |
| `-log` | Forces log output even in standalone mode |

---

## Notes

- The MRQ preset asset path uses the in-engine format: `/Game/Path/AssetName.AssetName`
- UE's exit code is captured after the process closes — a non-zero code means the render encountered an error
- To schedule automated renders, drop the script into Windows Task Scheduler
