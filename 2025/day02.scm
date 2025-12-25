(load "./common.scm")

;; ------
;; Part 1
;; ------

;; Check whether one id (as a string) is invalid for part 1
(define invalid-id-one?
  (lambda (id)
    (let ([len (string-length id)])
      (if (= (modulo len 2) 1) #f
          (let ([half (/ len 2)])
            (string=? (substring id 0 half) (substring id half)))))))

;; ------
;; Part 2
;; ------

;; Return #t if lst is made up of repeating patterns of pat
(define repeating-pattern?
  (lambda (lst pat)
    (cond
     [(null? lst) #t]
     [(< (length lst) (length pat)) #f]
     [(not (equal? pat (list-head lst (length pat)))) #f]
     [else (repeating-pattern? (list-tail lst (length pat)) pat)])))

;; Generate all possible prefixes for a list that the list
;; can be made up of, assuming each prefix can repeat at least twice
;; (1 2 1 2) () -> ((1) (1 2))
;; (1 2 1 2 1) () -> ((1) (1 2))
;; (1 2 1 2 1 2) () -> ((1) (1 2) (1 2 1))
(define generate-prefixes
  (lambda (lst prefixes)
    (let ([max-len (quotient (length lst) 2)])
      (cond
       [(= (length prefixes) max-len) (reverse prefixes)]
       [else (generate-prefixes lst (cons (list-head lst (+ 1 (length prefixes))) prefixes))]))))

;; Check if any of the given prefixes is a repeating pattern that makes up lst.
(define check-prefixes
  (lambda (lst prefixes)
    (cond
     [(null? prefixes) #f]
     [(repeating-pattern? lst (car prefixes)) #t]
     [else (check-prefixes lst (cdr prefixes))])))

;; Part 2: Check if one id (as a string) is invalid for part 2
(define invalid-id-two?
  (lambda (id)
    (let* ([lst (string->list id)]
           [prefixes (generate-prefixes lst '())])
      (check-prefixes lst prefixes))))

;; ----------------
;; Common functions
;; ----------------

;; Take a list of IDs (as numbers) and sum together the invalid ones
(define sum-invalids
  (lambda (ids test-fn)
    (reduce + 0
            (map
             (lambda (item)
               (let ([invalid? (test-fn (number->string item))])
                 (if invalid? item 0))) ids))))

;; Make a list numbers from start until end
;; (make-range 1 3 '()) -> (1 2 3)
(define make-range
  (lambda (start end list)
    (cond
     [(= start end) (cons end list)]
     [else (make-range start (- end 1) (cons end list))])))

;; Turn a dash-separated string range into a list of numbers
;; (range-to-list "123-125") -> (123 124 125)
(define range-to-list
  (lambda (range-string)
    (let* ([parts (string-split range-string #\-)]
           [start (string->number (car parts))]
           [end (string->number (cadr parts))])
           (make-range start end '()))))

;; Take a list of ranges in the form of "11-22,33-44,55-66"
;; and sum the invalid IDs together.
(define process-list-of-ranges
  (lambda (range-list test-fn)
    (let ([ranges (string-split range-list #\,)])
      (reduce + 0
              (map (lambda (range-string)
                     (sum-invalids (range-to-list range-string) test-fn)) ranges)))))

(let ([range-list (car (read-file-lines "day02-input.txt"))])
  (let ([result-one (process-list-of-ranges range-list invalid-id-one?)]
        [result-two (process-list-of-ranges range-list invalid-id-two?)])
    (write-line (string-append "Part 1: Sum of invalid IDs: " (number->string result-one)))
    (write-line (string-append "Part 2: Sum of invalid IDs: " (number->string result-two)))))
