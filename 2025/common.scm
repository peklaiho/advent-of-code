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

;; (number-list-to-number '(1 2 3 4)) -> 1234
(define number-list-to-number
  (lambda (lst)
    (string->number
     (list->string
      (map (lambda (num)
             (integer->char (+ num (char->integer #\0)))) lst)))))

(define make-number-list-helper
  (lambda (lst num)
    (cond
     [(= (length lst) num) lst]
     [else (make-number-list-helper (cons (length lst) lst) num)])))

;; Make list of numbers from 0 to len-1
;; (make-number-list 5) -> (0 1 2 3 4)
(define make-number-list
  (lambda (len)
    (reverse (make-number-list-helper '() len))))

;; Make list of all possible coordinate pairs for a grid
;; (make-coordinate-list 3 2) ->
;; ((0 0) (0 1)
;;  (1 0) (1 1)
;;  (2 0) (2 1))
(define make-coordinate-list
  (lambda (rows cols)
    (apply append
           (let ([row-range (make-number-list rows)]
                 [col-range (make-number-list cols)])
             (map (lambda (y)
                    (map (lambda (x) (list y x)) col-range)) row-range)))))
