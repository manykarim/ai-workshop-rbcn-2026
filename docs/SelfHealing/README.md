# Self-Healing

## Using Robot Framework Packages

### Robot Framework Self-Healing Agents

https://github.com/MarketSquare/robotframework-selfhealing-agents

#### Setup

##### Minimal Example (OpenAI)
For a quick start with the default settings and OpenAI as the provider, your `.env` file only needs:
```env
OPENAI_API_KEY="your-openai-api-key"
```
##### Custom Endpoint
If you need to use a custom endpoint (for example, for compliance or privacy reasons), add the BASE_URL variable:
```env
OPENAI_API_KEY="your-openai-api-key"
BASE_URL="your-endpoint-to-connect-to"
```

---

#### 🚀 Usage
After installing the package and adding your necessary parameters to the `.env` file, simply add the Library `SelfhealingAgents` to your test suite(s).
```robotframework
*** Settings ***
Library    Browser    timeout=5s
Library    SelfhealingAgents
Suite Setup    New Browser    browser=${BROWSER}    headless=${HEADLESS}
Test Setup    New Context    viewport={'width': 1280, 'height': 720}
Test Teardown    Close Context
Suite Teardown    Close Browser    ALL

*** Variables ***
${BROWSER}    chromium
${HEADLESS}    True

*** Test Cases ***
Login with valid credentials
    New Page    https://automationintesting.com/selenium/testpage/
    Set Browser Timeout    1s
    Fill Text    id=first_name    tom
    Fill Text    id=last_name    smith
    Select Options By    id=usergender    label    Male
    Click    id=red
    Fill Text    id=tell_me_more    More information
    Select Options By    id=user_continent    label    Africa
    Click    id=i_do_nothing
```

After running your test suite(s), you'll find a "SelfHealingReports" directory in your current working directory containing 
detailed logs and output reports. There are three types of reports generated:
1) **Action Log**: Summarizes all healing steps performed and their locations within your tests
2) **Healed Files**: Provides repaired copies of your test suite(s)
3) **Diff Files**: Shows a side-by-side comparison of the original and healed files, with differences highlighted for easy review
4) **Summary**: A json summary file for a quick overview of number of healing steps and files affected etc. 

#### Configuration
Below is an example `.env` file containing all available parameters:

```env
OPENAI_API_KEY="your-openai-api-key"
LITELLM_API_KEY="your-litellm-api-key"
AZURE_API_KEY="your-azure-api-key"
AZURE_API_VERSION="your-azure-api-version"
AZURE_ENDPOINT="your-azure-endpoint"
BASE_URL="your-base-url"

ENABLE_SELF_HEALING=True
USE_LLM_FOR_LOCATOR_GENERATION=True
MAX_RETRIES=3
REQUEST_LIMIT=5
TOTAL_TOKENS_LIMIT=6000
ORCHESTRATOR_AGENT_PROVIDER="openai"
ORCHESTRATOR_AGENT_MODEL="gpt-4o-mini"
ORCHESTRATOR_AGENT_TEMPERATURE=0.1
LOCATOR_AGENT_PROVIDER="openai"
LOCATOR_AGENT_MODEL="gpt-4o-mini"
LOCATOR_AGNET_TEMPERATURE=0.1
LOCATOR_TYPE="css"
REPORT_DIRECTORY="full-path-for-output-files"
```

## Using CLI Agents

### GitHub Copilot CLI

#### Add MCP Server

Start Github Copilot

```
copilot
```

Then add the MCP server:

```
/mcp add
```

```
Server Name:
RobotMCP

Server Type:
2 (STDIO)

Command:
uv run -m robotmcp.server

Environment Variables:
(leave empty)

Tools:
*
```

#### Using Copilot with RobotMCP

Send a single prompt to Copilot:

```
copilot -p "Use RobotMCP to create a test suite that opens https://www.saucedemo.com/ and performs login with username and password. Use Selenium Library." --allow-all
```

```
copilot -p "Check test results in output.xml, Rerun all failed tests stepwise using #RobotMCP , Fix them if root cause are locator failures“  --allow-all-tools
```
