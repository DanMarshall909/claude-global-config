# Universal Claude Code Patterns

## Logging Patterns

### Basic Script with Logging
```bash
#!/bin/bash
set -euo pipefail  # SCRIPT ROBUSTNESS RULE

# Source configuration and logging
source .claude/scripts/logging.conf
source .claude/scripts/logger.sh

# Initialize logging
init_logging
log_info "Script started: $0"

# Your script logic here
log_debug "Processing step 1"
if some_command; then
    log_info "Step 1 completed successfully"
else
    log_error "Step 1 failed"
    exit 1
fi

# Script will auto-cleanup logging on exit
```

### Command Execution with Logging
```bash
# Log command execution
log_command "dotnet build --configuration Release"

# Or manual execution with logging
log_debug "Starting build process"
if dotnet build --configuration Release > .claude/temp/build-output.txt 2>&1; then
    log_info "Build completed successfully"
    grep -E "(Success|Warning)" .claude/temp/build-output.txt
else
    log_error "Build failed"
    log_error "$(cat .claude/temp/build-output.txt)"
    exit 1
fi
```

## Temp File Patterns

### Test Output Processing
```bash
# TEMP FILE ORGANIZATION RULE pattern
mkdir -p .claude/temp

# Run tests and capture output
dotnet test --logger "console;verbosity=detailed" > .claude/temp/test-output.txt 2>&1

# Extract essential information only
echo "Test Summary:"
grep -E "(Passed!|Failed!|Total tests)" .claude/temp/test-output.txt

# Show failures if any
if grep -q "Failed!" .claude/temp/test-output.txt; then
    echo "Test Failures:"
    grep -A 5 -B 5 "Failed" .claude/temp/test-output.txt
fi
```

### Build Output Processing
```bash
# Build with temp file capture
make build > .claude/temp/build-output.txt 2>&1

# Extract build summary
echo "Build Summary:"
grep -E "(error|warning|success|completed)" .claude/temp/build-output.txt | tail -10

# Show errors if any
if grep -q "error" .claude/temp/build-output.txt; then
    echo "Build Errors:"
    grep "error" .claude/temp/build-output.txt
fi
```

### Coverage Analysis
```bash
# Run coverage analysis
dotnet test --collect:"XPlat Code Coverage" > .claude/temp/coverage-output.txt 2>&1

# Extract coverage summary
echo "Coverage Summary:"
grep -E "(Line|Branch|Method)" .claude/temp/coverage-output.txt
```

## Documentation Patterns

### Quick Reference Structure
Follow this pattern for `.claude/agents/[project]-quick-reference.md`:

1. **Core Commands** - Primary operations with examples
2. **Configuration** - Environment variables and config files
3. **File Structure** - Project layout and Claude integration
4. **Common Patterns** - Frequent workflows
5. **Error Recovery** - Troubleshooting and debug commands
6. **Help System** - How to get help

### Command Documentation Format
```markdown
### Command Category
\`\`\`bash
command --option value                    # Description
command --help                           # Show help
\`\`\`

### Configuration Example
\`\`\`json
{
  "setting": "value",
  "feature": true
}
\`\`\`
```

## Error Handling Patterns

### Robust Script Pattern
```bash
#!/bin/bash
set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Source utilities
source .claude/scripts/logging.conf
source .claude/scripts/logger.sh
init_logging

# Error handling function
handle_error() {
    local exit_code=$?
    log_error "Script failed with exit code: $exit_code"
    log_error "Failed command: $BASH_COMMAND"
    log_error "Line: $1"
    exit $exit_code
}

# Set error trap
trap 'handle_error $LINENO' ERR

# Your script logic here
log_info "Starting script execution"
```

### Command Validation Pattern
```bash
# Validate required commands exist
check_dependencies() {
    local deps=("git" "jq" "curl")
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" > /dev/null 2>&1; then
            log_fatal "Required dependency not found: $dep"
            log_error_exit "Missing dependencies" 1
        fi
    done
    log_info "All dependencies validated"
}

check_dependencies
```

## Session Management Patterns

### Session Correlation
```bash
# Set session ID for correlation
export PROJECT_SESSION_ID="MYPROJ-${USER}-$(date +%Y%m%d-%H%M%S)"

# Log session start
log_info "Session started: $PROJECT_SESSION_ID"

# Use session ID in temp files
temp_file=".claude/temp/session-${PROJECT_SESSION_ID}-output.txt"
some_command > "$temp_file" 2>&1
```

### Context Preservation
```bash
# Save context at key points
save_context() {
    local context_file=".claude/temp/context-$(date +%Y%m%d-%H%M%S).json"
    jq -n \
        --arg session "$PROJECT_SESSION_ID" \
        --arg pwd "$(pwd)" \
        --arg git_branch "$(git branch --show-current 2>/dev/null || echo 'unknown')" \
        --arg git_commit "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')" \
        '{
            session: $session,
            timestamp: now | strftime("%Y-%m-%dT%H:%M:%S.%3NZ"),
            workingDirectory: $pwd,
            gitBranch: $git_branch,
            gitCommit: $git_commit
        }' > "$context_file"
    log_debug "Context saved: $context_file"
}
```

## Token Efficiency Patterns

### Parsing Output for Essential Info
```bash
# Instead of showing full output, extract essentials
parse_test_results() {
    local output_file="$1"
    
    echo "Test Results:"
    # Extract counts
    grep -E "Total tests: [0-9]+|Passed: [0-9]+|Failed: [0-9]+" "$output_file" || echo "No test summary found"
    
    # Show failures only if any
    if grep -q "Failed: [1-9]" "$output_file"; then
        echo "Failed Tests:"
        grep -A 3 "Failed:" "$output_file" | head -20
    fi
    
    # Show timing if available
    grep -E "Total time:|Duration:" "$output_file" || true
}

# Usage
parse_test_results .claude/temp/test-output.txt
```

### Structured Data Extraction
```bash
# Extract structured data from logs
extract_metrics() {
    local log_file="$1"
    
    jq -n \
        --arg errors "$(grep -c "ERROR" "$log_file" || echo 0)" \
        --arg warnings "$(grep -c "WARN" "$log_file" || echo 0)" \
        --arg duration "${SECONDS:-0}" \
        '{
            errors: ($errors | tonumber),
            warnings: ($warnings | tonumber),
            duration: ($duration | tonumber),
            timestamp: now | strftime("%Y-%m-%dT%H:%M:%S.%3NZ")
        }'
}
```

## Integration Patterns

### Git Metadata Capture
```bash
capture_git_metadata() {
    local metadata_file=".claude/temp/git-metadata.json"
    
    jq -n \
        --arg branch "$(git branch --show-current 2>/dev/null || echo 'unknown')" \
        --arg commit "$(git rev-parse HEAD 2>/dev/null || echo 'unknown')" \
        --arg status "$(git status --porcelain 2>/dev/null | wc -l)" \
        '{
            branch: $branch,
            commit: $commit,
            uncommittedChanges: ($status | tonumber),
            timestamp: now | strftime("%Y-%m-%dT%H:%M:%S.%3NZ")
        }' > "$metadata_file"
    
    log_debug "Git metadata captured: $metadata_file"
}
```

### Environment Capture
```bash
capture_environment() {
    local env_file=".claude/temp/environment.json"
    
    jq -n \
        --arg user "${USER:-unknown}" \
        --arg shell "${SHELL:-unknown}" \
        --arg pwd "$(pwd)" \
        --arg hostname "$(hostname)" \
        '{
            user: $user,
            shell: $shell,
            workingDirectory: $pwd,
            hostname: $hostname,
            timestamp: now | strftime("%Y-%m-%dT%H:%M:%S.%3NZ"),
            sessionId: env.PROJECT_SESSION_ID // "unknown"
        }' > "$env_file"
    
    log_debug "Environment captured: $env_file"
}
```

## Best Practices Summary

1. **Always use `set -euo pipefail`** in bash scripts
2. **Source logging utilities** in every script
3. **Capture verbose output** in `.claude/temp/` files
4. **Extract only essential information** for chat
5. **Use structured data formats** (JSON) for complex information
6. **Correlate activities** with session IDs
7. **Document patterns** in project quick reference
8. **Follow token efficiency rules** for all output processing

These patterns ensure consistency across all Claude Code projects while maximizing efficiency and maintainability.