*** Settings ***
Documentation    AC-5: Add to cart on the home page with cart verification.
Library         Browser
Library    SelfhealingAgents
Test Tags       web    ac-5    add-to-cart

*** Test Cases ***
WEB-001_AC-5_Add_To_Cart
    [Documentation]    This test verifies that adding a product to the cart updates the cart badge count.
    New Browser    chromium    headless=False
    New Context
    New Page
    Go To    https://demoshop.makrocode.de
    Wait For Elements State    css=section:has(h2:has-text("Featured this week")) article:has(h3:has-text("Cascade Water Bottle")) [data-test='add-to-cart-btn']    visible    10s
    Click    css=section:has(h2:has-text("Featured this week")) article:has(h3:has-text("Cascade Water Bottle")) [data-test='add-to-cart-btn']
    Get Text    css=.site-nav__link--cart .badge    ==     1
    Close Browser
