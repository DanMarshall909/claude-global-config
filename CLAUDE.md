- 1. Test-First Service Design: Design services with testability from day one
  2. Complete Test Doubles: Implement full interfaces, not minimal stubs
  3. Framework Compliance: Follow framework-specific patterns (xUnit async rules)
  4. Resource Isolation: Each test gets isolated, disposable resources
  5. Unified Infrastructure: One test infrastructure pattern across solution
  6. Mock External Dependencies: Never make real network calls in unit tests
  7. Behavior-Focused Naming: Test names describe business outcomes
  8. Analyzer Compliance: Enable and fix all framework analyzer warnings
- You MUST use TDD to complete any code changes. All tests must pass before a task is compelte
- if tests don't align with the system then make the system work as the tests say rather than modifying the tests
- always ensure that no tests are broken after completing a task
- **TODO TRACKING RULE**: You MUST use the TodoWrite tool to track progress on any complex or multi-step tasks. Always create todos for tasks that have multiple steps, require planning, or would benefit from progress tracking. Clean up stale todos that no longer match current work.
- **ARCHITECTURE RULE**: Always reference ARCHITECTURE.md for project structure guidance. This file defines where components belong in the codebase. At the end of each session, update ARCHITECTURE.md if the project structure has changed or new patterns have been established.
- **TOKEN EFFICIENCY RULE**: Keep all .claude files (commands, hooks, context files) concise and token-efficient. Use bullet points, avoid verbose explanations, focus on essential information only. Example: Use "Update PROGRESS.md with completed work" not "Please update the PROGRESS.md file with a comprehensive summary of all the work that has been completed during this session".
- **TEST OUTPUT EFFICIENCY RULE**: When running tests, write output to temporary file in .claude folder, then parse only essential information. Use `dotnet test 2>&1 > .claude/temp/test-output.txt` then extract summary (passed/failed counts, execution time) with grep/awk. Avoid displaying full test output which wastes tokens. Focus on: test counts, failure details if any, performance metrics only.
- **CLAUDE FOLDER CONVENTIONS**: Use `.claude/temp/` for temporary output files (test results, build logs, etc.). Create directory with `mkdir -p .claude/temp` before use. This keeps temp files organized and easily accessible for debugging while avoiding token waste in chat.
- **LOGGING STANDARDS RULE**: All project scripts MUST use centralized logging with structured levels (TRACE, DEBUG, INFO, WARN, ERROR, FATAL), dual output (console + files) with session correlation, environment tracking and robust error handling. Use templates/scripts/logger.sh pattern with project-specific configuration.
- **SCRIPT ROBUSTNESS RULE**: All bash scripts MUST include error handling (`set -euo pipefail`), metadata capture (git state, environment, timing), JSON format for structured data exchange, and session correlation via environment variables. Follow proven patterns from templates/scripts/.
- **DOCUMENTATION STANDARDS RULE**: Create `.claude/agents/[project]-quick-reference.md` for CLI tools with example-driven documentation, troubleshooting sections, environment variables documentation, and token-efficient structure. Use templates/agents/quick-reference.md as starting point.
- **TEMP FILE ORGANIZATION RULE**: Expand `.claude/temp/` usage for ALL verbose command outputs (build-output.txt, lint-results.txt, coverage-output.txt, etc.). Parse and extract only essential information for chat. Always create directory with `mkdir -p .claude/temp` before use. This saves significant tokens while preserving full output for debugging.