# Claude Global Config Setup Guide

## Installation

### New Project Setup
1. **Copy templates to your project:**
   ```bash
   # Copy logging infrastructure
   cp ~/.claude/templates/scripts/logger.sh .claude/scripts/
   cp ~/.claude/templates/scripts/logging.conf .claude/scripts/
   
   # Copy command templates
   cp ~/.claude/templates/commands/next-session.md .claude/commands/
   
   # Copy agent templates
   cp ~/.claude/templates/agents/quick-reference.md .claude/agents/[project-name]-quick-reference.md
   ```

2. **Customize for your project:**
   - Edit `logging.conf` to set PROJECT_LOG_NAME and other project-specific settings
   - Customize `quick-reference.md` with your project's commands and patterns
   - Update `next-session.md` with project-specific test naming conventions

3. **Set up directory structure:**
   ```bash
   mkdir -p .claude/temp .claude/logs .claude/scripts .claude/commands .claude/agents
   ```

### Environment Variables
```bash
# Basic logging configuration
export PROJECT_LOG_LEVEL=1  # DEBUG level
export PROJECT_LOG_NAME="myproject"
export PROJECT_SESSION_ID="MYPROJECT-${USER}-$(date +%Y%m%d-%H%M%S)"

# Add to your shell profile (.bashrc, .zshrc, etc.)
echo 'export PROJECT_LOG_LEVEL=1' >> ~/.bashrc
```

### Script Integration
To use the logging infrastructure in your scripts:

```bash
#!/bin/bash
set -euo pipefail  # Script robustness rule

# Source the logging configuration
source .claude/scripts/logging.conf

# Source the logging utilities
source .claude/scripts/logger.sh

# Initialize logging
init_logging

# Use logging functions
log_info "Script started"
log_debug "Debug information"
log_error "Error occurred"
```

## Configuration

### Logging Levels
- **0 (TRACE)**: Detailed debugging, command outputs
- **1 (DEBUG)**: Debugging info, file operations, environment details  
- **2 (INFO)**: General information, successful operations (default)
- **3 (WARN)**: Warnings, non-fatal issues
- **4 (ERROR)**: Error conditions, failed operations
- **5 (FATAL)**: Fatal errors requiring intervention

### Temp File Usage
Always pipe verbose output to temp files:

```bash
# Test output
mkdir -p .claude/temp
dotnet test > .claude/temp/test-output.txt 2>&1
grep -E "(Passed|Failed|Total)" .claude/temp/test-output.txt

# Build output  
make build > .claude/temp/build-output.txt 2>&1
grep -E "(Success|Error|Warning)" .claude/temp/build-output.txt

# Linting output
eslint . > .claude/temp/lint-results.txt 2>&1
grep -E "(error|warning)" .claude/temp/lint-results.txt
```

## Project Customization

### Logging Configuration
Edit `.claude/scripts/logging.conf`:

```bash
# Set your project name
export PROJECT_LOG_NAME="myproject"

# Set session ID pattern
export PROJECT_SESSION_ID="MYPROJ-${USER}-$(date +%Y%m%d-%H%M%S)"

# Adjust log level for development vs production
export PROJECT_LOG_LEVEL=1  # DEBUG for development
# export PROJECT_LOG_LEVEL=2  # INFO for production
```

### Quick Reference Guide
Customize `.claude/agents/[project]-quick-reference.md`:

1. Replace `[Project Name]` with your project name
2. Update `[tool]` with your CLI command name
3. Add your actual commands and examples
4. Include project-specific troubleshooting
5. Document your environment variables
6. Add integration points and services

### Next Session Command
Customize `.claude/commands/next-session.md`:

1. Update test naming patterns (e.g., replace "Gerund_Context" with your convention)
2. Modify architecture references (VSA, layered, etc.)
3. Add project-specific documentation files to reference
4. Update success criteria based on your workflow

## Verification

### Test Logging Setup
```bash
# Test basic logging
source .claude/scripts/logging.conf
source .claude/scripts/logger.sh
init_logging
log_info "Logging test successful"

# Check log files created
ls -la .claude/logs/
```

### Test Temp Directory
```bash
# Test temp file creation
mkdir -p .claude/temp
echo "Test output" > .claude/temp/test-file.txt
ls -la .claude/temp/
```

### Verify Git Ignoring
```bash
# Check that temp and log files are ignored
git status
# Should not show .claude/temp/ or .claude/logs/ as untracked
```

## Integration with Global Rules

This setup enforces the global Claude Code rules:

- ✅ **LOGGING STANDARDS RULE**: Centralized logging with structured levels
- ✅ **SCRIPT ROBUSTNESS RULE**: Error handling and metadata capture
- ✅ **DOCUMENTATION STANDARDS RULE**: Quick reference guide template
- ✅ **TEMP FILE ORGANIZATION RULE**: Organized temp file usage

## Troubleshooting

### Common Issues

**Logging not working:**
- Check that logging.conf is sourced before logger.sh
- Verify log directory permissions
- Ensure PROJECT_LOG_NAME is set

**Temp files not created:**
- Check directory permissions
- Verify .claude/temp directory exists
- Ensure commands are redirected properly

**Git tracking unwanted files:**
- Check .gitignore includes patterns from global template
- Add project-specific patterns as needed

### Debug Commands
```bash
# Check environment variables
env | grep PROJECT_LOG

# Test logging functions
log_debug "Debug test message"

# Check log files
tail -f .claude/logs/[project-name]-$(date +%Y%m%d).log
```