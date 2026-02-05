# AI Workshop

Date: 10-Feb-2026
Start: 09:00
End: 16:00


## Agenda

09:00 - 09:30  |  Introduction and Icebreaker
09:30 - 10:00  |  GH Copilot, Extensions and MCP Server Setup 
10:00 - 12:30  |  RF-MCP Basics and Interactive Development
12:30 - 13:30  |  Lunch Break
13:30 - 15:30  |  Robot AI Agent and RobotCode
15:30 - 16:00  |  AI Hype and Reality Discussion
16:00          |  Closing Remarks and Next Steps

### Attention
This is a rough timetable and most likely not everything will fit in the given time slots.  
But we will add notes/links for the remaining topics after the workshop for self-study.  
And we are available for questions after the workshop.

## Preparation

### Participants  
- GitHub Account
- AI Agent  (e.g. GitHub Copilot Free)
- VS Code
- RobotCode
- GitHub Copilot (Extension)
- uv

### Organizers  
- Open Router Account & API Key
    -  Models: Devstral
- OpenAI API Key

## Icebreaker/Opening

- Your experience with AI in Testing
- Your expectations for the workshop
- Your experience with Robot Framework

## GH Copilot, Extensions and MCP Server Setup (Daniel)

- Plan/Edit/Agent Mode
- Add MCP Server
- Tools in Copilot
- Add OpenRouter API Key to Agent
- Try out simple prompts with AI Agent

## A good start with uv (Daniel)

- Install uv
- uv init --
- uv add robotframework-browser robotframework-requests
- uv run rfbrowser init

Use `uv run` to run commands in the uv environment

## Covered Tools and Libraries

### AI Agent with Playwright MCP and ChromeDevTools (Daniel)

Describing scenario in natural language and run it in the browser using Playwright MCP and Chrome DevTools MCP.

### RF-MCP  (Many)

Generate Robot Framework Tests from Naturual Language  
https://github.com/manykarim/rf-mcp

- RF-MCP Overview (15 min)
- Installation and Setup in AI Agent (10 min)
- Automate full scenarios in single prompt (30 min)
  - Web
  - API
  - XML/BuiltIn
- Task: Single Prompt Automation (15 min)
- Prompts (automate/learn) (5 min)
- Interactive test development (10 min)
- Using recordings as prompt basis (5 min)
- Test Refactoring and user keyword usage (20 min)
- Task: Interactive Development plus Refactoring (15 min)
- Detailed MCP Tool walkthrough (15 min)
- MCP Frontend (5  min)
- RF-MCP Debug Bridge (5 min)

----

### RF-MCP Advanced Features (Many)

- Plugin System (10 min)
- Agent Skills and Slash commands to improve MCP and Robot Framework usage (15 min)
- RF-MCP AI Library and Recorder (10 min)
- Q&A and discussion (10 min)

----

### SelfHealing-Agents  (Many)

Repair locator failures during runtime and generate report
https://github.com/MarketSquare/robotframework-selfhealing-agents

- Self-Healing-Agents overview (5 minutes)
- Installation and Setup (10 minutes)
- Running examples for self-healing
- Self-Healing report
- Task: Heal broken tests of sample app
- Alternative: Using RF-MCP for Self-Healing

----

### DocTest Ai  

AI support for visual difference detection, OCR and document chat
https://github.com/manykarim/robotframework-doctestlibrary

----

### RobotAiAgent  (Daniel)

Use LLM Chat and Tools during Robot Framework Test Run
https://github.com/d-biehl/robotframework-aiagent

- Using Chat Keyword
- Output Types
- Tool usage
- MCP Server usage (with Playwright)
- Test Data Generation
- Non-Deterministic Testing

----

### RobotCode  (Daniel)

Use Tools to  
- read Library Documentation
- get infromation about imported Libraries

### General (Daniel & Many)

- GH Copilot Usage, Tools, Slash Commands
- Agent Skills
- Custom Agents
- Local LLM usage

### AI hype and reality (Daniel & Many)

- Drifting focus of AI Agent 

Possible Solutions:
- Agents.md
- Agent Skills
- Custom Agents

## Example Apps

- https://demoshop.makrocode.de/  
- https://carconfig.makrocode.de/
- https://www.saucedemo.com/
- https://restful-booker.herokuapp.com/apidoc/index.html