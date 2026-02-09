# rf-mcp Overview

[rf-mcp](https://github.com/manykarim/rf-mcp) is an MCP Server for Robot Framework.
It is implemented via [FastMCP](https://gofastmcp.com) and can be connected to various AI Agents, such as GitHub Copilot, Claude Code, OpenCode, Goose and others.

## Purpose

rf-mcp bridges the gap between natural language and Robot Framework automation. Instead of generating simulated code, it **executes actual Robot Framework keywords in real-time**, enabling AI agents to:

- Understand test intentions from human language
- Execute automation steps interactively with immediate feedback
- Generate production-ready test suites from successful executions

This creates a conversational test development experience where you describe what you want to test, and the AI agent executes and validates each step before building the final test suite.

## Key Features

### Natural Language Processing
Convert human test descriptions into structured automation actions with intelligent scenario analysis and context-aware test planning (web, mobile, API, database).

### Interactive Step Execution
Execute Robot Framework keywords step-by-step with real-time state tracking and session management. The native RF context runner ensures correct argument parsing and type conversion.

### Intelligent Element Location
Advanced locator guidance for Browser Library, SeleniumLibrary, and AppiumLibrary with cross-library locator conversion and DOM filtering.

### Production-Ready Suite Generation
Generate optimized Robot Framework test suites with proper imports, setup/teardown, documentation, tags, and variables from validated execution steps.

### Multi-Platform Support
- **Web**: Browser Library (Playwright) & SeleniumLibrary
- **Mobile**: AppiumLibrary for iOS/Android testing
- **API**: RequestsLibrary for HTTP/REST testing
- **Database**: DatabaseLibrary for SQL operations

### Debug Attach Bridge
Drive rf-mcp tools against a live Robot Framework debug session via the `McpAttach` library, reusing in-process variables, imports, and keyword search order.

## MCP Tools

rf-mcp provides a comprehensive toolset organized by function:

| Category | Tools | Description |
|----------|-------|-------------|
| **Planning** | `analyze_scenario`, `recommend_libraries` | Convert natural language to test intent, suggest libraries |
| **Session** | `manage_session`, `execute_step`, `execute_flow` | Initialize sessions, execute keywords, build control structures |
| **Discovery** | `find_keywords`, `get_keyword_info` | Keyword discovery and documentation retrieval |
| **Observability** | `get_session_state`, `check_library_availability` | Session insight, library verification |
| **Suite Lifecycle** | `build_test_suite`, `run_test_suite` | Generate and execute test files |
| **Locators** | `get_locator_guidance` | Browser/Selenium/Appium selector guidance |
| **Debug Bridge** | `manage_attach` | Inspect or control the attach bridge |

## Architecture

rf-mcp follows a service-oriented design with these core components:

```
📦 ExecutionCoordinator (Main Orchestrator)
├── 🔤 SessionManager         - Session lifecycle & library management
├── ⚙️ KeywordExecutor        - RF keyword execution engine
├── 🌐 BrowserLibraryManager  - Browser/Selenium library switching
├── 📊 PageSourceService      - DOM extraction & filtering
├── 🔄 LocatorConverter       - Cross-library locator translation
└── 📋 SuiteExecutionService  - Test suite generation & execution
```

### Native Robot Framework Integration

- **ArgumentResolver** - Native RF argument parsing
- **TypeConverter** - RF type conversion (string → int/bool/etc.)
- **LibDoc API** - Direct RF documentation access
- **Keyword Discovery** - Runtime detection using RF internals
- **Runner First** - Execute via `Namespace.get_runner(...).run(...)`, fallback to `BuiltIn.run_keyword`

### Session Management

Each session maintains a persistent Robot Framework `Namespace` and `ExecutionContext`, enabling:

- Auto-configuration based on scenario analysis
- Browser library conflict resolution (Browser vs Selenium)
- Cross-session state persistence
- Variables and imports that persist within the session

## Use Cases

### Full Scenario Automation
Describe a complete end-to-end scenario in natural language, and the AI agent creates a full Robot Framework test suite.

```
"Use #robotmcp to create a test for saucedemo.com that logs in, adds two items to cart, 
completes checkout, and verifies the success message.  
Execute it stepwise and build final test suite at the end"
```

The agent analyzes the scenario, executes each step to validate it works, and generates a production-ready test file with proper structure, keywords, and documentation.

### Stepwise Interactive Test Creation
Build tests incrementally through conversation. Describe one or multiple steps in human language, rf-mcp executes them immediately, and the session stays active for continued development.

```
Human: "Use #robotmcp to open the browser and navigate to saucedemo.com"
Agent: [executes step, shows result]
Human: "Now fill in the username field with 'standard_user'"
Agent: [executes step, shows result]
Human: "Generate the test file from what we've done so far"
```

Ideal for exploratory testing, learning new applications, or when you're unsure of the exact flow.

### Test Refactoring
Use an existing test case as input and refactor it for better maintainability:

- **Keyword-Driven**: Extract repeated actions into reusable keywords
- **Page Object Pattern**: Organize locators and actions by page/component
- **Data-Driven**: Parameterize tests for multiple data sets (to be implemented)
- **BDD Style**: Convert to Given/When/Then structure (to be implemented)

```
"Use #robotmcp to refactor this test to use a page object pattern with separate keywords 
for LoginPage, InventoryPage, and CheckoutPage.  
Execute it stepwise and build final test suite at the end"
```

### Recording-Based Test Creation
Paste browser recordings (from Chrome DevTools Recorder, Playwright Codegen, or similar tools) into the conversation. rf-mcp converts the recording into proper Robot Framework syntax.

```
Human: [pastes Chrome DevTools recording JSON]
"Use #robotmcp to convert this recording to a Robot Framework test using Browser Library"
```

The agent parses the recording, maps actions to RF keywords, and creates a clean test file.

### Library Migration
Migrate existing tests between libraries while preserving functionality:

- SeleniumLibrary → Browser Library
- Requests → Browser Library API testing
- Custom libraries → Standard libraries

```
"Use #robotmcp to convert this SeleniumLibrary test to use Browser Library instead"
```

The agent handles locator syntax differences, keyword mappings, and library-specific patterns.

### Test Debugging & Fixing
When tests fail, use rf-mcp to diagnose and fix issues interactively:

```
Human: "Use #robotmcp to execute this test and fix any errors"
Agent: [executes steps up to failure point]
Agent: [inspects page state, suggests fix]
Agent: "The button locator changed. Here's the updated test..."
```

### API Test Generation from Specifications
Provide an OpenAPI/Swagger specification or API documentation URL, and generate comprehensive API test suites:

```
"Use #robotmcp to generate Robot Framework API tests for the Restful Booker API 
based on their documentation at https://restful-booker.herokuapp.com"
```

### Learning & Exploration
Use rf-mcp as an interactive learning tool for Robot Framework:

```
Human: "How do I handle dynamic waits in Browser Library?"
Agent: [explains and demonstrates with live execution]
Human: "Show me how to verify an element's CSS properties"
Agent: [executes example, shows syntax and result]
```

### Test Maintenance & Self-Healing
When UI changes break existing tests, rf-mcp can help identify and update broken locators:

```
"The login page UI was updated. Use #robotmcp to execute the test, find new locators and update the test"
```

The agent uses `get_session_state` to inspect the current DOM and suggests updated locators.

## Typical Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│  1. ANALYZE       →   analyze_scenario                          │
│     "Test login flow on saucedemo.com"                          │
├─────────────────────────────────────────────────────────────────┤
│  2. SETUP         →   manage_session, recommend_libraries       │
│     Initialize session, import required libraries               │
├─────────────────────────────────────────────────────────────────┤
│  3. EXECUTE       →   execute_step (iterative)                  │
│     Run keywords one by one with real-time feedback             │
├─────────────────────────────────────────────────────────────────┤
│  4. VALIDATE      →   get_session_state                         │
│     Verify session state and executed steps                     │
├─────────────────────────────────────────────────────────────────┤
│  5. GENERATE      →   build_test_suite                          │
│     Create production-ready .robot file from successful steps   │
├─────────────────────────────────────────────────────────────────┤
│  6. RUN           →   run_test_suite                            │
│     Validate (dry) or execute (full) the generated suite        │
└─────────────────────────────────────────────────────────────────┘
```

## Supported AI Agents

rf-mcp works with any MCP-compatible AI agent:

- GitHub Copilot (VS Code)
- Claude Code
- Claude Desktop
- Goose CLI
- OpenCode
- Any other MCP-compatible client

## Installation

```bash
# Core installation
pip install rf-mcp

# With web testing support
pip install rf-mcp[web]

# With all optional libraries
pip install rf-mcp[all]
```

Using uv (recommended)

```bash
uv add rf-mcp[all]
uv sync

# Or when using uv as pip replacement

uv venv
uv pip install rf-mcp[all]
```

## Resources

- **Repository**: https://github.com/manykarim/rf-mcp
- **PyPI**: https://pypi.org/project/rf-mcp/
- **FastMCP**: https://gofastmcp.com
- **Robot Framework**: https://robotframework.org
