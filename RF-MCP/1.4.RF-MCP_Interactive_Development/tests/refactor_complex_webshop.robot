*** Settings ***
Documentation    Test suite generated from RobotMCP session for Makrocode demo shop E2E checkout flow
Library         Browser

*** Variables ***
${BASE_URL}    https://demoshop.makrocode.de/

*** Test Cases ***
Makrocode DemoShop E2E Checkout Test
    [Documentation]    End-to-end test for Makrocode demo shop with headless=False
    ...    - Opens the shop at ${BASE_URL}
    ...    - Adds first item (Cascade Water Bottle) to cart
    ...    - Adds second item (Orbit Drone Camera) to cart
    ...    - Verifies cart count is 2
    ...    - Navigates to checkout
    ...    - Fills checkout form with test data
    ...    - Completes the order
    ...    - Verifies checkout success

    [Tags]    e2e    checkout    web    smoke

    # Open browser with headless=False for visual debugging
    ${browser} =    New Browser    chromium    False

    # Create context with SSL error handling
    ${context} =    New Context    ignoreHTTPSErrors=True

    # Load the demo shop
    ${page} =    New Page    ${BASE_URL}

    # Add first item to cart and wait for count to update
    Click    button:has-text('Add to cart') >> nth=0
    Get Text    [data-cart-count]    ==    1

    # Add second item to cart and wait for count to update
    Click    button:has-text('Add to cart') >> nth=1
    Get Text    [data-cart-count]    ==    2

    # Navigate to checkout
    Click    a:has-text('Checkout')

    # Fill in checkout form
    Fill Text    \#checkout-email    test@example.com
    Fill Text    \#checkout-name    Test User
    Fill Text    \#checkout-address    123 Test Street\nSan Francisco, CA 94105

    # Place order
    Click    button:has-text('Place order')

    # Verify checkout success - check for order confirmation message
    ${page_text} =    Get Text    body
    Should Contain    ${page_text}    Order ORD    msg=Order should be confirmed with order number
    Should Contain    ${page_text}    test@example.com    msg=Confirmation email should be shown
    Should Contain    ${page_text}    confirmed    msg=Order confirmation message should appear

    # Close browser
    Close Browser

