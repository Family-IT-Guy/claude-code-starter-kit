# Context Gathering Workflow

Execute these steps in order. Announce each step before executing it.

## Step 1: Project Discovery
- Check if current directory has project files (package.json, .git, Cargo.toml, etc.)
- If no project detected, ask user for project boundaries
- List project structure to understand scope

## Step 2: Source Code Mapping
- Do `find` command to see all source code files in the project
- Filter out build artifact directories (node_modules, target, dist, build, .git)
- Focus on core source files only

## Step 3: Identify Relevant Files
- Based on the target topic, identify filenames likely to be related
- Don't read them yet, just list the candidates
- Consider imports, exports, and naming patterns

## Step 4: Find Definitions with ripgrep
Use `ripgrep` to find type/function/module definitions:

**For Rust:**
```bash
rg "(use|struct|enum|fn|mod|impl|trait|const|static)\s+" --type rust
```

**For JavaScript/TypeScript:**
```bash
rg "(class|function|const|export|interface|type|import)\s+" --type js --type ts
```

**For Python:**
```bash
rg "(class|def|import|from)\s+" --type py
```

**For other languages:**
- Adapt pattern to find major constructs

## Step 5: Read Relevant Context
- Read context around relevant definitions found in step 4
- Start with files most likely related to the topic
- Read entire functions/classes, not just snippets

## Step 6: Expand Context Window
- Keep expanding context around initial findings
- Follow imports and dependencies
- Read related utility functions and helpers

## Step 7: External Dependencies
- For unknown libraries or frameworks, look up official documentation
- Use Context7 for well-known library documentation

## Step 8: Iterative Deepening
- Loop back to step 2 with better understanding of the topic
- Repeat process with refined search terms
- Continue until confident you have comprehensive context

## Step 9: Context Storage
- **Project Root Confirmation Required**:
  - Current directory: $(pwd)
  - Git root (if available): $(git rev-parse --show-toplevel 2>/dev/null || echo "No git repository")
  - **STOP**: Confirm project root for .claude/ storage
  - **WAIT**: For explicit user confirmation of project root
- Create comprehensive codebase context guide in $PROJECT_ROOT/.claude/guides/
- Include code snippets, function names, key concepts, architecture patterns
- Format for someone new to the project
- Create directory if it doesn't exist

## Step 10: Verification
- Verify understanding by explaining key relationships
- Identify any gaps or unclear areas
- Note areas that may need further investigation
