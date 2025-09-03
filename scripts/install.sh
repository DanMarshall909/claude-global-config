#!/bin/bash
set -euo pipefail

# Claude Global Config - Installation Script
# Installs universal templates to a new project

PROJECT_DIR="${1:-$(pwd)}"
TEMPLATES_DIR="$(dirname "$0")/../templates"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Validate arguments
if [ ! -d "$PROJECT_DIR" ]; then
    log_error "Project directory does not exist: $PROJECT_DIR"
    exit 1
fi

if [ ! -d "$TEMPLATES_DIR" ]; then
    log_error "Templates directory not found: $TEMPLATES_DIR"
    exit 1
fi

log_info "Installing Claude Global Config templates to: $PROJECT_DIR"

# Change to project directory
cd "$PROJECT_DIR"

# Create directory structure
log_info "Creating .claude directory structure"
mkdir -p .claude/{scripts,commands,agents,temp,logs}

# Install script templates
log_info "Installing script templates"
if [ -f "$TEMPLATES_DIR/scripts/logger.sh" ]; then
    cp "$TEMPLATES_DIR/scripts/logger.sh" .claude/scripts/
    chmod +x .claude/scripts/logger.sh
    log_info "✓ Installed logger.sh"
else
    log_warn "logger.sh template not found"
fi

if [ -f "$TEMPLATES_DIR/scripts/logging.conf" ]; then
    cp "$TEMPLATES_DIR/scripts/logging.conf" .claude/scripts/
    log_info "✓ Installed logging.conf"
else
    log_warn "logging.conf template not found"
fi

# Install command templates
log_info "Installing command templates"
if [ -f "$TEMPLATES_DIR/commands/next-session.md" ]; then
    cp "$TEMPLATES_DIR/commands/next-session.md" .claude/commands/
    log_info "✓ Installed next-session.md"
else
    log_warn "next-session.md template not found"
fi

# Install agent templates (with project name customization)
log_info "Installing agent templates"
PROJECT_NAME=$(basename "$PROJECT_DIR")
if [ -f "$TEMPLATES_DIR/agents/quick-reference.md" ]; then
    sed "s/\[Project Name\]/$PROJECT_NAME/g" "$TEMPLATES_DIR/agents/quick-reference.md" > ".claude/agents/${PROJECT_NAME}-quick-reference.md"
    log_info "✓ Installed ${PROJECT_NAME}-quick-reference.md"
else
    log_warn "quick-reference.md template not found"
fi

# Customize logging configuration
log_info "Customizing logging configuration"
if [ -f ".claude/scripts/logging.conf" ]; then
    # Update project name in logging config
    sed -i "s/export PROJECT_LOG_NAME=\"project\"/export PROJECT_LOG_NAME=\"$PROJECT_NAME\"/" .claude/scripts/logging.conf
    log_info "✓ Updated PROJECT_LOG_NAME to: $PROJECT_NAME"
fi

# Create .gitignore entries if .gitignore exists
if [ -f ".gitignore" ]; then
    log_info "Updating .gitignore"
    
    # Check if Claude entries already exist
    if ! grep -q ".claude/temp/" .gitignore; then
        echo "" >> .gitignore
        echo "# Claude Code integration" >> .gitignore
        echo ".claude/temp/" >> .gitignore
        echo ".claude/logs/" >> .gitignore
        log_info "✓ Added .claude directories to .gitignore"
    else
        log_warn ".gitignore already contains .claude entries"
    fi
else
    log_warn ".gitignore not found - you may want to exclude .claude/temp/ and .claude/logs/"
fi

# Success message with next steps
log_info "Installation completed successfully!"
echo ""
echo "Next steps:"
echo "1. Customize .claude/scripts/logging.conf with your project settings"
echo "2. Update .claude/agents/${PROJECT_NAME}-quick-reference.md with your commands"
echo "3. Test logging setup:"
echo "   source .claude/scripts/logging.conf"
echo "   source .claude/scripts/logger.sh"
echo "   init_logging"
echo "   log_info 'Installation test successful'"
echo ""
echo "For detailed setup instructions, see:"
echo "https://github.com/DanMarshall909/claude-global-config/blob/main/docs/SETUP.md"