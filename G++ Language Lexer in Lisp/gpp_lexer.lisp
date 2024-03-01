;; Defining lists for keywords, keyword tokens, operators, operator tokens
(setq Keywords '("and" "or" "not" "equal" "less" "nil" "list" "append" "concat" "set" "def" "for" "if" "exit" "load" "display" "true" "false"))
(setq KWS '(KW_AND KW_OR KW_NOT KW_EQUAL KW_LESS KW_NIL KW_LIST KW_APPEND KW_CONCAT KW_SET KW_DEF KW_FOR KW_IF KW_EXIT KW_LOAD KW_DISPLAY KW_TRUE KW_FALSE))
(setq Operators '("+" "-" "/" "*" "(" ")" ","))
(setq OPS '(OP_PLUS OP_MINUS OP_DIV OP_MULT OP_OP OP_CP OP_COMMA))

;; Defining characters that should be considered as spaces and defining comment symbol
(setq Spaces '(#\Space #\Newline #\Tab))
(setq Comment ";")

;; Defining constants for token types
(defconstant +keyword+ 0)
(defconstant +operator+ 1)
(defconstant +value+ 2)
(defconstant +identifier+ 3)
(defconstant +comment+ 4)
(defconstant +unknown+ -1)

;; Defining function to check if a token is a keyword
(defun keywordCheck (token) (position token Keywords :test #'string-equal))  
;; Defining function to check if a token is a operator
(defun operatorCheck (token) (position token Operators :test #'string-equal))
;; Defining function to check if a token is a valid value for VALUEF (numberbnumber like 123b12 means 123/12)
(defun valuefCheck (token)
;; Checking if token is a valid for VALUEF
  (when (> (length token) 2) ;; Ensure token is long enough to contain a 'b' and numbers on both sides
    (let ((b-position (position #\b token))) ;; Find the position of 'b'
      (and b-position ;; Ensure 'b' was found
           (let ((num1 (subseq token 0 b-position))
                 (num2 (subseq token (1+ b-position))))
             (and (not (equal num1 ""))
                  (not (equal num2 ""))
                  (every #'digit-char-p num1)
                  (every #'digit-char-p num2)))))))
;; Defining function to check if a token is valid identifier for IDENTIFIER (Any combination of alphabetical characters and digits with only leading alphabetical characters.)
(defun identifierCheck (token)
;; Checking if token is a valid for IDENTIFIER
  (and (alpha-char-p (char token 0))  ;; First character must be a letter
       (every #'alphanumericp token))) ;; Rest of the token must be alphanumeric
;; Defining function to check if a token is comment
(defun commentCheck (token) (helperComment token Comment))

;; Helper function to commentCheck function and checking if a string starts with a ';;'
(defun  helperComment(string comment)
;; Checking if string starts with ';;'
  (and (>= (length string) (length comment))
       (string= (subseq string 0 (length comment)) comment)))

;; Our main tokenization function. This function taking an input string and converting into a tokens
(defun tokenize (input)
;; Converts a string into a list of tokens.
  (loop with token = "" ;; Initialize an empty string to build up tokens
        for char across input ;; Iterate over each character in the input
        do (cond
             ((member char Spaces) ;; Examine for whitespace characters to separate tokens
              (when (> (length token) 0)
                (printToken token) ;; Print the token we have built up so far
                (setq token ""))) ;; Reset token to empty for the next token
             ((char= char #\;) ;; If the character is the start of a comment
              (when (> (length token) 0) ;; Checking for comment symbol to print token and skipping the rest of the line
                (printToken token)
                (setq token ""))
              (printToken (subseq input (position char input)))
              (return))
             ((operatorCheck (string char)) ;; Scan for operator symbols to segment the tokens
              (when (> (length token) 0)
                (printToken token)
                (setq token ""))
              (printToken (string char)))
             (t (setq token (concatenate 'string token (string char)))))
                finally (when (> (length token) 0) (printToken token)))) ;; Print any remaining token after loop finishes

;; Our printing function. It checks the types and prints the tokens.
(defun printToken (token)
;; Print a token based on its type.
  (when token
    (cond ((commentCheck token) (format t "COMMENT~%"))
          ((keywordCheck token) (format t "~a ~%" (nth (keywordCheck token) KWS)))
          ((operatorCheck token) (format t "~a ~%" (nth (operatorCheck token) OPS)))
          ((valuefCheck token) (format t "VALUEF~%"))
          ((identifierCheck token) (format t "IDENTIFIER~%"))
          ((every #'digit-char-p token) (format t "SYNTAX_ERROR ~a cannot be tokenized~%" token))  
          (t (format t "SYNTAX_ERROR ~a cannot be tokenized~%" token)))))

;; Our main interpreter function that provides a user interface for reading frol a file or entering from terminal
(defun gppinterpreter ()
;; Main entry loop and tokenization process
  (format t "Welcome to the G++ Language Lexer in Lisp. Type (exit) to exit the program.~%")
  (format t "Would you like to read from a file? (yes/no): ")
  (let ((response (read-line)))
    (cond ((string-equal response "yes")
          ;; User chose to read from file
           (progn
             (format t "Enter the file name (Hint: input.g++): ")
             (let ((file-name (read-line)))
               (with-open-file (stream file-name)
                 (loop for line = (read-line stream nil nil)
                       while line do
                         (tokenize line))))))
          ((string-equal response "no")
          ;; User chose interactive mode
           (progn
             (format t "Entering interactive mode. Type (exit) to exit. Please enter a code:~%")
             (loop
                do (progn
                     (format t "> ")
                     (let ((line (read-line nil nil)))
                       (if (or (null line) (string-equal line "(exit)"))
                           (return (format t "Exiting the G++ Language Lexer in Lisp. Goodbye!!!~%"))
                           (tokenize line)))))))
          ((string-equal response "(exit)")
          ;; User chose to exit the program
          (format t "Exiting the G++ Language Lexer in Lisp. Goodbye!!!~%"))
          (t (format t "Invalid response. Exiting program. Goodbye!!!~%")))))


;; Starting the interpreter
(gppinterpreter)

