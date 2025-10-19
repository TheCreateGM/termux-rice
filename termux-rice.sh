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
        pkg install -y "$1" &>/dev/null
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
    pkg update -y &>/dev/null
    print_success "Package lists updated"
    
    print_info "Upgrading packages..."
    pkg upgrade -y &>/dev/null
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
        "exa"
        "bat"
        "fzf"
        "figlet"
        "toilet"
        "lolcat"
        "nano"
        "vim"
    )
    
    for pkg in "${packages[@]}"; do
        install_package "$pkg"
    done
}

# Setup Zsh as default shell
setup_zsh() {
    print_info "Setting up Zsh..."
    
    # Change default shell to zsh
    chsh -s zsh &>/dev/null
    
    print_success "Zsh set as default shell"
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_info "Oh My Zsh already installed"
    else
        print_info "Installing Oh My Zsh..."
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" --depth 1 &>/dev/null
        print_success "Oh My Zsh installed"
    fi
}

# Install Zsh plugins
install_zsh_plugins() {
    print_info "Installing Zsh plugins..."
    
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
    
    # zsh-autosuggestions
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" --depth 1 &>/dev/null
        print_success "zsh-autosuggestions installed"
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" --depth 1 &>/dev/null
        print_success "zsh-syntax-highlighting installed"
    fi
}

# Configure .zshrc
configure_zshrc() {
    print_info "Configuring .zshrc..."
    
    cat > "$HOME/.zshrc" << 'ZSHRC_EOF'
# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="agnoster"

# Plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    colored-man-pages
    command-not-found
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias l='exa -lh --icons'
alias ls='exa --icons'
alias la='exa -lah --icons'
alias ll='exa -lh --icons'
alias lt='exa --tree --icons'
alias cat='bat --style=plain'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias update='pkg update && pkg upgrade'
alias install='pkg install'

# Custom prompt enhancement
PROMPT='%F{cyan}╭─%f %F{green}%n%f %F{yellow}@%f %F{blue}%m%f %F{magenta}%~%f
%F{cyan}╰─%f %F{red}❯%f '

# Neofetch on startup
if command -v neofetch &> /dev/null; then
    neofetch --ascii_distro android_small
fi
ZSHRC_EOF

    print_success ".zshrc configured"
}

# Configure .bashrc for fallback
configure_bashrc() {
    print_info "Configuring .bashrc..."
    
    cat > "$HOME/.bashrc" << 'BASHRC_EOF'
# Bash configuration

# Custom PS1
PS1='\[\e[0;36m\]╭─\[\e[0m\] \[\e[0;32m\]\u\[\e[0m\] \[\e[0;33m\]@\[\e[0m\] \[\e[0;34m\]\h\[\e[0m\] \[\e[0;35m\]\w\[\e[0m\]\n\[\e[0;36m\]╰─\[\e[0m\] \[\e[0;31m\]❯\[\e[0m\] '

# Aliases
alias l='ls -lh'
alias la='ls -lah'
alias ll='ls -lh'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias update='pkg update && pkg upgrade'
alias install='pkg install'

# Neofetch on startup
if command -v neofetch &> /dev/null; then
    neofetch --ascii_distro android_small
fi
BASHRC_EOF

    print_success ".bashrc configured"
}

# Configure Termux colors
setup_termux_colors() {
    print_info "Setting up Termux colors..."
    
    mkdir -p "$HOME/.termux"
    
    cat > "$HOME/.termux/colors.properties" << 'EOF'
# Minimal Dark Theme
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
EOF

    print_success "Termux colors configured"
}

# Configure Termux font and properties
setup_termux_properties() {
    print_info "Setting up Termux properties..."
    
    cat > "$HOME/.termux/termux.properties" << 'EOF'
# Termux Properties

# Extra keys
extra-keys = [ \
 ['ESC','|','/','HOME','UP','END','PGUP','DEL'], \
 ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN','BKSP'] \
]

# Bell character
bell-character=ignore

# Vibrate
use-black-ui=true
EOF

    print_success "Termux properties configured"
}

# Create a welcome script
create_welcome_script() {
    print_info "Creating welcome banner..."
    
    cat > "$HOME/.termux_welcome" << 'WELCOME_EOF'
#!/data/data/com.termux/files/usr/bin/bash
figlet -f small "Termux" | lolcat
echo ""
echo -e "\e[36m┌─────────────────────────────────────┐\e[0m"
echo -e "\e[36m│\e[0m  Welcome to your riced Termux!      \e[36m│\e[0m"
echo -e "\e[36m│\e[0m  Minimal • Optimized • Aesthetic    \e[36m│\e[0m"
echo -e "\e[36m└─────────────────────────────────────┘\e[0m"
echo ""
WELCOME_EOF

    chmod +x "$HOME/.termux_welcome"
    print_success "Welcome banner created"
}

# Reload Termux settings
reload_termux() {
    print_info "Reloading Termux settings..."
    termux-reload-settings &>/dev/null
    print_success "Termux settings reloaded"
}

# Main installation function
main() {
    print_banner
    
    print_info "Starting Termux rice installation..."
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
    echo ""
    
    # Create welcome banner
    create_welcome_script
    echo ""
    
    # Reload settings
    reload_termux
    echo ""
    
    # Final message
    print_banner
    print_success "Installation completed successfully!"
    echo ""
    print_info "Please restart Termux to apply all changes"
    print_info "Run: exit"
    echo ""
    print_info "After restart, Zsh will be your default shell"
    print_info "with Oh My Zsh and custom plugins installed"
    echo ""
    print_warning "Enjoy your riced Termux! 🚀"
    echo ""
}

# Run main function
main
EOF
