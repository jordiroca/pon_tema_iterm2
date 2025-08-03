# iTerm2 Theme Switcher 🎨

> **Smart per-folder iTerm2 color scheme management for macOS**

Automatically change your iTerm2 color scheme based on the current working directory. Never get lost in your terminal again with visual cues that help you instantly recognize which project or environment you're in.

## ✨ Features

- **🎯 Per-Folder Color Schemes**: Assign unique iTerm2 color profiles to specific directories using `.iterm2theme` files
- **⚡ Automatic Switching**: Seamlessly changes themes as you navigate between folders via zsh hooks
- **🔧 Zero Configuration**: Works out of the box with sensible defaults
- **🎨 Visual Theme Selection**: Interactive TUI for selecting and applying themes
- **🐍 Virtual Environment Integration**: Automatically activates Python virtual environments when entering directories

## 🚀 Quick Start

### Prerequisites

- macOS with iTerm2
- Python 3.8+
- zsh shell (default on macOS)
- iTerm2 color schemes installed

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/hook_chpwd_iterm2_theme.git
   cd hook_chpwd_iterm2_theme
   ```

2. Install the zsh hook (adds configuration to your ~/.zshrc):
   ```bash
   ./config-zshrc.sh
   ```

3. Restart your terminal or source your ~/.zshrc:
   ```bash
   source ~/.zshrc
   ```

## 🛠️ Configuration

### Setting Folder Themes

#### Method 1: Interactive Theme Selection

Assuming you copy the `set_folder_theme.py` file to a directory in your PATH, you can run it from any directory and it will create a `.iterm2theme` file in the current directory.

Navigate to any directory and run the theme selector:

```bash
set_folder_theme.py
```

This launches an interactive terminal interface where you can:
- 🎨 Browse all available iTerm2 color schemes
- ✅ Select a theme for the current directory
- 📄 Creates a `.iterm2theme` file in the current directory

#### Method 2: Manual Configuration

Create a `.iterm2theme` file in any directory to set its theme:

```bash
echo "Regular" > .iterm2theme
```

The iterm2 theme will automatically apply when you enter this directory or any subdirectory.

#### Global Default Theme
Set a global default theme by creating `~/.iterm2theme`:

```bash
echo "Regular" > ~/.iterm2theme
```

### How It Works

The system uses zsh's `chpwd` hook to automatically:
1. **Detect directory changes** when you use `cd`
2. **Search for `.iterm2theme` files** in the current directory and parent directories
3. **Apply the theme** using iTerm2's AppleScript API
4. **Fallback to default** if no `.iterm2theme` file is found
5. **Activate Python virtual environments** automatically when `.venv` directories exist

## 📋 Available Commands

| Command               | Description                                             |
|-----------------------|---------------------------------------------------------|
| `set_folder_theme.py` | Launch interactive theme selector for current directory |
| `./config-zshrc.sh`   | Install zsh hook configuration into ~/.zshrc            |

## 🔧 How It Works

This utility leverages iTerm2's AppleScript API and zsh hooks to dynamically change color schemes based on your current working directory. It works by:

1. **Hooking into shell directory changes** via zsh's `chpwd` hook
2. **Searching for `.iterm2theme` files** in current and parent directories
3. **Sending AppleScript commands to iTerm2** to switch color schemes instantly
4. **Activating Python virtual environments** when `.venv` directories are detected
5. **Falling back to global default** theme when no specific theme is configured

## 🎯 Use Cases

Perfect for developers who:
- 🏢 Work on multiple client projects simultaneously
- 🌙 Want visual distinction between work and personal projects
- 🐍 Use Python virtual environments and want automatic activation
- 🐛 Need quick context switching between different environments
- 🎨 Simply love beautiful, organized terminals

## 📦 Dependencies & Installation Options

### Automatic Installation (Recommended)
The script uses **uv** package manager via its shebang for automatic dependency management:

```bash
# Runs with uv automatically (requires uv to be installed)
set_folder_theme.py
```

**What is uv?** uv is a fast Python package manager that automatically installs required dependencies when the script runs. If you have uv installed, dependencies (`iterm2`, `rich`) will be downloaded and cached automatically on first run.

### Manual Installation (Alternative)
If you prefer not to use uv, you have these options:

#### Option 1: Install uv first
```bash
# Install uv (if not already installed)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Then run the script normally
set_folder_theme.py
```

#### Option 2: Use Python 3 directly
```bash
# Install dependencies manually
pip3 install iterm2 rich

# Run with Python 3 (bypassing the shebang)
python3 set_folder_theme.py
```

#### Option 3: Use pipx for isolated installation
```bash
# Install dependencies in isolated environment
pipx install iterm2 rich

# Run with Python 3
python3 set_folder_theme.py
```

### Required Dependencies
- `iterm2` - Python library for iTerm2 scripting
- `rich` - Beautiful terminal formatting
- `curses` - Terminal UI (built into Python standard library)

## 🚀 Practical Examples

### Setting up a work project with Dracula theme

**Using uv (automatic):**
```bash
cd ~/projects/work-project
set_folder_theme.py
# Select "Dracula" from the interactive menu
# Creates .iterm2theme file with "Dracula"
```

**Using Python 3 (manual):**
```bash
cd ~/projects/work-project
python3 set_folder_theme.py
# Select "Dracula" from the interactive menu
# Creates .iterm2theme file with "Dracula"
```

### Setting up personal project with Solarized Light
```bash
cd ~/projects/personal-blog
echo "Solarized Light" > .iterm2theme
```

### Setting global default theme
```bash
echo "Regular" > ~/.iterm2theme
```

### Workflow demonstration
```bash
# Navigate to work project (automatically switches to Dracula)
cd ~/projects/work-project

# Navigate to personal project (automatically switches to Solarized Light)
cd ~/projects/personal-blog

# Navigate to directory without specific theme (falls back to global default)
cd ~/Downloads
```

### Quick setup for new users
```bash
# 1. Install the zsh hook
./config-zshrc.sh

# 2. Restart terminal or source ~/.zshrc
source ~/.zshrc

# 3. Set up your first project theme
cd ~/my-project
set_folder_theme.py  # or python3 set_folder_theme.py
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with love for the iTerm2 community
- Inspired by the need for better terminal organization
- Thanks to all the amazing iTerm2 color scheme creators

---

<div align="center">
  <p><strong>Made with ❤️ for developers who live in the terminal</strong></p>
  <p><em>Star ⭐ this repo if it helps you stay organized!</em></p>
</div>