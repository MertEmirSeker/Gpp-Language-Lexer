# G++ Language Lexer in Lisp

A Lisp implementation of a lexer for the G++ language, designed to tokenize a subset of language constructs including keywords, operators, and identifiers.

## Features

- Tokenizes G++ language constructs: keywords, operators, identifiers, and values.
- Supports reading input directly from the terminal or from a file.
- Identifies and handles syntax errors and comments.

## Requirements

- A Common Lisp interpreter (e.g., SBCL, CLISP).

## Setup and Execution

1. **Interactive Mode**: Start the lexer in interactive mode, allowing direct input from the terminal.

(gppinterpreter)

Follow the prompts to enter code snippets directly.

2. **File Input Mode**: Read and tokenize input from a file.

(gppinterpreter)

When prompted, choose to read from a file and enter the file name.

## Tokens and Error Handling

- **Keywords and Operators**: Recognized based on predefined lists and tokenized accordingly.
- **Identifiers and Values**: Validated using custom checks before tokenization.
- **Comments and Syntax Errors**: Detected and handled, with syntax errors prompting specific error messages.
