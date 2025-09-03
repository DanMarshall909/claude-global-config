# Next Session Command Template

## Usage
Type `/next-session` to transition between work sessions with proper documentation and planning.

## What This Command Does
1. **Clarify Requirements**: Ask user to specify exactly what they want to accomplish next
2. **Update Progress**: Document completed work in PROGRESS.md 
3. **Clear Context**: Reset conversation context to avoid confusion
4. **Re-read Documentation**: Re-establish project understanding from CLAUDE.md and ARCHITECTURE.md
5. **Enter Plan Mode**: Create detailed implementation plan with specific tests
6. **Define Test Strategy**: List all test classes using project naming standards

## Implementation Process
When you see `/next-session`:

### Step 1: Requirements Clarification
Ask the user: "What specific feature or task do you want to work on next?" Wait for their response before proceeding.

### Step 2: Progress Documentation
Update PROGRESS.md with any recently completed work from the conversation.

### Step 3: Context Reset
Acknowledge clearing previous conversation context and re-read CLAUDE.md and ARCHITECTURE.md for project guidelines and structure.

### Step 4: Plan Mode Entry
Enter plan mode and create a detailed implementation plan that includes:

#### Required Test Classes (Project-Specific Pattern):
- List specific test classes following project naming conventions
- Define test methods using appropriate patterns
- Organize tests by architecture (VSA, layered, etc.)
- Include both unit and integration tests where appropriate

#### Implementation Steps:
- Test-first development: Write failing tests first
- Implementation phase: Implement minimal code to pass tests
- Refactoring phase: Improve code quality while keeping tests green
- Integration: Update service registration and dependencies

#### Success Criteria:
- All tests passing
- Architecture maintained
- Global tool/package updated if needed
- Documentation updated
- ARCHITECTURE.md updated if project structure changed

### Step 5: User Approval
Present the plan and wait for user approval before beginning implementation.

### Step 6: End-of-Session Architecture Update
At the end of the session, review and update ARCHITECTURE.md if:
- New components were added
- Project structure changed
- New patterns were established
- Component placement decisions were made

## Customization Notes
This template should be customized for each project:
- Replace "project naming conventions" with specific patterns (e.g., Gerund_Context for TDD projects)
- Update architecture references (VSA, layered, etc.) to match project
- Modify success criteria based on project needs
- Add project-specific documentation files to reference

This ensures clean session transitions with proper planning and test-first development following established project patterns.