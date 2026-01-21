# Robot Framework Agent Skills – Short Overview

## What are Agent Skills?
Agent Skills are **modular instruction packages** that teach AI agents how to perform specific tasks without retraining the model.  
Each skill is a self-contained folder with a `SKILL.md` file that explains *when* and *how* the agent should use it.

Think of them as **plug‑and‑play capabilities** for AI agents.

---

## Robot Framework Agent Skills
The **robotframework-agentskills** repository provides Agent Skills focused on Robot Framework test automation.

They enable AI agents to:
- Understand Robot Framework results
- Explore and explain keywords
- Generate keywords, test cases, and resource structures
- Support test design, analysis, and maintenance

---

## What They Can Do

- **Analyze test results**  
  Read `output.xml` and summarize failures, statistics, and execution details.

- **Find & explain keywords**  
  Search libraries and explain how keywords work and when to use them.

- **Generate automation artifacts**  
  Create user keywords, test cases, and resource file structures from structured input.

---

## How to Use Them

### With an AI Agent
1. Place the skills in a supported skills directory (e.g. `.github/skills`).
2. Ask the agent a task (e.g. *“Explain this keyword”*).
3. The agent loads the relevant skill and follows its instructions.

### From CLI / CI
Many skills include scripts that:
- Take JSON input
- Produce JSON output

This allows easy integration into **CI pipelines**, tooling, or automation workflows.

---

## Why Use Agent Skills?
- Add **domain knowledge** without fine-tuning models
- Keep AI systems **modular and maintainable**
- Share reusable AI capabilities across teams

---

**In short:** Agent Skills make AI agents *practically useful* for Robot Framework automation.
