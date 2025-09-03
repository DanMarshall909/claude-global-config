# Claude Global Configuration

Universal configuration and templates for Claude Code projects, featuring proven patterns for logging, error handling, documentation, and token efficiency.

## 🎯 **Purpose**

This repository provides a standardized foundation for Claude Code integration across all projects, implementing:

- ✅ **Universal logging infrastructure** with structured levels and session correlation
- ✅ **Token-efficient patterns** for handling verbose command output  
- ✅ **Robust script standards** with comprehensive error handling
- ✅ **Documentation templates** for consistent project documentation
- ✅ **Proven patterns** extracted from mature production projects

## 📋 **Global Rules Enforced**

### Core Development Rules
- **Test-First Service Design** with complete test doubles
- **TDD enforcement** with proper test naming conventions
- **Architecture documentation** with component placement guidance
- **TODO tracking** for complex multi-step tasks

### Universal Claude Code Rules  
- **Logging Standards**: Centralized logging with structured levels and dual output
- **Script Robustness**: Error handling, metadata capture, session correlation
- **Documentation Standards**: Quick reference guides with examples and troubleshooting  
- **Token Efficiency**: Temp file organization for verbose outputs with parsed summaries
- **Temp File Organization**: Standardized `.claude/temp/` usage for all verbose outputs

## 📁 **Repository Structure**

```
claude-global-config/
├── CLAUDE.md                    # Global rules and configuration
├── README.md                    # This documentation
├── .gitignore                   # Comprehensive exclusion patterns
├── templates/                   # Reusable templates
│   ├── scripts/                 # Universal script infrastructure
│   │   ├── logger.sh            # Centralized logging utility
│   │   └── logging.conf         # Logging configuration template
│   ├── commands/                # Claude command templates
│   │   └── next-session.md      # Session transition command
│   └── agents/                  # Agent definition templates
│       └── quick-reference.md   # Project quick reference template
├── docs/                        # Documentation
│   ├── SETUP.md                 # Installation and setup guide
│   └── PATTERNS.md              # Universal patterns and examples
└── scripts/                     # Utility scripts
    ├── install.sh               # Template installation script
    └── sync.sh                  # Update existing projects
```

## 🚀 **Quick Start**

### For New Projects
```bash
# 1. Set up Claude directory structure
mkdir -p .claude/{scripts,commands,agents,temp,logs}

# 2. Copy universal templates
cp ~/.claude/templates/scripts/* .claude/scripts/
cp ~/.claude/templates/commands/* .claude/commands/  
cp ~/.claude/templates/agents/quick-reference.md .claude/agents/[project-name]-quick-reference.md

# 3. Customize configuration
vim .claude/scripts/logging.conf  # Set PROJECT_LOG_NAME, etc.
vim .claude/agents/[project-name]-quick-reference.md  # Add project commands
```

### For Existing Projects
```bash
# Use sync script to update with latest templates
~/.claude/scripts/sync.sh
```

## 📊 **Key Features**

### Centralized Logging
```bash
# Source in any script
source .claude/scripts/logging.conf
source .claude/scripts/logger.sh
init_logging

# Use structured logging
log_info "Operation started"
log_debug "Debug information"
log_error "Error occurred"
```

### Token-Efficient Output Processing
```bash
# Capture verbose output to temp files
mkdir -p .claude/temp
dotnet test > .claude/temp/test-output.txt 2>&1

# Extract only essentials for chat
grep -E "(Passed|Failed|Total)" .claude/temp/test-output.txt
```

### Robust Error Handling
```bash
#!/bin/bash
set -euo pipefail  # Standard robustness pattern

source .claude/scripts/logger.sh
init_logging

# Comprehensive error handling included
```

### Documentation Templates
- **Quick Reference**: Example-driven command documentation
- **Troubleshooting**: Common issues and debug commands
- **Integration Patterns**: Environment variables and configuration

## 📖 **Documentation**

- **[SETUP.md](docs/SETUP.md)** - Detailed installation and configuration
- **[PATTERNS.md](docs/PATTERNS.md)** - Universal patterns with examples
- **[CLAUDE.md](CLAUDE.md)** - Complete global rules reference

## 🔧 **Installation Scripts**

### Automated Setup
```bash
# Install templates to new project
~/.claude/scripts/install.sh /path/to/project

# Sync existing project with latest templates  
~/.claude/scripts/sync.sh /path/to/project
```

## ✅ **Benefits**

### For Individual Projects
- ✅ **Consistent logging** across all scripts and commands
- ✅ **Token optimization** with structured output processing
- ✅ **Robust error handling** with comprehensive metadata capture
- ✅ **Standardized documentation** with quick reference guides

### For Teams
- ✅ **Shared standards** across all Claude Code integrations  
- ✅ **Proven patterns** from production project experience
- ✅ **Easy onboarding** with template-based setup
- ✅ **Version-controlled** configuration with collaborative updates

### For Productivity
- ✅ **Reduced token usage** through efficient output processing
- ✅ **Faster debugging** with comprehensive logging infrastructure  
- ✅ **Consistent workflows** with standardized command patterns
- ✅ **Quality documentation** with template-driven guides

## 🛠️ **Customization**

### Project-Specific Settings
```bash
# In .claude/scripts/logging.conf
export PROJECT_LOG_NAME="myproject"
export PROJECT_SESSION_ID="MYPROJ-${USER}-$(date +%Y%m%d-%H%M%S)"

# Environment-specific log levels
export PROJECT_LOG_LEVEL=1  # DEBUG for development
export PROJECT_LOG_LEVEL=2  # INFO for production
```

### Template Customization
1. **Quick Reference**: Update with project commands and examples
2. **Logging Config**: Set project name and session patterns  
3. **Next Session**: Modify for project-specific test naming conventions
4. **Error Handling**: Add project-specific error recovery patterns

## 🚫 **What's NOT Included**

This repository focuses on universal patterns. Project-specific items are excluded:

- ❌ **Project-specific hooks** (like TDD phase-complete scripts)
- ❌ **Domain-specific logic** (business rules, workflows)  
- ❌ **API integrations** (Jira, GitHub, etc.)
- ❌ **Personal configuration** (credentials, tokens, personal settings)

## 🤝 **Contributing**

1. **Fork** the repository
2. **Create** feature branch for improvements
3. **Test** with multiple project types
4. **Submit** pull request with clear description
5. **Update** documentation for any new patterns

## 📄 **License**

This configuration is designed for sharing and collaboration. Use freely across teams and projects.

---

**Created from proven patterns in production Claude Code projects. Continuously updated with new universal patterns and improvements.**