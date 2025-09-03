#!/bin/bash
set -euo pipefail

# Claude Global Config - Sync Script
# Updates existing project with latest templates

PROJECT_DIR="${1:-$(pwd)}"
TEMPLATES_DIR="$(dirname "$0")/../templates"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

log_debug() {
    echo -e "${BLUE}[DEBUG]${NC} $1"
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

log_info "Syncing Claude Global Config templates to: $PROJECT_DIR"

# Change to project directory
cd "$PROJECT_DIR"

# Check if this is a Claude Code project
if [ ! -d ".claude" ]; then
    log_error "This doesn't appear to be a Claude Code project (no .claude directory)"
    log_info "Use install.sh instead for new projects"
    exit 1
fi

# Backup existing files
backup_dir=".claude/backup-$(date +%Y%m%d-%H%M%S)"
log_info "Creating backup directory: $backup_dir"
mkdir -p "$backup_dir"

# Function to backup and update file
backup_and_update() {
    local source_file="$1"
    local target_file="$2"
    local description="$3"
    
    if [ -f "$target_file" ]; then
        log_debug "Backing up existing $description"
        cp "$target_file" "$backup_dir/$(basename "$target_file")"
        
        # Check if files are different
        if ! diff -q "$source_file" "$target_file" > /dev/null 2>&1; then
            log_info "Updating $description"
            cp "$source_file" "$target_file"
            log_info "✓ Updated $description"
            return 0
        else
            log_debug "$description is already up to date"
            return 1
        fi
    else
        log_info "Installing new $description"
        cp "$source_file" "$target_file"
        log_info "✓ Installed $description"
        return 0
    fi
}

# Update script templates
log_info "Updating script templates"
updated_count=0

if [ -f "$TEMPLATES_DIR/scripts/logger.sh" ]; then
    if backup_and_update "$TEMPLATES_DIR/scripts/logger.sh" ".claude/scripts/logger.sh" "logger.sh"; then
        chmod +x .claude/scripts/logger.sh
        ((updated_count++))
    fi
else
    log_warn "logger.sh template not found"
fi

# For logging.conf, we need to preserve customizations
if [ -f "$TEMPLATES_DIR/scripts/logging.conf" ]; then
    if [ -f ".claude/scripts/logging.conf" ]; then
        log_info "Checking logging.conf for updates"
        
        # Extract current PROJECT_LOG_NAME if set
        current_project_name=""
        if grep -q "PROJECT_LOG_NAME=" ".claude/scripts/logging.conf"; then
            current_project_name=$(grep "PROJECT_LOG_NAME=" ".claude/scripts/logging.conf" | head -1 | cut -d'"' -f2)
        fi
        
        # Backup current config
        cp ".claude/scripts/logging.conf" "$backup_dir/logging.conf"
        
        # Update with new template but preserve project name
        cp "$TEMPLATES_DIR/scripts/logging.conf" ".claude/scripts/logging.conf"
        if [ -n "$current_project_name" ]; then
            sed -i "s/export PROJECT_LOG_NAME=\"project\"/export PROJECT_LOG_NAME=\"$current_project_name\"/" .claude/scripts/logging.conf
            log_info "✓ Updated logging.conf (preserved PROJECT_LOG_NAME: $current_project_name)"
        else
            log_info "✓ Updated logging.conf (no custom PROJECT_LOG_NAME found)"
        fi
        ((updated_count++))
    else
        cp "$TEMPLATES_DIR/scripts/logging.conf" ".claude/scripts/logging.conf"
        log_info "✓ Installed logging.conf"
        ((updated_count++))
    fi
else
    log_warn "logging.conf template not found"
fi

# Update command templates
log_info "Updating command templates"

if [ -f "$TEMPLATES_DIR/commands/next-session.md" ]; then
    if backup_and_update "$TEMPLATES_DIR/commands/next-session.md" ".claude/commands/next-session.md" "next-session.md"; then
        ((updated_count++))
    fi
else
    log_warn "next-session.md template not found"
fi

# Update agent templates (preserve customizations)
log_info "Updating agent templates"
PROJECT_NAME=$(basename "$PROJECT_DIR")
quick_ref_file=".claude/agents/${PROJECT_NAME}-quick-reference.md"

if [ -f "$TEMPLATES_DIR/agents/quick-reference.md" ]; then
    if [ -f "$quick_ref_file" ]; then
        log_info "Quick reference exists - creating updated template as example"
        example_file=".claude/agents/quick-reference-template-$(date +%Y%m%d).md"
        sed "s/\[Project Name\]/$PROJECT_NAME/g" "$TEMPLATES_DIR/agents/quick-reference.md" > "$example_file"
        log_info "✓ Created updated template: $example_file"
        log_warn "Review and merge changes manually to preserve your customizations"
    else
        sed "s/\[Project Name\]/$PROJECT_NAME/g" "$TEMPLATES_DIR/agents/quick-reference.md" > "$quick_ref_file"
        log_info "✓ Installed ${PROJECT_NAME}-quick-reference.md"
        ((updated_count++))
    fi
else
    log_warn "quick-reference.md template not found"
fi

# Create directory structure if missing
log_info "Ensuring directory structure is complete"
mkdir -p .claude/{scripts,commands,agents,temp,logs}

# Summary
log_info "Sync completed!"
echo ""
echo "Summary:"
echo "- Files updated: $updated_count"
echo "- Backup created: $backup_dir"
echo ""

if [ $updated_count -gt 0 ]; then
    echo "Files were updated. You may want to:"
    echo "1. Review changes in $backup_dir"
    echo "2. Test updated functionality:"
    echo "   source .claude/scripts/logging.conf"
    echo "   source .claude/scripts/logger.sh"  
    echo "   init_logging"
    echo "   log_info 'Sync test successful'"
    echo "3. Merge any template updates with your customizations"
else
    echo "No files needed updating - your project is current!"
fi

echo ""
echo "For latest documentation, see:"
echo "https://github.com/your-username/claude-global-config"