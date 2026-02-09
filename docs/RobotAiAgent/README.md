# Robot Framework AI Agent

## Overview

- A Robot Framework library that brings Large Language Models (LLMs) directly into `.robot` test suites
- Built on top of [pydantic-ai](https://ai.pydantic.dev/) for provider-agnostic LLM access
- Small API surface: one core keyword (`Chat`) plus history helpers
- Per-test conversation isolation — no cross-test leakage
- Repo: https://github.com/d-biehl/robotframework-aiagent
- Workshop examples: https://github.com/d-biehl/AIWorkshop

---

## Why Use This?

- **Provider-agnostic** — OpenAI, Anthropic, Google Gemini, Vertex AI, Mistral, Groq, Cohere, Bedrock, Hugging Face
- **Structured outputs** — return strongly-typed results (dataclasses, TypedDicts, Pydantic models) instead of plain strings
- **Message history** — consecutive `Chat` calls continue the conversation within a test by default
- **Per-call overrides** — switch models, settings, or output types for a single step without re-importing
- **Multiple agents** — import the library under different aliases to create multi-agent scenarios
- **Tools & MCP** — let agents call Python functions, toolsets, or MCP-exposed services

---

## Installation

### Meta Package (all providers)

```bash
pip install robotframework-aiagent
```

### Slim Package (pick only the providers you need)

```bash
pip install robotframework-aiagent-slim[openai]
pip install robotframework-aiagent-slim[openai,anthropic,mcp]
```

### Requirements

- Python >= 3.10
- Robot Framework >= 7.0

---

## Provider Credentials

Set the appropriate environment variable for your provider:

| Provider | Environment Variable |
|---|---|
| OpenAI | `OPENAI_API_KEY` |
| Anthropic | `ANTHROPIC_API_KEY` |
| Google Gemini | `GEMINI_API_KEY` |
| Mistral | `MISTRAL_API_KEY` |
| Groq | `GROQ_API_KEY` |
| Cohere | `CO_API_KEY` |
| Hugging Face | `HF_TOKEN` |
| GitHub Models | `GITHUB_TOKEN` |

Alternatively, credentials can be configured in a `.robot.toml` file in the project root.

---

## Core Keywords

| Keyword | Description |
|---|---|
| `Chat` | Send a prompt to the LLM; returns string or structured output |
| `Get Message History` | Retrieve conversation history (`content=FULL\|NEWEST`, `format=RAW\|JSON`) |
| `Clear Message History` | Reset the conversation for the current test |

---

## Quickstart

```robot
*** Settings ***
Library    AIAgent.Agent    gpt-5-chat-latest

*** Test Cases ***
Say Hello
    Chat    Hello, I am a Robot Framework test.
    Chat    What can you do?    model=google-gla:gemini-2.5-flash-lite
```

---

## Key Features & Patterns

- **Structured outputs** — return typed dataclasses/TypedDicts instead of strings via `output_type`
- **Per-call model switch** — override `model`, `model_settings`, `output_type` on any `Chat` call
- **Multi-agent** — import the library multiple times with `AS` aliases (e.g. Author/Reviewer, Planner/Executor)
- **Python tools** — pass functions or `FunctionToolset` via `tools` / `toolsets` parameters
- **MCP toolsets** — use MCP servers (e.g. Playwright) as tool providers
- **Multimodal** — attach images (URL, binary), audio, documents to `Chat` calls
- **Image generation** — use OpenAI image generation as a tool
- **Autonomous conversations** — multiple agents conversing with semantic end-of-conversation detection

### Multi-Agent Patterns (from examples)

| Pattern | Description |
|---|---|
| Ping Pong | Two agents talking to each other via aliases |
| Author ↔ Reviewer | Draft, review with typed feedback, revise |
| Planner → Executor | Agent proposes steps, executor carries them out |
| Chain of Responsibility | Extractor → Judge → Reporter pipeline |
| Ensemble + Arbitration | Two agents answer, a third picks the best |
| Fallback Routing | Start fast/cheap, escalate if not confident |
| Conversation | Multiple agents with auto end-of-conversation detection |

See full examples: https://github.com/d-biehl/robotframework-aiagent/tree/main/docs/examples

---

## Library Configuration

Options at import time:

| Parameter | Description |
|---|---|
| `model` | Default model for all `Chat` calls |
| `instructions` / `system_prompt` | System-level prompt prepended to every conversation |
| `output_type` | Default structured output type |
| `retries` | Number of retries on failure |
| `output_retries` | Retries specifically for output parsing |
| `tools` | List of Python tool functions |
| `toolsets` | List of pydantic-ai toolsets (incl. MCP) |
| `model_settings` | Dict with provider-specific settings (temperature, max_tokens, etc.) |

All of these can be overridden per `Chat` call.

---

## Use Cases

- **Test data generation** — realistic inputs, personas, edge-case strings with typed outputs
- **Tool-augmented agents** — call functions, web services, MCP-exposed tools, or drive UI via Playwright
- **Information extraction** — pull entities, tables, categories from unstructured text
- **Acceptance-check oracles** — evaluate responses against criteria; return boolean verdict + rationale
- **Log triage** — condense noisy logs into concise summaries; propose root causes
- **Document QA / compliance** — detect PII/compliance violations with structured findings
- **Multimodal analysis** — visual QA on screenshots, text-in-image detection, OCR
- **Decision routing** — route cases to sub-flows or switch models based on confidence
- **Multi-agent workflows** — reviewer/author, planner/executor, ensemble/arbitration, red-team/blue-team

---

## Links

- Library repo: https://github.com/d-biehl/robotframework-aiagent
- pydantic-ai docs: https://ai.pydantic.dev/
- PyPI: https://pypi.org/project/robotframework-aiagent/
- Examples & guides: https://github.com/d-biehl/robotframework-aiagent/tree/main/docs/examples