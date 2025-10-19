#!/data/data/com.termux/files/usr/bin/bash

# Termux Auto Rice Script
# Minimal, Optimized & Aesthetic Setup
# Author: Auto-Rice Script
# Description: Automatically installs and configures a beautiful Termux environment

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print functions
print_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔═══════════════════════════════════════╗"
    echo "║     TERMUX AUTO RICE INSTALLER        ║"
    echo "║   Minimal • Optimized • Aesthetic     ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Check if package is installed
is_installed() {
    dpkg -l "$1" &>/dev/null
    return $?
}

# Install package if not installed
install_package() {
    if is_installed "$1"; then
        print_info "$1 is already installed"
    else
        print_info "Installing $1..."
        pkg install -y "$1" 2>&1 | grep -v "WARNING"
        if [ $? -eq 0 ]; then
            print_success "$1 installed successfully"
        else
            print_error "Failed to install $1"
            return 1
        fi
    fi
}

# Update and upgrade packages
update_system() {
    print_info "Updating package lists..."
    pkg update -y 2>&1 | grep -v "WARNING" >/dev/null
    print_success "Package lists updated"
    
    print_info "Upgrading packages..."
    pkg upgrade -y 2>&1 | grep -v "WARNING" >/dev/null
    print_success "Packages upgraded"
}

# Install required packages
install_packages() {
    print_info "Installing required packages..."
    
    packages=(
        "zsh"
        "git"
        "curl"
        "wget"
        "neofetch"
        "figlet"
        "nano"
        "vim"
        "python"
        "ruby"
    )
    
    for pkg in "${packages[@]}"; do
        install_package "$pkg"
    done
    
    # Install lolcat via Ruby gem
    print_info "Installing lolcat via gem..."
    gem install lolcat 2>&1 | grep -v "WARNING" >/dev/null
    if [ $? -eq 0 ]; then
        print_success "lolcat installed successfully"
    else
        print_warning "lolcat installation failed (optional)"
    fi
    
    # Install colorls via Ruby gem (exa alternative)
    print_info "Installing colorls via gem..."
    gem install colorls 2>&1 | grep -v "WARNING" >/dev/null
    if [ $? -eq 0 ]; then
        print_success "colorls installed successfully"
    else
        print_warning "colorls installation failed (will use standard ls)"
    fi
}

# Setup Zsh as default shell
setup_zsh() {
    print_info "Setting up Zsh..."
    
    # Change default shell to zsh
    chsh -s zsh 2>/dev/null
    
    print_success "Zsh set as default shell"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_info "Oh My Zsh already installed"
    else
        print_info "Installing Oh My Zsh..."
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" --depth 1 2>&1 | grep -v "WARNING" >/dev/null
        print_success "Oh My Zsh installed"
    fi
}

# Install Zsh plugins
install_zsh_plugins() {
    print_info "Installing Zsh plugins..."
    
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    
    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" --depth 1 2>&1 | grep -v "WARNING" >/dev/null
        print_success "zsh-autosuggestions installed"
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" --depth 1 2>&1 | grep -v "WARNING" >/dev/null
        print_success "zsh-syntax-highlighting installed"
    fi
    
    # zsh-completions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
        git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions" --depth 1 2>&1 | grep -v "WARNING" >/dev/null
        print_success "zsh-completions installed"
    fi
}

# Configure .zshrc
configure_zshrc() {
    print_info "Configuring .zshrc..."
    
    cat > "$HOME/.zshrc" << 'ZSHRC_END'
# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="agnoster"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
    colored-man-pages
    command-not-found
)

source $ZSH/oh-my-zsh.sh

# Aliases
if command -v colorls &> /dev/null; then
    alias l='colorls -lh --sd'
    alias ls='colorls --sd'
    alias la='colorls -lAh --sd'
    alias ll='colorls -lh --sd'
    alias lt='colorls --tree --sd'
else
    alias l='ls -lh --color=auto'
    alias ls='ls --color=auto'
    alias la='ls -lAh --color=auto'
    alias ll='ls -lh --color=auto'
fi

alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias update='pkg update && pkg upgrade'
alias install='pkg install'
alias search='pkg search'
alias clean='apt clean && apt autoclean'

# Custom prompt enhancement
PROMPT='%F{cyan}╭─%f %F{green}%n%f %F{yellow}@%f %F{blue}termux%f %F{magenta}%~%f
%F{cyan}╰─%f %F{red}❯%f '

# Neofetch on startup
if command -v neofetch &> /dev/null; then
    neofetch --config none --colors 6 7 6 6 6 7 --ascii_colors 6 6 --backend ascii --ascii_distro android_small
fi
ZSHRC_END

    print_success ".zshrc configured"
}

# Configure .bashrc for fallback
configure_bashrc() {
    print_info "Configuring .bashrc..."
    
    cat > "$HOME/.bashrc" << 'BASHRC_END'
# Bash configuration

# Custom PS1
PS1='\[\e[0;36m\]╭─\[\e[0m\] \[\e[0;32m\]\u\[\e[0m\] \[\e[0;33m\]@\[\e[0m\] \[\e[0;34m\]termux\[\e[0m\] \[\e[0;35m\]\w\[\e[0m\]\n\[\e[0;36m\]╰─\[\e[0m\] \[\e[0;31m\]❯\[\e[0m\] '

# Aliases
if command -v colorls &> /dev/null; then
    alias l='colorls -lh --sd'
    alias ls='colorls --sd'
    alias la='colorls -lAh --sd'
    alias ll='colorls -lh --sd'
else
    alias l='ls -lh --color=auto'
    alias ls='ls --color=auto'
    alias la='ls -lAh --color=auto'
    alias ll='ls -lh --color=auto'
fi

alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias update='pkg update && pkg upgrade'
alias install='pkg install'
alias search='pkg search'
alias clean='apt clean && apt autoclean'

# Neofetch on startup
if command -v neofetch &> /dev/null; then
    neofetch --config none --colors 6 7 6 6 6 7 --ascii_colors 6 6 --backend ascii --ascii_distro android_small
fi
BASHRC_END

    print_success ".bashrc configured"
}

# Configure Termux colors
setup_termux_colors() {
    print_info "Setting up Termux colors..."
    
    mkdir -p "$HOME/.termux"
    
    cat > "$HOME/.termux/colors.properties" << 'COLORS_END'
# Catppuccin Mocha Theme (Minimal Dark)
background=#1e1e2e
foreground=#cdd6f4
cursor=#f5e0dc

color0=#45475a
color1=#f38ba8
color2=#a6e3a1
color3=#f9e2af
color4=#89b4fa
color5=#f5c2e7
color6=#94e2d5
color7=#bac2de

color8=#585b70
color9=#f38ba8
color10=#a6e3a1
color11=#f9e2af
color12=#89b4fa
color13=#f5c2e7
color14=#94e2d5
color15=#a6adc8
COLORS_END

    print_success "Termux colors configured (Catppuccin Mocha)"
}

# Configure Termux font and properties
setup_termux_properties() {
    print_info "Setting up Termux properties..."
    
    cat > "$HOME/.termux/termux.properties" << 'PROPERTIES_END'
# Termux Properties

# Extra keys
extra-keys = [ \
 ['ESC','|','/','HOME','UP','END','PGUP','DEL'], \
 ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN','BKSP'] \
]

# Bell character
bell-character=ignore

# Use black UI
use-black-ui=true

# Fullscreen mode
fullscreen=false

# Hide soft keyboard on startup
soft-keyboard-enabled=true
PROPERTIES_END

    print_success "Termux properties configured"
}

# Create custom neofetch config
setup_neofetch_config() {
    print_info "Setting up neofetch configuration..."
    
    mkdir -p "$HOME/.config/neofetch"
    
    cat > "$HOME/.config/neofetch/config.conf" << 'NEOFETCH_END'
print_info() {
    info title
    info underline
    info "OS" distro
    info "Host" model
    info "Kernel" kernel
    info "Uptime" uptime
    info "Packages" packages
    info "Shell" shell
    info "Terminal" term
    info "CPU" cpu
    info "Memory" memory
    prin "════════════════════════════════"
    info cols
}

title_fqdn="off"
kernel_shorthand="on"
distro_shorthand="off"
os_arch="on"
uptime_shorthand="on"
memory_percent="on"
package_managers="on"
shell_path="off"
shell_version="on"
speed_type="bios_limit"
speed_shorthand="on"
cpu_brand="on"
cpu_speed="on"
cpu_cores="logical"
cpu_temp="off"
gpu_brand="on"
gpu_type="all"
refresh_rate="off"
gtk_shorthand="off"
gtk2="on"
gtk3="on"
disk_show=('/')
disk_subtitle="mount"
music_player="auto"
song_format="%artist% - %album% - %title%"
song_shorthand="off"
colors=(distro)
bold="on"
underline_enabled="on"
underline_char="─"
separator=":"
block_range=(0 15)
color_blocks="on"
block_width=3
block_height=1
bar_char_elapsed="-"
bar_char_total="="
bar_border="on"
bar_length=15
bar_color_elapsed="distro"
bar_color_total="distro"
cpu_display="off"
memory_display="off"
battery_display="off"
disk_display="off"
image_backend="ascii"
image_source="auto"
ascii_distro="auto"
ascii_colors=(distro)
ascii_bold="on"
image_loop="off"
thumbnail_dir="${XDG_CACHE_HOME:-${HOME}/.cache}/thumbnails/neofetch"
crop_mode="normal"
crop_offset="center"
image_size="auto"
gap=3
yoffset=0
xoffset=0
background_color=
stdout="off"
NEOFETCH_END

    print_success "Neofetch configuration created"
}

# Create a welcome banner script
create_welcome_banner() {
    print_info "Creating welcome banner..."
    
    cat > "$HOME/.termux_banner" << 'BANNER_END'
#!/data/data/com.termux/files/usr/bin/bash

if command -v figlet &> /dev/null && command -v lolcat &> /dev/null; then
    figlet -f small "Termux Riced" | lolcat
elif command -v figlet &> /dev/null; then
    echo -e "\e[36m"
    figlet -f small "Termux Riced"
    echo -e "\e[0m"
else
    echo -e "\e[36m╔════════════════════════════════════╗\e[0m"
    echo -e "\e[36m║\e[0m      \e[1mTERMUX RICED\e[0m              \e[36m║\e[0m"
    echo -e "\e[36m╚════════════════════════════════════╝\e[0m"
fi

echo ""
echo -e "\e[32m→\e[0m Minimal • Optimized • Aesthetic"
echo ""
BANNER_END

    chmod +x "$HOME/.termux_banner"
    print_success "Welcome banner created"
}

# Reload Termux settings
reload_termux() {
    print_info "Reloading Termux settings..."
    termux-reload-settings 2>/dev/null
    print_success "Termux settings reloaded"
}

# Create backup
create_backup() {
    print_info "Creating backup of existing configs..."
    
    BACKUP_DIR="$HOME/.termux_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$BACKUP_DIR/"
    [ -f "$HOME/.bashrc" ] && cp "$HOME/.bashrc" "$BACKUP_DIR/"
    [ -d "$HOME/.termux" ] && cp -r "$HOME/.termux" "$BACKUP_DIR/"
    
    print_success "Backup created at: $BACKUP_DIR"
}

# Main installation function
main() {
    print_banner
    
    print_info "Starting Termux rice installation..."
    echo ""
    
    # Create backup
    create_backup
    echo ""
    
    # Update system
    update_system
    echo ""
    
    # Install packages
    install_packages
    echo ""
    
    # Setup Zsh
    setup_zsh
    install_oh_my_zsh
    install_zsh_plugins
    configure_zshrc
    echo ""
    
    # Configure Bash as fallback
    configure_bashrc
    echo ""
    
    # Setup Termux appearance
    setup_termux_colors
    setup_termux_properties
    setup_neofetch_config
    echo ""
    
    # Create welcome banner
    create_welcome_banner
    echo ""
    
    # Reload settings
    reload_termux
    echo ""
    
    # Final message
    print_banner
    print_success "Installation completed successfully!"
    echo ""
    print_info "Backup created in: ~/.termux_backup_*"
    echo ""
    print_info "Please restart Termux to apply all changes"
    print_info "Run: exit"
    echo ""
    print_info "After restart, Zsh will be your default shell"
    print_info "with Oh My Zsh and custom plugins installed"
    echo ""
    print_warning "Enjoy your riced Termux! 🚀"
    echo ""
    
    # Show installed tools
    echo -e "${CYAN}Installed tools:${NC}"
    echo "• neofetch - System information"
    echo "• colorls - Colorful ls (if installed)"
    echo "• lolcat - Rainbow text (if installed)"
    echo "• figlet - ASCII art text"
    echo "• zsh + Oh My Zsh - Enhanced shell"
    echo ""
}

# Run main function
main
