*** Settings ***
Documentation    Test suite generated from session saucedemo_web containing 1 test case for web automation.
Library         Browser
Library    robotmcp.attach.McpAttach    token=${DEBUG_TOKEN}

*** Variables ***
${DEBUG_TOKEN}    change-me

*** Test Cases ***
SauceDemo_E2E
    [Documentation]    SauceDemo headless False E2E purchase flow
    [Tags]    saucedemo    e2e    browser
    New Browser    browser=chromium    headless=${False}
    New Context
    New Page
    Go To    https://www.saucedemo.com/
    Fill Text    \#user-name    standard_user
    Fill Text    \#password    secret_sauce
    Click    \#login-button

    MCP Serve    port=7317    token=${DEBUG_TOKEN}    mode=blocking

    Click    \#add-to-cart-sauce-labs-backpack
    Click    \#add-to-cart-sauce-labs-bike-light
    Click    .shopping_cart_link
    ${elements_count}=    Get Element Count    .cart_item    ==    2
    Click    \#checkout
    Fill Text    \#first-name    Test
    Fill Text    \#last-name    User
    Fill Text    \#postal-code    12345
    Click    \#continue
    Click    \#finish
    ${header_text}=    Get Text    [data-test=complete-header]    *=   Thank you for your order!
    Close Browser
