# Debug Bridge

RobotMCP ships with `robotmcp.attach.McpAttach`, a lightweight Robot Framework library that exposes the live `ExecutionContext` over a localhost HTTP bridge. When you debug a suite from VS Code (RobotCode) or another IDE, the bridge lets RobotMCP reuse the in-process variables, imports, and keyword search order instead of creating a separate context.

## Usage

```json
{
  "servers": {
    "RobotMCP": {
      "type": "stdio",
      "command": "uv",
      "args": ["run", "src/robotmcp/server.py"],
      "env": {
        "ROBOTMCP_ATTACH_HOST": "127.0.0.1",
        "ROBOTMCP_ATTACH_PORT": "7317",
        "ROBOTMCP_ATTACH_TOKEN": "change-me",
        "ROBOTMCP_ATTACH_DEFAULT": "auto"
      }
    }
  }
}
```

## Example

```robotframework
*** Settings ***
Library    robotmcp.attach.McpAttach    token=${DEBUG_TOKEN}
Library         Browser

*** Variables ***
${DEBUG_TOKEN}    change-me

*** Test Cases ***
SauceDemo E2E Test
    New Browser    browser=chromium    headless=True
    New Context
    New Page    https://www.saucedemo.com/
    Fill Text    id=user-name    standard_user
    Fill Text    id=password    secret_sauce
    Click    id=login-button    # Click on id=login-button
    MCP Serve    port=7317    token=${DEBUG_TOKEN}    mode=blocking
    Log    Step after Debug Bridge Keyword
```

- `MCP Serve    port=7317    token=${TOKEN}    mode=blocking|step    poll_ms=100` — starts the HTTP server (if not running) and processes bridge commands. Use `mode=step` during keyword body execution to process exactly one queued request.
- `MCP Stop` — signals the serve loop to exit (used from the suite or remotely via RobotMCP `attach_stop_bridge`).
- `MCP Process Once` — processes a single pending request and returns immediately; useful when the suite polls between test actions.
- `MCP Start` — alias for `MCP Serve` for backwards compatibility.

User can interact with live session:

```
"Return the css locators of all products on the screen"
```

```
"Add a product to the shopping cart"
```

```
"What are the current variables?"
```

```
"Stop the Debug Bridge"
```
