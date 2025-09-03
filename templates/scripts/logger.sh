#!/bin/bash
# Universal Centralized Logging Utility for Claude Code Projects
# Version: 2.0.0 (Universal)
# Usage: source logger.sh

# Configuration
LOG_LEVEL_TRACE=0
LOG_LEVEL_DEBUG=1
LOG_LEVEL_INFO=2
LOG_LEVEL_WARN=3
LOG_LEVEL_ERROR=4
LOG_LEVEL_FATAL=5

# Default log level (can be overridden by PROJECT_LOG_LEVEL environment variable)
DEFAULT_LOG_LEVEL=${PROJECT_LOG_LEVEL:-$LOG_LEVEL_INFO}

# Log file configuration - universal pattern
PROJECT_NAME=${PROJECT_LOG_NAME:-"project"}
LOG_DIR="${PROJECT_LOG_DIR:-$(pwd)/.claude/logs}"
LOG_FILE="${LOG_DIR}/${PROJECT_NAME}-$(date +%Y%m%d).log"
SESSION_LOG_FILE="${LOG_DIR}/session-$(date +%Y%m%d-%H%M%S).log"

# Colors for console output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Initialize logging
init_logging() {
    # Ensure log directory exists
    mkdir -p "$LOG_DIR"
    
    # Create log file if it doesn't exist
    touch "$LOG_FILE"
    touch "$SESSION_LOG_FILE"
    
    # Log initialization
    log_info "=== Universal Script Logging Initialized ==="
    log_info "Log Level: $DEFAULT_LOG_LEVEL"
    log_info "Log Directory: $LOG_DIR"
    log_info "Session ID: ${PROJECT_SESSION_ID:-unknown}"
    log_info "Script: ${0##*/}"
    log_info "PID: $$"
    log_info "Timestamp: $(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")"
}

# Core logging function
write_log() {
    local level=$1
    local level_name=$2
    local color=$3
    local message=$4
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
    local script_name="${0##*/}"
    local session_id="${PROJECT_SESSION_ID:-unknown}"
    local pid=$$
    
    # Check if we should log this level
    if [ $level -lt $DEFAULT_LOG_LEVEL ]; then
        return 0
    fi
    
    # Format log entry
    local log_entry="[$timestamp] [$level_name] [$script_name:$pid] [$session_id] $message"
    local console_entry="${color}[$level_name]${NC} [$script_name] $message"
    
    # Write to log file
    echo "$log_entry" >> "$LOG_FILE"
    echo "$log_entry" >> "$SESSION_LOG_FILE"
    
    # Write to console (respecting log level)
    if [ $level -ge $DEFAULT_LOG_LEVEL ]; then
        echo -e "$console_entry" >&2
    fi
}

# Logging functions
log_trace() {
    write_log $LOG_LEVEL_TRACE "TRACE" "$CYAN" "$1"
}

log_debug() {
    write_log $LOG_LEVEL_DEBUG "DEBUG" "$BLUE" "$1"
}

log_info() {
    write_log $LOG_LEVEL_INFO "INFO" "$GREEN" "$1"
}

log_warn() {
    write_log $LOG_LEVEL_WARN "WARN" "$YELLOW" "$1"
}

log_error() {
    write_log $LOG_LEVEL_ERROR "ERROR" "$RED" "$1"
}

log_fatal() {
    write_log $LOG_LEVEL_FATAL "FATAL" "$WHITE" "$1"
}

# Utility functions
log_command() {
    local cmd="$1"
    log_debug "Executing command: $cmd"
    
    # Execute command and capture output
    local output
    local exit_code
    
    if output=$(eval "$cmd" 2>&1); then
        exit_code=0
        log_trace "Command output: $output"
        log_debug "Command succeeded: $cmd"
    else
        exit_code=$?
        log_error "Command failed with exit code $exit_code: $cmd"
        log_error "Command output: $output"
    fi
    
    return $exit_code
}

log_file_operation() {
    local operation="$1"
    local file_path="$2"
    local details="${3:-""}"
    
    log_debug "File operation: $operation - $file_path"
    if [ -n "$details" ]; then
        log_trace "Operation details: $details"
    fi
    
    # Validate file operation
    case "$operation" in
        "create"|"write")
            if [ -f "$file_path" ]; then
                log_info "File operation successful: $operation - $file_path"
            else
                log_error "File operation failed: $operation - $file_path (file not found)"
            fi
            ;;
        "read")
            if [ -r "$file_path" ]; then
                log_debug "File readable: $file_path"
            else
                log_error "File not readable: $file_path"
            fi
            ;;
        "delete")
            if [ ! -f "$file_path" ]; then
                log_info "File deleted successfully: $file_path"
            else
                log_error "File deletion failed: $file_path (file still exists)"
            fi
            ;;
    esac
}

log_environment() {
    log_debug "=== ENVIRONMENT ==="
    log_debug "PWD: $(pwd)"
    log_debug "USER: ${USER:-unknown}"
    log_debug "PATH: $PATH"
    log_debug "PROJECT_SESSION_ID: ${PROJECT_SESSION_ID:-not set}"
    log_debug "PROJECT_LOG_LEVEL: ${PROJECT_LOG_LEVEL:-not set}"
    log_debug "PROJECT_LOG_DIR: ${PROJECT_LOG_DIR:-not set}"
    log_debug "==================="
}

# Error handling
log_error_exit() {
    local error_message="$1"
    local exit_code="${2:-1}"
    
    log_fatal "FATAL ERROR: $error_message"
    log_fatal "Script will exit with code: $exit_code"
    
    # Log stack trace if available
    if command -v caller > /dev/null; then
        log_fatal "Call stack:"
        local frame=0
        while caller $frame; do
            frame=$((frame + 1))
        done 2>&1 | while read line; do
            log_fatal "  $line"
        done
    fi
    
    exit $exit_code
}

# Cleanup function
cleanup_logging() {
    log_info "=== Universal Script Logging Cleanup ==="
    log_info "Script completed: ${0##*/}"
    log_info "Duration: ${SECONDS}s"
    log_info "Final timestamp: $(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")"
}

# Set up cleanup trap
trap cleanup_logging EXIT

# Export functions for use in other scripts
export -f log_trace log_debug log_info log_warn log_error log_fatal
export -f log_command log_file_operation log_environment log_error_exit init_logging