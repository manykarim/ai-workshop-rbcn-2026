*** Settings ***
Documentation    Complete e-commerce test: add items to cart, fill checkout form, and confirm successful order placement
Library         SeleniumLibrary
Test Tags       demoshop    selenium    e2e    checkout    automated    web

*** Test Cases ***
Demoshop Complete Order Flow
    [Documentation]    Complete e-commerce test: add items to cart, fill checkout form, and confirm successful order placement
    [Tags]    demoshop    selenium    e2e    checkout
    
    # Open browser and add items to cart
    Open Browser    https://demoshop.makrocode.de/    headlesschrome        options=add_argument('--no-sandbox'); add_argument('--disable-dev-shm-usage')
    
    # Add first item to cart
    Click Button    xpath=(//button[contains(text(),'Add to cart')])[1]
    Wait Until Element Contains    xpath=//span[@data-cart-count]    1    timeout=5s
    ${cart_count} =    Get Text    xpath=//span[@data-cart-count]
    Should Be Equal    ${cart_count}    1    msg=First item should be added to cart
    
    # Add second item to cart
    Click Button    xpath=(//button[contains(text(),'Add to cart')])[2]
    Wait Until Element Contains    xpath=//span[@data-cart-count]    2    timeout=5s
    ${cart_count_2} =    Get Text    xpath=//span[@data-cart-count]
    Should Be Equal    ${cart_count_2}    2    msg=Second item should be added to cart
    
    # Navigate to checkout
    Click Link    xpath=//a[@href='/checkout']
    Wait Until Location Is    https://demoshop.makrocode.de/checkout    timeout=10s
    Wait Until Page Contains Element    xpath=//h1[contains(text(),'Checkout')] | //h2[contains(text(),'Checkout')] | //title[contains(text(),'Checkout')]    timeout=10s
    ${current_url} =    Get Location
    Should Be Equal    ${current_url}    https://demoshop.makrocode.de/checkout
    Page Should Contain Element    xpath=//h1[contains(text(),'Checkout')] | //h2[contains(text(),'Checkout')] | //title[contains(text(),'Checkout')]
    
    # Fill in checkout form
    Input Text    id=checkout-email    test@productstudio.com
    Input Text    id=checkout-name    Jamie Product
    Input Text    id=checkout-address    123 Flow Street, San Francisco, CA
    Input Text    id=checkout-team-size    5
    Input Text    id=checkout-notes    Please deliver between 9 AM - 5 PM
    
    # Place order
    Click Button    xpath=//button[contains(text(),'Place order')]
    
    # Verify successful order placement
    Wait Until Page Contains Element    xpath=//a[contains(text(),'Download Invoice PDF')]    timeout=15s
    Wait Until Page Contains Element    xpath=//a[contains(text(),'Download Order Summary PDF')]    timeout=10s
    Page Should Contain Element    xpath=//a[contains(text(),'Download Invoice PDF')]    msg=Invoice PDF link should be present
    Page Should Contain Element    xpath=//a[contains(text(),'Download Order Summary PDF')]    msg=Order Summary PDF link should be present
    
    # Verify cart is empty after successful order (badge becomes hidden when empty)
    Element Should Not Be Visible    xpath=//span[@data-cart-count][contains(@class,'is-visible')]    msg=Cart badge should be hidden after successful order
    
    Close Browser
