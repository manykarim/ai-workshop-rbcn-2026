# DoctestLibrary  
A Library for visual and contentwise Document Testing and comparison with optional AI features

https://github.com/manykarim/robotframework-doctestlibrary

While it also has some AI features, it can also be used from the rf-mcp as library.

```bash
pip install robotframework-doctestlibrary
```

## Examples

### VisualTest

```robot
*** Settings ***
Library    DocTest.VisualTest

*** Test Cases ***
Compare two Images and highlight differences
    Compare Images    Reference.jpg    Candidate.jpg

Compare two PDFs and highlight differences
    Compare Images    Reference.pdf    Candidate.pdf

Compare two PDFs and ignore Date Patterns
    Compare Images    Reference.pdf    Candidate.pdf
    ...     mask={ "page": "all", "name": "Date Pattern", "type": "pattern", "pattern": ".*[0-9]{2}-[a-zA-Z]{3}-[0-9]{4}.*" }

Get text with assertion
    ${text}=    Get Text    document.pdf    ==    Expected text
```

### PDF Test

```robot
*** Settings ***
Library    DocTest.PdfTest

*** Test Cases ***
Compare two PDF Files and only check text content
    Compare Pdf Documents    Reference.pdf    Candidate.pdf    compare=text
```

## Using DocTestLibrary with rf-mcp

```robot
