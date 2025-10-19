#!/data/data/com.termux/files/usr/bin/bash

# Termux Welcome Message Customizer
# Remove or customize the default Termux welcome message

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_banner() {
    clear
    echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║${NC}  Termux Welcome Customizer       ${CYAN}║${NC}"
    echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

# Show menu
show_menu() {
    echo -e "${CYAN}Choose an option:${NC}"
    echo ""
    echo "1) Remove welcome message completely (clean)"
    echo "2) Minimal welcome (just neofetch)"
    echo "3) Custom minimal banner"
    echo "4) Custom banner with system info"
    echo "5) Restore default Termux welcome"
    echo "6) Exit"
    echo ""
}

# Option 1: Remove completely
remove_welcome() {
    print_info "Removing welcome message..."
    
    # Create empty motd
    touch "$PREFIX/etc/motd"
    chmod 644 "$PREFIX/etc/motd"
    
    # Remove neofetch from shell configs
    sed -i '/neofetch/d' "$HOME/.zshrc" 2>/dev/null
    sed -i '/neofetch/d' "$HOME/.bashrc" 2>/dev/null
    
    print_success "Welcome message removed!"
    print_info "Restart Termux to see changes"
}

# Option 2: Minimal (just neofetch)
minimal_neofetch() {
    print_info "Setting minimal neofetch welcome..."
    
    # Clear motd
    echo "" > "$PREFIX/etc/motd"
    
    # Ensure neofetch is in configs
    if ! grep -q "neofetch" "$HOME/.zshrc" 2>/dev/null; then
        echo "" >> "$HOME/.zshrc"
        echo "# Neofetch on startup" >> "$HOME/.zshrc"
        echo "neofetch --config none --colors 6 7 6 6 6 7 --ascii_colors 6 6 --backend ascii --ascii_distro android_small" >> "$HOME/.zshrc"
    fi
    
    if ! grep -q "neofetch" "$HOME/.bashrc" 2>/dev/null; then
        echo "" >> "$HOME/.bashrc"
        echo "# Neofetch on startup" >> "$HOME/.bashrc"
        echo "neofetch --config none --colors 6 7 6 6 6 7 --ascii_colors 6 6 --backend ascii --ascii_distro android_small" >> "$HOME/.bashrc"
    fi
    
    print_success "Minimal neofetch welcome set!"
    print_info "Restart Termux to see changes"
}

# Option 3: Custom minimal banner
custom_minimal() {
    print_info "Creating custom minimal banner..."
    
    cat > "$PREFIX/etc/motd" << 'MOTD_END'
╭─────────────────────────────────╮
│  Termux • Minimal & Aesthetic   │
╰─────────────────────────────────╯
MOTD_END

    chmod 644 "$PREFIX/etc/motd"
    
    # Remove neofetch from startup
    sed -i '/neofetch/d' "$HOME/.zshrc" 2>/dev/null
    sed -i '/neofetch/d' "$HOME/.bashrc" 2>/dev/null
    
    print_success "Custom minimal banner created!"
    print_info "Restart Termux to see changes"
}

# Option 4: Custom banner with system info
custom_with_info() {
    print_info "Creating custom banner with system info..."
    
    # Create a script for dynamic info
    cat > "$HOME/.termux_custom_welcome" << 'WELCOME_SCRIPT'
#!/data/data/com.termux/files/usr/bin/bash

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get system info
PACKAGES=$(dpkg -l | grep -c '^ii')
UPTIME=$(uptime -p | sed 's/up //')
SHELL_VER=$(basename "$SHELL")

# Print banner
echo -e "${CYAN}┌─────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}◉${NC} Termux ${YELLOW}•${NC} Ready to use      ${CYAN}│${NC}"
echo -e "${CYAN}└─────────────────────────────────────┘${NC}"
echo ""
echo -e "${BLUE}→${NC} Shell: ${GREEN}$SHELL_VER${NC}"
echo -e "${BLUE}→${NC} Packages: ${GREEN}$PACKAGES${NC}"
echo -e "${BLUE}→${NC} Uptime: ${GREEN}$UPTIME${NC}"
echo ""
WELCOME_SCRIPT

    chmod +x "$HOME/.termux_custom_welcome"
    
    # Clear motd
    echo "" > "$PREFIX/etc/motd"
    
    # Add to shell configs
    if ! grep -q ".termux_custom_welcome" "$HOME/.zshrc" 2>/dev/null; then
        sed -i '/neofetch/d' "$HOME/.zshrc" 2>/dev/null
        echo "" >> "$HOME/.zshrc"
        echo "# Custom welcome" >> "$HOME/.zshrc"
        echo "~/.termux_custom_welcome" >> "$HOME/.zshrc"
    fi
    
    if ! grep -q ".termux_custom_welcome" "$HOME/.bashrc" 2>/dev/null; then
        sed -i '/neofetch/d' "$HOME/.bashrc" 2>/dev/null
        echo "" >> "$HOME/.bashrc"
        echo "# Custom welcome" >> "$HOME/.bashrc"
        echo "~/.termux_custom_welcome" >> "$HOME/.bashrc"
    fi
    
    print_success "Custom banner with system info created!"
    print_info "Restart Termux to see changes"
}

# Option 5: Restore default
restore_default() {
    print_info "Restoring default Termux welcome..."
    
    cat > "$PREFIX/etc/motd" << 'DEFAULT_MOTD'
Welcome to Termux!

Docs:       https://termux.dev/docs
Donate:     https://termux.dev/donate
Community:  https://termux.dev/community

Working with packages:
 - Search:  pkg search <query>
 - Install: pkg install <package>
 - Upgrade: pkg upgrade

Subscribing to additional repositories:
 - Root:    pkg install root-repo
 - X11:     pkg install x11-repo

For fixing any repository issues,
try 'termux-change-repo' command.

Report issues at https://termux.dev/issues

DEFAULT_MOTD

    chmod 644 "$PREFIX/etc/motd"
    
    print_success "Default Termux welcome restored!"
    print_info "Restart Termux to see changes"
}

# Main function
main() {
    print_banner
    
    while true; do
        show_menu
        read -p "Enter your choice (1-6): " choice
        echo ""
        
        case $choice in
            1)
                remove_welcome
                break
                ;;
            2)
                minimal_neofetch
                break
                ;;
            3)
                custom_minimal
                break
                ;;
            4)
                custom_with_info
                break
                ;;
            5)
                restore_default
                break
                ;;
            6)
                print_info "Exiting..."
                exit 0
                ;;
            *)
                print_warning "Invalid choice. Please try again."
                echo ""
                ;;
        esac
    done
    
    echo ""
    print_info "Done! Run 'exit' and restart Termux to see changes."
}

# Run
main
