# Creating Test Scenarios from Natural Language

One of the core capabilities of rf-mcp is converting natural language descriptions into executable Robot Framework tests. This chapter provides example prompts for different testing domains.

## How It Works

1. **Describe** your test scenario in plain language
2. **rf-mcp analyzes** the scenario and recommends appropriate libraries
3. **Execute stepwise** - each step runs in real-time with immediate feedback
4. **Generate** a production-ready test suite from successful executions

## Prompt Structure

A typical prompt includes:

- **Target application** - URL, file path, or API endpoint
- **Test steps** - Actions to perform and assertions to make
- **Library preference** (optional) - Specify Browser Library, SeleniumLibrary, etc.
- **Additional options** (optional) - Variables, data-driven approach, etc.
- **Execution instruction** - Usually "Execute step by step and build final test suite afterwards"

---

## Web Application Testing Examples

### Basic Web Test (Browser Library)

```
Use RobotMCP to create a test suite and execute it step wise.
It shall:

- Open https://todomvc.com/examples/react/dist/
- Enter several Todos
- Assert number of ToDos
- Mark ToDos as Done
- Assert Number of ToDos
- Close Browser

Execute step by step and build final test suite afterwards
Use headless=False
```

### Web Test with SeleniumLibrary

```
Use RobotMCP to create a test suite and execute it step wise.
It shall:

- Open https://todomvc.com/examples/react/dist/
- Enter several Todos
- Assert number of ToDos
- Mark ToDos as Done
- Assert Number of ToDos
- Close Browser

Execute step by step and build final test suite afterwards
Use Selenium Library
```

### Web Test with Variables

```
Use RobotMCP to create a test suite and execute it step wise.
It shall:

- Open https://todomvc.com/examples/react/dist/
- Enter several Todos
- Assert number of ToDos
- Mark ToDos as Done
- Assert Number of ToDos
- Close Browser

Use Selenium Library
Use variables to store locator values
Execute step by step and build final test suite afterwards
```

### E-Commerce Flow (Sauce Demo)

```
Use RobotMCP to create a test suite and execute it step wise.
It shall:

- Open https://www.saucedemo.com/
- Login with valid user
- Assert login was successful
- Add item to cart
- Assert item was added to cart
- Add another item to cart
- Assert another item was added to cart
- Checkout
- Assert checkout was successful

Execute step by step and build final test suite afterwards
Use headless=False

```

### E-Commerce with SeleniumLibrary and Variables

```
Use RobotMCP to create a test suite and execute it step wise.
It shall:

- Open https://www.saucedemo.com/
- Login with valid user
- Assert login was successful
- Add item to cart
- Assert item was added to cart
- Add another item to cart
- Assert another item was added to cart
- Checkout
- Assert checkout was successful

Use Selenium Library
Use variables to store locator values
Execute step by step and build final test suite afterwards
```

---

## API / HTTP Testing Examples

### RESTful API Test

```
Fetch https://restful-booker.herokuapp.com/apidoc/index.html for information about webservice
Use RobotMCP to create a test suite and execute it step wise.
It shall:

- Read a booking and assert the response and its values
- Create a new booking and assert the response and its values
- Authenticate as admin and assert the response and its values
- Delete a booking while authenticated

Execute the test suite stepwise and build the final version afterwards.
```

### Tips for API Testing

- Provide the API documentation URL so the agent can understand the endpoints
- Specify authentication requirements if needed
- Include expected response codes and data validation

---

## XML Testing Examples

### XML Parsing and Validation

```
Create an example .xml file for Books and Authors.

Use RobotMCP to create a test suite and execute it step wise.
It shall:

Parse the XML file, checks several nodes and attributes and do assertions.
Execute it stepwise and afterwards create a final test suite
```

### Tips for XML Testing

- You can ask the agent to create sample XML files first
- Specify which nodes, attributes, or values to validate
- Uses Robot Framework's built-in XML library

---

## Mobile Testing Examples

### Mobile App Test with local Appium

```
Use RobotMCP to create a test suite and execute it step wise.
It shall:

- Open the mobile application tests/appium/SauceLabs.apk
- Perform a login action
- Assert login was successful
- Add item to cart
- Assert item was added to cart
- Add another item to cart
- Assert another item was added to cart
- Checkout
- Assert checkout was successful

Execute the test suite stepwise and build the final version afterwards.
Appium is running at http://localhost:4723 (without /wd/hub)

adb is in folder C:\Tools\platform-tools
```

### Prerequisites for Mobile Testing

- Appium server running locally
- Android SDK / ADB configured
- APK file accessible
- Device or emulator connected

---

## Customizing Your Prompts

### Specify Library Explicitly

Add one of these lines to your prompt:
- `Use Browser Library` (Playwright-based, recommended for modern web apps)
- `Use Selenium Library` (traditional WebDriver-based)
- `Use RequestsLibrary` (for API testing)
- `Use AppiumLibrary` (for mobile testing)

### Request Specific Patterns

- `Use variables to store locator values`
- `Use page object pattern`
- `Create reusable keywords for common actions`
- `Use data-driven approach with test templates`
- `Add proper documentation and tags`

### Control Execution

- `Execute step by step` - Interactive mode with feedback after each step
- `Build final test suite afterwards` - Generate .robot file from successful steps
- `Run in headless mode` - For CI/CD environments
- `Take screenshots on each step` - For visual documentation

---

## Best Practices

1. **Start simple** - Begin with basic flows, then add complexity
2. **Be specific about assertions** - "Assert login was successful" is better than "check it works"
3. **Provide context** - Include URLs, credentials (use test accounts), and environment details
4. **Iterate** - If a step fails, describe the issue and ask the agent to retry with adjustments
5. **Review generated code** - Always review the final test suite before committing

---

## 📋 Tasks (15 Minutes)

### 1) Try out some example prompts

Make yourself familiar with MCP Server usage by running some of the example prompts above.

For example:

```
Use RobotMCP to create a test suite and execute it step wise.
It shall:

- Open https://www.saucedemo.com/
- Login with valid user
- Assert login was successful
- Add item to cart
- Assert item was added to cart
- Add another item to cart
- Assert another item was added to cart
- Checkout
- Assert checkout was successful

Execute step by step and build final test suite afterwards
Use headless=False

```

Try out different models, e.g.

- Claude Haiku
- Claude Sonnet
- GPT-5.X Codex
- GPT 4.1
- GPT-4o

#### Questions
- What do you experience?
- Are there some models better suited for the task? 

### 2) Automate a more complex Web Shop

Check out https://demoshop.makrocode.de/

Investigate how to complete an order

Write a prompt to automate the order process with rf-mcp

### Alternative Demo Shop

```
Use RobotMCP to create a test suite and execute it step wise.
It shall:

- Open https://demoshop.makrocode.de/
- Add item to cart
- Assert item was added to cart
- Add another item to cart
- Assert another item was added to cart
- Checkout
- Assert checkout was successful

Execute step by step and build final test suite afterwards
Use headless=False

```

### 3) Automate a REST API

The Webshop above also offers an API

- https://demoshop.makrocode.de/docs
- https://demoshop.makrocode.de/openapi.json

Are you able to create API Test Cases using a prompt?