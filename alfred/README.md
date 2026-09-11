# Alfred Workflows

This folder contains packaged `.alfredworkflow` files for backup and easy setup on new machines.

## How to Install on a New Mac

### Option 1: Automated Script
Make sure Alfred 5 is installed, then run:
```bash
./install.sh
```
or from the dotfiles root:
```bash
./alfred/install.sh
```

### Option 2: Command Line One-Liner
```bash
open ~/dotfiles/alfred/*.alfredworkflow
```

### Option 3: Manual Installation
Double-click any `.alfredworkflow` file in Finder to import it into Alfred.

---

## Included Workflows

| Workflow | Keyword(s) | Description | Author |
| :--- | :--- | :--- | :--- |
| **New Firefox Window** | `tab` | Opens a new Firefox Developer Edition window (or opens an optional URL/search) | Eric |
| **Dev** | `dev` | Search project folders and open them in VS Code and iTerm | Eric |
| **Clipboard Image to Downloads** | `clipsave` | Saves the image in your clipboard to `~/Downloads` | Custom / User |
| **Currency Converter** | `cur` | Convert between different currencies | Vítor Galvão |
| **Unit Converter** | `conv` | Convert between different units of measurement | Vítor Galvão |
| **Notes** | `nn`, `ns`, `nl` | Search and create notes in Apple Notes (`Notes.app`) | Vítor Galvão |
| **Wayback When** | `wayback` | Open websites on the Internet Archive’s Wayback Machine | Vítor Galvão |
| **Amazon Suggest** | `amazon` | In-line Amazon search suggestions | Vítor Galvão |
| **Mount Disks** | `mount`, `unmount` | Mount and unmount disk partitions | Vítor Galvão |
| **Placeholder Images** | `picsum` | Get placeholder images for design and code | Vítor Galvão |
| **Clipboard History Extender** | `clipex` | Backup and view Clipboard History text items | Vítor Galvão |
| **Ignore in Alfred** | `ignore`, `reignore`, `unignore` | Exclude files and folders from Alfred’s search results | Vítor Galvão |
