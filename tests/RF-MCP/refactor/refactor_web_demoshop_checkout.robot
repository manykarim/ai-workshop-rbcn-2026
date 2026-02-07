*** Settings ***
Documentation    Test suite generated from session b62a359f-6333-4cf6-b44d-2a7a7d6de227 containing 1 test case for web automation.
Library         Browser
Test Tags       demoshop    checkout    e2e    automated    generated    web

*** Test Cases ***
Demoshop Checkout Test
    [Documentation]    Test demoshop website: add items to cart and complete checkout process
    [Tags]    demoshop    checkout    e2e
    New Browser    chromium    headless=False
    New Context
    New Page    https://demoshop.makrocode.de/
    Click    [data-product='12'][data-test='add-to-cart-btn'] >> nth=0
    Click    [data-product='10'][data-test='add-to-cart-btn'] >> nth=0
    ${cart_count} =    Get Text    [data-cart-count]
    Should Be Equal    ${cart_count}    2
    Click    text=Checkout    # Click on text=Checkout
    Fill Text    \#checkout-email    test@example.com
    Fill Text    \#checkout-name    John Doe
    Fill Text    \#checkout-address    123 Test Street, Test City, TC
    Click    text=Place order    # Click on text=Place order
    Get Element    text=Order ORD
    [Teardown]    Close Browser    
