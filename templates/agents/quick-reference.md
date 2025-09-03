# [Project Name] Quick Reference Template

## Core Commands

### Primary Operations
```bash
# Replace with your project's main commands
[tool] [command] [options]                # Description
[tool] [command] --help                   # Show help for specific command
```

### Configuration Management
```bash
# Configuration commands
[tool] config show                        # Show current configuration
[tool] config set [key] [value]          # Set configuration value
[tool] config validate                    # Validate configuration
```

### Development Operations
```bash
# Development workflow commands
[tool] init                              # Initialize new workspace
[tool] build                             # Build project
[tool] test                              # Run tests
[tool] lint                              # Run linting
```

## Configuration

### Environment Variables
```bash
# Required environment variables
export [PROJECT]_API_TOKEN="your-token"
export [PROJECT]_LOG_LEVEL="Debug|Info|Warning|Error"
export [PROJECT]_CONFIG_PATH="/path/to/config"
```

### Configuration Files
```json
{
  "ProjectSettings": {
    "LogLevel": "Information",
    "OutputDirectory": "./output",
    "Features": {
      "FeatureFlag1": true,
      "FeatureFlag2": false
    }
  }
}
```

## File Structure

### Project Directory
```
project-root/
├── .claude/               # Claude Code integration
│   ├── commands/          # Custom Claude commands
│   ├── agents/           # Specialized agents
│   ├── temp/             # Temporary output files
│   └── logs/             # Logging output
├── config/               # Configuration files
├── src/                  # Source code
├── test/                 # Test files
└── docs/                 # Documentation
```

### Claude Integration
```
.claude/
├── commands/             # Custom commands for Claude Code
├── agents/              # Specialized agent definitions
├── temp/                # Temporary output files
│   ├── test-output.txt  # Test results
│   ├── build-output.txt # Build output
│   └── lint-results.txt # Linting results
└── logs/                # Script logging
    └── project-YYYYMMDD.log
```

## Common Patterns

### Starting New Work
```bash
# 1. Check current state
[tool] status

# 2. Initialize if needed
[tool] init

# 3. Begin work session
[tool] [primary-command] [identifier]

# 4. Follow prompts and workflows
```

### Testing and Validation
```bash
# Run tests with token-efficient output
mkdir -p .claude/temp
[tool] test > .claude/temp/test-output.txt 2>&1
grep -E "(Passed|Failed|Total)" .claude/temp/test-output.txt

# Build and validate
[tool] build > .claude/temp/build-output.txt 2>&1
grep -E "(Success|Error|Warning)" .claude/temp/build-output.txt
```

### Error Recovery
```bash
# Check logs for issues
tail -n 50 .claude/logs/project-$(date +%Y%m%d).log

# Validate configuration
[tool] config validate

# Reset to clean state
[tool] reset --confirm
```

## Integration Points

### External Services
- Service 1: Description and configuration
- Service 2: Description and configuration
- Service 3: Description and configuration

### Development Tools
- IDE integration: Setup and usage
- Build tools: Configuration and commands
- Testing frameworks: Setup and patterns

### Quality Gates
- Code standards and linting rules
- Test coverage requirements
- Performance benchmarks
- Security requirements

## Error Recovery

### Common Issues
- **Configuration errors**: Run `[tool] config validate`
- **Permission issues**: Check file permissions and API tokens
- **Connection failures**: Verify network and service availability
- **Build failures**: Check logs in `.claude/temp/build-output.txt`

### Debug Commands
```bash
# Verbose logging
export [PROJECT]_LOG_LEVEL="Debug"
[tool] [command] --verbose

# Dry run to preview
[tool] [command] --dry-run

# Output to temp files for analysis
[tool] [command] > .claude/temp/debug-output.txt 2>&1
```

## Environment Setup

### Dependencies
```bash
# List required dependencies and installation commands
dependency1 --version
dependency2 --version
```

### Installation
```bash
# Installation steps
curl -sSL [install-url] | bash
# or
npm install -g [package-name]
# or
pip install [package-name]
```

## Tips & Best Practices

### Development Workflow
1. Always validate configuration before starting
2. Use temp files for verbose command output
3. Check logs when issues occur
4. Follow project naming conventions
5. Test changes before committing

### Performance Optimization
- Use `--quiet` flags to reduce output
- Pipe verbose output to `.claude/temp/` files
- Parse only essential information for chat
- Use appropriate log levels

### Troubleshooting
- Check `.claude/logs/` for detailed error information
- Use `--dry-run` to preview operations
- Validate configuration regularly
- Monitor resource usage during operations

## Help System

### Getting Help
```bash
[tool] --help                            # General help
[tool] [command] --help                  # Command-specific help
[tool] [subcommand] --help               # Subcommand help
```

### Documentation
- This quick reference for common operations
- `CLAUDE.md` for project-specific context
- `ARCHITECTURE.md` for system structure
- Individual command help via `--help` flag

## Customization Instructions

To customize this template for your project:

1. Replace `[Project Name]` with your actual project name
2. Replace `[tool]` with your CLI tool name
3. Update commands with actual project commands
4. Modify file structure to match your project
5. Update environment variables with actual names
6. Add project-specific configuration examples
7. Include actual integration points and services
8. Update error recovery with project-specific issues
9. Add actual dependencies and installation steps