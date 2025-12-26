(use-modules (ice-9 rdelim))
(use-modules (srfi srfi-1))

(define read-lines-from-port
  (lambda (port ls)
    (let ([line (read-line port 'split)])
      (cond
       [(eof-object? (cdr line)) ls]
       [else (read-lines-from-port port (cons (car line) ls))]))))

(define read-file-lines
  (lambda (filename)
    (call-with-input-file filename
      (lambda (port)
        (reverse (read-lines-from-port port '()))))))

(define number-list-to-number
  (lambda (lst)
    (string->number
     (list->string
      (map (lambda (num)
             (integer->char (+ num (char->integer #\0)))) lst)))))
