# Interactive Test Development & Refactoring

Beyond full scenario automation, rf-mcp excels at interactive test development, refactoring existing tests, and building upon existing Robot Framework resources.

---

## Stepwise Interactive Test Creation

Instead of describing a complete scenario upfront, you can build tests incrementally through conversation. This approach is ideal for:

- Exploratory testing of unfamiliar applications
- Learning how an application behaves
- Building complex flows where each step depends on the previous result
- Debugging and troubleshooting issues

### Starting a Session

```
Use RobotMCP to create a session for web testing using Browser Library

Open https://www.saucedemo.com/ with headless=False
```

### Adding Steps Incrementally

```
Fill the username field with "standard_user"
```

```
Fill the password field with "secret_sauce"
```

```
Click the login button
```

```
Verify that we are on the inventory page
```

### Exploring the Application

```
What elements are visible on the current page?
```

```
Get the page source and show me the interactive elements
```

```
What products are available? List their names and prices.
```

### Making Decisions Based on Results

```
Add the cheapest item to the cart
```

```
How many items are in the cart now? Assert it's correct.
```

### Generating the Test Suite

```
Generate a test suite from all the steps we've executed so far.
Add proper documentation and tags.
```

### Tips for Stepwise Creation

- Use `get_session_state` to see what steps have been recorded
- Ask the agent to show the current page state when unsure
- You can undo or retry failed steps
- Request screenshots at key points for documentation

---

## Refactoring Existing Tests

Take a working but messy test and transform it into a well-structured, maintainable test suite.

### Refactor to Keyword-Driven Structure

```
Here is my current test:

*** Test Cases ***
Login Test
    Open Browser    https://www.saucedemo.com/    chrome
    Input Text    id:user-name    standard_user
    Input Text    id:password    secret_sauce
    Click Button    id:login-button
    Page Should Contain Element    css:.inventory_list
    Click Element    id:add-to-cart-sauce-labs-backpack
    Click Element    css:.shopping_cart_link
    Page Should Contain Element    css:.cart_item
    Close Browser

Refactor this test to use proper keyword-driven structure with:
- Reusable keywords for login, add to cart, and navigation
- Variables for credentials and locators
- Proper setup and teardown
```

### Refactor to Page Object Pattern

```
Take this test suite and refactor it using the page object pattern:

[paste your existing test]

Create separate keyword sections for:
- LoginPage keywords
- InventoryPage keywords  
- CartPage keywords
- CheckoutPage keywords

Each page should have its own locators as variables.
```

### Refactor to Data-Driven Structure

```
I have this login test that I want to run with multiple user types:

[paste your existing test]

Refactor it to use a test template with these test data combinations:
- standard_user / secret_sauce (should succeed)
- locked_out_user / secret_sauce (should show error)
- invalid_user / wrong_password (should show error)
```

### Refactor to BDD/Gherkin Style

```
Convert this test to use BDD-style Given/When/Then keywords:

[paste your existing test]

Use descriptive keyword names that read like natural language.
```

### Refactor for Better Maintainability

```
Review this test and refactor it for better maintainability:

[paste your existing test]

Please:
- Extract magic strings into variables
- Add meaningful documentation
- Improve keyword names for clarity
- Add appropriate tags
- Reduce duplication
```

### Migrate Between Libraries

```
Convert this SeleniumLibrary test to use Browser Library instead:

*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
Example Test
    Open Browser    https://example.com    chrome
    Input Text    id:username    testuser
    Click Button    css:button[type='submit']
    Wait Until Page Contains    Welcome
    Close Browser

Keep the same test logic but use Browser Library syntax and best practices.
```

---

## Re-using Existing Resource Files

Build upon your existing Robot Framework resources, keywords, and libraries.

### Import and Use Existing Resources

```
I have an existing resource file at resources/common.resource with login keywords.

Create a new rf-mcp session and import this resource file.
Then create a new test that:
- Uses the existing Login keyword from the resource
- Adds items to cart
- Completes checkout

Build the test stepwise and generate the final suite with proper imports.
```

### Extend Existing Keywords

```
Import my existing resource file: resources/pages/LoginPage.resource

I want to extend it with new keywords for:
- Login with remember me option
- Login and verify welcome message
- Failed login assertion

Execute each new keyword to verify it works, then generate an updated resource file.
```

### Combine Multiple Resources

```
I have these existing resource files:
- resources/CommonKeywords.resource
- resources/LoginPage.resource
- resources/ProductPage.resource

Create a new end-to-end test that uses keywords from all three resources.
Import them into the session and build a complete checkout flow test.
```

### Use Existing Test as Template

```
Here's my existing login test:

[paste existing .robot file]

Use this as a basis to create a similar test for the registration flow.
Keep the same structure, style, and patterns but adapt it for user registration.
```

### Analyze and Document Existing Keywords

```
Import my resource file: resources/api/RestKeywords.resource

Analyze the existing keywords and:
- List all available keywords with their arguments
- Suggest improvements or missing error handling
- Create example test cases that demonstrate each keyword
```

### Build Test Suite from Existing Components

```
I have these existing resources:
- resources/Setup.resource (browser setup/teardown)
- resources/TestData.resource (test variables)
- resources/PageObjects/Login.resource
- resources/PageObjects/Checkout.resource

Create a new test suite that:
1. Imports all necessary resources
2. Uses the existing setup/teardown
3. Combines page object keywords into a complete E2E test
4. Follows the existing patterns and naming conventions

Execute stepwise to verify everything works together.
```

---

## Combining Approaches

### Stepwise Development with Existing Resources

```
Create a new session and import my existing LoginPage.resource.
I want to build a new test interactively.

First, use the existing Login keyword to authenticate.
Then let's explore the dashboard and create new keywords as we go.
```

### Refactor After Stepwise Creation

```
We just created a test stepwise for the checkout flow.
Now refactor it to:
- Match the patterns in my existing resource files
- Extract reusable keywords to a new CheckoutPage.resource
- Use consistent naming with my other page objects
```

### Create Resources from Successful Tests

```
Take the test suite we just generated and:
- Extract all page-specific keywords into separate resource files
- Create a common variables file for shared locators
- Update the test to import these new resources
- Ensure it still passes when run
```

---

## Prompt Patterns for These Use Cases

### For Stepwise Creation
- "Create a session and open [URL]"
- "Now do [next step]"
- "What's on the current page?"
- "Generate the test from our steps"

### For Refactoring
- "Refactor this test to use [pattern]"
- "Convert from [LibraryA] to [LibraryB]"
- "Extract keywords for [component]"
- "Make this more maintainable"

### For Reusing Resources
- "Import [path/to/resource.resource]"
- "Use the existing [KeywordName] keyword"
- "Follow the patterns from my existing files"
- "Extend this resource with new keywords"

---

## Best Practices

1. **Keep sessions active** - Don't close the session between steps when building incrementally
2. **Verify before generating** - Test each step before creating the final suite
3. **Maintain consistency** - When refactoring, ask to match existing patterns
4. **Document imports** - Ensure generated suites include all necessary imports
5. **Test the result** - Run the generated suite to verify it works end-to-end
