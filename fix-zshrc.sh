#!/data/data/com.termux/files/usr/bin/bash

# Fix .zshrc Parse Error
# Recreates a clean, working .zshrc configuration

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}  Fixing Zsh Configuration Error   ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════╝${NC}"
echo ""

# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ]; then
    BACKUP="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.zshrc" "$BACKUP"
    echo -e "${BLUE}[i]${NC} Backed up old .zshrc to: $BACKUP"
fi

# Create new clean .zshrc
echo -e "${BLUE}[i]${NC} Creating new .zshrc..."

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
    zsh-completions
    colored-man-pages
    command-not-found
)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# =====================================
# Aliases
# =====================================

# List commands
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

# Navigation
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Package management
alias update='pkg update && pkg upgrade'
alias install='pkg install'
alias search='pkg search'
alias clean='apt clean && apt autoclean'

# =====================================
# Custom Prompt
# =====================================
PROMPT='%F{cyan}╭─%f %F{green}%n%f %F{yellow}@%f %F{blue}termux%f %F{magenta}%~%f
%F{cyan}╰─%f %F{red}❯%f '

# =====================================
# Startup
# =====================================

# Neofetch on startup (comment out if you don't want it)
if command -v neofetch &> /dev/null; then
    neofetch --config none --colors 6 7 6 6 6 7 --ascii_colors 6 6 --backend ascii --ascii_distro android_small
fi
ZSHRC_EOF

echo -e "${GREEN}[✓]${NC} New .zshrc created successfully!"
echo ""

# Also fix .bashrc just in case
echo -e "${BLUE}[i]${NC} Fixing .bashrc as well..."

if [ -f "$HOME/.bashrc" ]; then
    BACKUP_BASH="$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$HOME/.bashrc" "$BACKUP_BASH"
fi

cat > "$HOME/.bashrc" << 'BASHRC_EOF'
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
BASHRC_EOF

echo -e "${GREEN}[✓]${NC} .bashrc fixed successfully!"
echo ""
echo -e "${CYAN}═══════════════════════════════════════${NC}"
echo -e "${GREEN}[✓]${NC} All configuration files fixed!"
echo ""
echo -e "${BLUE}[i]${NC} Now run: ${CYAN}source ~/.zshrc${NC}"
echo -e "${BLUE}[i]${NC} Or restart Termux: ${CYAN}exit${NC}"
echo ""
