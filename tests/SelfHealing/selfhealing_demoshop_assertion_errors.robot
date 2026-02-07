*** Settings ***
Documentation    Test suite generated from session a96c87c6-2823-45d2-b8b6-33b8fa40e38a containing 1 test case for web automation.
Library         Browser
Test Tags       catalogue    web    automated    generated    web

*** Test Cases ***
WEB-002 Browse Product Catalogue
    [Documentation]    Verify products grid loads with 12 items and each card shows name, image, price, and Add to Cart button.
    New Browser    chromium    headless=False
    New Context
    New Page    https://demoshop.makrocode.de/products    load
    Wait For Elements State    css=section.section:has(h2.section-title:has-text("All products")) .product-grid    visible    10s
    Get Element Count    css=section.section:has(h2.section-title:has-text("All products")) .product-grid [data-test='product-card']    ==    12
    Get Element Count    css=section.section:has(h2.section-title:has-text("All products")) .product-grid [data-test='product-card'] img    ==    12
    Get Element Count    css=section.section:has(h2.section-title:has-text("All products")) .product-grid [data-test='product-card'] [data-test='product-price']    ==    12
    Get Element Count    css=section.section:has(h2.section-title:has-text("All products")) .product-grid [data-test='product-card'] [data-test='product-link']    ==    12
    Get Element Count    css=section.section:has(h2.section-title:has-text("All products")) .product-grid [data-test='product-card'] [data-test='add-to-cart-btn']    ==    12
    [Teardown]    Close Browser
