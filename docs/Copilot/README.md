# GitHub Copilot in VS Code

https://code.visualstudio.com/docs/copilot/overview

## Pricing / Access

### Individual Plans

| | **Free** | **Pro** | **Pro+** |
|---|---|---|---|
| **Price** | $0 | $10/month ($100/year) | $39/month ($390/year) |
| **Code completions** | 2,000/month | Unlimited | Unlimited |
| **Chat messages** | 50/month | Unlimited (included models) | Unlimited (included models) |
| **Premium requests** | 50/month | 300/month | 1,500/month |
| **Additional premium requests** | — | $0.04 each | $0.04 each |
| **Coding Agent** | — | Yes | Yes |
| **Code Review** | Selection only | Yes | Yes |
| **Models** | Claude Haiku 4.5, GPT-4.1, GPT-5 mini | + Claude Opus 4.5/4.6, Sonnet 4/4.5, Gemini 2.5 Pro, GPT-5, and more | Full access to all models incl. Claude Opus 4.1 |
| **GitHub Spark** | — | — | Yes |

- **Pro** is free for verified students, teachers, and maintainers of popular open-source projects
- Pro+ includes 5x premium requests vs Pro

### Business Plans

| | **Business** | **Enterprise** |
|---|---|---|
| **Price** | $19/user/month | $39/user/month |
| **Premium requests** | 300/user/month | 1,000/user/month |
| **Coding Agent** | Yes | Yes |
| **Org policy management** | Yes | Yes |
| **Org custom instructions** | Yes | Yes |
| **File exclusion** | Yes | Yes |
| **Audit logs** | Yes | Yes |
| **Third-party agents** | — | Yes (preview) |

- Additional premium requests: $0.04 each
- Enterprise requires GitHub Enterprise Cloud

### Model Multipliers (Premium Request Cost)

Each model has a multiplier that determines how many premium requests one interaction costs.
- **Paid plans**: Included models (GPT-5 mini, GPT-4.1, GPT-4o) cost **0** premium requests (unlimited)
- **Free plan**: Every model costs **1** premium request per interaction (no multiplier, no free models)
- **Auto model selection** in VS Code gives a 10% discount on the multiplier (paid plans only)

| Model | Multiplier (Paid) | Free |
|---|---|---|
| GPT-5 mini | 0 (included) | 1 |
| GPT-4.1 | 0 (included) | 1 |
| GPT-4o | 0 (included) | 1 |
| Raptor mini | 0 (included) | 1 |
| Grok Code Fast 1 | 0.25x | — |
| Claude Haiku 4.5 | 0.33x | 1 |
| Gemini 3 Flash | 0.33x | — |
| GPT-5.1-Codex-Mini | 0.33x | — |
| Claude Sonnet 4 | 1x | — |
| Claude Sonnet 4.5 | 1x | — |
| Gemini 2.5 Pro | 1x | — |
| Gemini 3 Pro | 1x | — |
| GPT-5 | 1x | — |
| GPT-5-Codex | 1x | — |
| GPT-5.1 | 1x | — |
| GPT-5.1-Codex | 1x | — |
| GPT-5.1-Codex-Max | 1x | — |
| GPT-5.2 | 1x | — |
| GPT-5.2-Codex | 1x | — |
| Claude Opus 4.5 | 3x | — |
| Claude Opus 4.6 | 3x | — |
| Claude Opus 4.6 (fast mode, preview) | 9x (promo) | — |
| Claude Opus 4.1 | 10x (Pro+ only) | — |

- [Premium requests docs](https://docs.github.com/en/copilot/managing-copilot/monitoring-usage-and-entitlements/about-premium-requests)

### Links

- [Plan comparison](https://docs.github.com/en/copilot/about-github-copilot/subscription-plans-for-github-copilot)
- [Pricing page](https://github.com/features/copilot/plans)
- [Individual plans details](https://docs.github.com/en/copilot/managing-copilot/managing-copilot-as-an-individual-subscriber/managing-copilot-free/about-github-copilot-free)

## Core Features

### Inline Suggestions
- Code completions while typing (ghost text)
- Single-line up to entire functions
- **Next Edit Suggestions (NES)** — predicts the next logical code change
- Accept with `Tab`
- Docs: [AI-powered suggestions](https://code.visualstudio.com/docs/copilot/ai-powered-suggestions)

### Chat (Ctrl+Alt+I)
- Natural language questions about your code
- Multi-turn conversations
- Three access modes: **Chat View**, **Inline Chat** (`Ctrl+I`), **Quick Chat** (`Ctrl+Shift+Alt+L`)
- `code chat` command from the CLI
- Docs: [Chat in VS Code](https://code.visualstudio.com/docs/copilot/chat/copilot-chat) | [Chat context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context)

### Agents (Agent Mode)
- Autonomous planning & execution of complex tasks
- Multi-step workflows incl. terminal commands
- Creates/modifies files, installs dependencies
- **Built-in Agents**: Agent, Plan, Ask
- **Custom Agents** defined as `.md` files (own tools, instructions, model)
- Agents orchestrated as **Subagents**
- Docs: [Agent mode](https://code.visualstudio.com/docs/copilot/chat/copilot-chat) | [Agents tutorial](https://code.visualstudio.com/docs/copilot/agents/agents-tutorial) | [Subagents](https://code.visualstudio.com/docs/copilot/agents/subagents) | [Coding agent (GitHub)](https://docs.github.com/en/copilot/using-github-copilot/coding-agent)

### Smart Actions (no prompt needed)
- Generate commit messages
- Generate PR title/description
- Explain / fix / review code
- Generate tests
- Generate docs
- Rename symbols (AI-powered suggestions)
- Fix terminal errors
- Fix test failures (from Test Explorer)
- Resolve merge conflicts with AI (experimental)
- Implement TODO comments via Coding Agent
- Semantic search in Search View
- Search settings with AI
- Generate alt text for Markdown images
- Docs: [Smart actions](https://code.visualstudio.com/docs/copilot/copilot-smart-actions)

## Customization

### Custom Instructions
- `.github/copilot-instructions.md` — always-on, applied to every session
- `*.instructions.md` — file-based, matched by glob pattern or description
- Coding standards, architecture, tech preferences
- Docs: [Custom instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions)

### Prompt Files (Slash Commands)
- Reusable prompt templates as `.md` files
- Invoked via `/` in chat
- Shareable across the team
- Docs: [Prompt files](https://code.visualstudio.com/docs/copilot/customization/prompt-files)

### Repository Instruction Files

GitHub Copilot supports several types of instruction files in your repository:

#### `.github/copilot-instructions.md` (Repository-wide)
- Always-on, automatically applied to every Copilot interaction (Chat, Code Review, Coding Agent)
- Natural language, Markdown format
- Can be auto-generated by the Coding Agent

#### `*.instructions.md` (Path-specific, in `.github/instructions/`)
- Scoped to specific files via `applyTo` glob pattern in frontmatter
- Optional `excludeAgent` to limit to Coding Agent or Code Review only

#### `AGENTS.md` (Agent Instructions)
- Open standard initiated by OpenAI ([openai/agents.md](https://github.com/openai/agents.md))
- One or more `AGENTS.md` files, stored anywhere in the repo
- Nearest file in directory tree takes precedence
- Used by the **Copilot Coding Agent** (cloud-based, GitHub Actions)
- Alternatives: `CLAUDE.md` or `GEMINI.md` in repo root also supported

#### Important distinction
- **Coding Agent** = cloud-based, runs in GitHub Actions, creates PRs autonomously
- **Agent Mode** = local in VS Code, edits files in your workspace
- **Custom Agents** (VS Code) = local `.md` files defining agent personas with custom tools/instructions/model

- Docs: [Custom instructions](https://code.visualstudio.com/docs/copilot/customization/custom-instructions) | [Repository instructions (GitHub)](https://docs.github.com/en/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot) | [About coding agent](https://docs.github.com/en/copilot/using-github-copilot/coding-agent/about-assigning-tasks-to-copilot) | [Custom agents (VS Code)](https://code.visualstudio.com/docs/copilot/customization/custom-agents)

### Agent Skills
- Folders containing instructions, scripts, and resources
- Loaded on-demand
- Open standard (agentskills.io), works across CLI + VS Code + Coding Agent
- Docs: [Agent Skills](https://code.visualstudio.com/docs/copilot/customization/agent-skills) | [agentskills.io](https://agentskills.io/)


### Language Models
- Model picker in chat
- Fast models for simple tasks, reasoning models for complex ones
- Bring Your Own Key (custom providers, local models)
- Available models depend on subscription plan
- Docs: [Language models](https://code.visualstudio.com/docs/copilot/customization/language-models)

### MCP Server & Tools
- Model Context Protocol — connect external services
- Databases, APIs, specialized tools
- JSON configuration or programmatic via extensions
- MCP Apps for UI (dashboards, forms)
- Docs: [MCP servers in VS Code](https://code.visualstudio.com/docs/copilot/customization/mcp-servers)

## Providing Context

- `#`-mentions: `#file`, `#codebase`, `#terminalSelection`, `#searchResults`
- `#`-tools: e.g. `#fetch` (web pages), `#githubRepo` (GitHub search)
- Drag & drop files into chat
- Copilot Spaces for shared context
- Docs: [Chat context](https://code.visualstudio.com/docs/copilot/chat/copilot-chat-context) | [Chat tools](https://code.visualstudio.com/docs/copilot/chat/chat-tools) | [Copilot Spaces](https://docs.github.com/en/copilot/using-github-copilot/copilot-spaces/about-organizing-and-sharing-context-with-copilot-spaces)

## Best Practices

- Choose the right tool for the task (Inline vs Chat vs Agent)
- Write specific prompts with context
- Use custom instructions for team conventions
- Pick the model based on task complexity
- Diagnostics view for troubleshooting (right-click in Chat > Diagnostics)
- Docs: [Tips & tricks](https://code.visualstudio.com/docs/copilot/copilot-tips-and-tricks) | [Prompt examples](https://code.visualstudio.com/docs/copilot/chat/prompt-examples) | [Troubleshooting](https://code.visualstudio.com/docs/copilot/troubleshooting)

## Links

- [VS Code Copilot Docs](https://code.visualstudio.com/docs/copilot/overview)
- [GitHub Copilot Docs](https://docs.github.com/en/copilot)
- [Customization Overview](https://code.visualstudio.com/docs/copilot/customization/overview)
- [Tips & Tricks](https://code.visualstudio.com/docs/copilot/copilot-tips-and-tricks)
- [Trust Center / Privacy](https://copilot.github.trust.page/)