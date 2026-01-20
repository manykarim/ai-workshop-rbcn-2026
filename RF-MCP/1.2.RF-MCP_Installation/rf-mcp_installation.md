# rf-mcp Installation

## Prerequisites

- Python 3.10+
- Robot Framework 6.0+

## Basic Installation

```bash
pip install rf-mcp
```

This installs the core rf-mcp package with minimal dependencies.

## Installation Extras

rf-mcp provides optional extras that install the necessary Robot Framework libraries for specific testing domains:

| Extra | Command | Included Libraries |
|-------|---------|-------------------|
| **slim** | `pip install rf-mcp[slim]` | Core package only (same as basic install) |
| **web** | `pip install rf-mcp[web]` | Browser Library (Playwright) + SeleniumLibrary |
| **mobile** | `pip install rf-mcp[mobile]` | AppiumLibrary |
| **api** | `pip install rf-mcp[api]` | RequestsLibrary |
| **database** | `pip install rf-mcp[database]` | DatabaseLibrary |
| **frontend** | `pip install rf-mcp[frontend]` | Django-based web frontend dashboard |
| **all** | `pip install rf-mcp[all]` | All optional Robot Framework libraries |

### Combining Extras

You can combine multiple extras in a single install:

```bash
pip install rf-mcp[web,api]
```

## Post-Installation Setup

### Browser Library (Playwright)

After installing with the `web` extra, you need to initialize Playwright browsers:

```bash
rfbrowser init
```

or alternatively:

```bash
python -m Browser.entry install
```

### Frontend Dashboard

When using the `frontend` extra, start the MCP server with the dashboard enabled:

```bash
python -m robotmcp.server --with-frontend
```

The dashboard is available at http://127.0.0.1:8001/ by default.

## Virtual Environment Recommendation

If you're using a virtual environment (recommended), install rf-mcp within the same venv and ensure you use the Python executable from that venv when starting the server:

```bash
# Create and activate venv
python -m venv .venv
source .venv/bin/activate  # Linux/macOS
# or
.venv\Scripts\activate     # Windows

# Install rf-mcp
pip install rf-mcp[web]

# Start server using venv Python
python -m robotmcp.server
```

## Development Installation

For contributing or development:

```bash
git clone https://github.com/manykarim/rf-mcp.git
cd rf-mcp

# Using uv (recommended)
uv sync --all-extras --dev

# Or using pip
pip install -e ".[all]"
```

## MCP Client Configuration

After installation, configure your AI agent to connect to rf-mcp as an MCP server.

### Claude Code (CLI)

Add rf-mcp using the Claude Code CLI:

```bash
claude mcp add robotmcp -- python -m robotmcp.server
```

Or with uv:

```bash
claude mcp add robotmcp -- uv run python -m robotmcp.server
```

### GitHub Copilot (VS Code)

Create or edit `.vscode/mcp.json` in your workspace:

```json
{
  "servers": {
    "robotmcp": {
      "type": "stdio",
      "command": "python",
      "args": ["-m", "robotmcp.server"]
    }
  }
}
```

With uv:

```json
{
  "servers": {
    "robotmcp": {
      "type": "stdio",
      "command": "uv",
      "args": ["run", "python", "-m", "robotmcp.server"]
    }
  }
}
```

### Claude Desktop

Edit the configuration file:
- **macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows**: `%APPDATA%\Claude\claude_desktop_config.json`

```json
{
  "mcpServers": {
    "robotmcp": {
      "command": "python",
      "args": ["-m", "robotmcp.server"]
    }
  }
}
```

### Cline (VS Code Extension)

Open Cline settings and add to the MCP Servers configuration:

```json
{
  "mcpServers": {
    "robotmcp": {
      "command": "python",
      "args": ["-m", "robotmcp.server"]
    }
  }
}
```

### Goose CLI

Create or edit `~/.config/goose/config.yaml`:

```yaml
extensions:
  robotmcp:
    type: stdio
    enabled: true
    cmd: python
    args:
      - -m
      - robotmcp.server
```

### Cursor

Create or edit `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "robotmcp": {
      "command": "python",
      "args": ["-m", "robotmcp.server"]
    }
  }
}
```

### Windsurf

Create or edit `~/.codeium/windsurf/mcp_config.json`:

```json
{
  "mcpServers": {
    "robotmcp": {
      "command": "python",
      "args": ["-m", "robotmcp.server"]
    }
  }
}
```

### Using a Virtual Environment

When using a virtual environment, specify the full path to the Python executable:

```json
{
  "servers": {
    "robotmcp": {
      "type": "stdio",
      "command": "/path/to/your/venv/bin/python",
      "args": ["-m", "robotmcp.server"]
    }
  }
}
```

On Windows:

```json
{
  "servers": {
    "robotmcp": {
      "type": "stdio",
      "command": "C:\\path\\to\\your\\venv\\Scripts\\python.exe",
      "args": ["-m", "robotmcp.server"]
    }
  }
}
```

### Verifying the Connection

After configuration, restart your AI agent and verify that rf-mcp is connected. Most clients will show available MCP tools in their interface. You can test by asking:

```
"List the available RobotMCP tools"
```

## Resources

- **Repository**: https://github.com/manykarim/rf-mcp
- **PyPI**: https://pypi.org/project/rf-mcp/
