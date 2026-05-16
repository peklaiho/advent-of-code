(load "./common.scm")

;;; Part 1

(define parse-symbol
  (lambda (sym)
    (cond
     [(string=? sym "+") +]
     [(string=? sym "*") *]
     [else (string->number sym)])))

(define parse-row
  (lambda (row)
    (let ([parts (string-split row #\ )])
      (map parse-symbol (filter (lambda (part) (> (string-length part) 0)) parts)))))

;; ((1 2) (3 4)) -> ((1 3) (2 4))
(define transpose-rows
  (lambda (rows)
    (cond
     [(null? (car rows)) '()]
     [else (cons (map car rows) (transpose-rows (map cdr rows)))])))

(define compute-row
  (lambda (row)
    (apply (car row) (cdr row))))

(define read-input
  (lambda ()
    (let* ([raw-rows (map parse-row (read-file-lines "day06-input.txt"))]
           [formatted-rows (transpose-rows raw-rows)]
           [reversed-rows (map reverse formatted-rows)])
      reversed-rows)))

(let* ([rows (read-input)]
       [computed-rows (map compute-row rows)]
       [result-one (reduce + 0 computed-rows)])
  (simple-format #t "Result for part 1: ~A\n" result-one))

;;; Part 2

;; Return a list of indexes for each character in a string that is not the space character.
;; For example: "*   +   *   +" -> (0 4 8 12)
(define string-find-indexes-not-space
  (lambda (str ind res)
    (cond
     [(>= ind (string-length str)) (reverse res)]
     [else (let ([space (char=? #\space (string-ref str ind))])
             (string-find-indexes-not-space str (+ ind 1) (if space res (cons ind res))))])))

;; Parse list of characters into a number.
;; For example: (#\3 #\6 #\9) -> 369
;; Space characters are trimmed and -1 is returned if string is empty.
(define char-list->number
  (lambda (col)
    (let ([trimmed (string-trim-both (list->string col))])
      (if (= 0 (string-length trimmed)) -1
          (string->number trimmed)))))

;; Parse column, taking single character from each row.
;; Missing characters are replaced with space.
;; Finally result is converted into an integer.
(define parse-column
  (lambda (value-rows ind)
    (char-list->number
     (map (lambda (row)
            (if (>= ind (string-length row)) #\space
                (string-ref row ind))) value-rows))))

;; Parse all columns starting from index until we get
;; an empty column (only spaces).
(define parse-columns-at-index
  (lambda (value-rows ind res)
    (let ([num (parse-column value-rows ind)])
      (cond
       [(= num -1) (reverse res)]
       [else (parse-columns-at-index value-rows (+ ind 1) (cons num res))]))))

(define parse-value-rows
  (lambda (value-rows op-indexes)
    (map (lambda (ind) (parse-columns-at-index value-rows ind '())) op-indexes)))

(define combine-values-and-operators
  (lambda (parsed-rows operators op-indexes res)
    (cond
     [(null? parsed-rows) (reverse res)]
     [else (let* ([op-index (car op-indexes)]
                  [op (parse-symbol (substring operators op-index (+ op-index 1)))])
             (combine-values-and-operators (cdr parsed-rows) operators (cdr op-indexes)
                                           (cons (cons op (car parsed-rows)) res)))])))

(let* ([raw-rows (read-file-lines "day06-input.txt")]
       [value-count (- (length raw-rows) 1)]
       [operators (car (list-tail raw-rows value-count))]
       [value-rows (list-head raw-rows value-count)]
       [op-indexes (string-find-indexes-not-space operators 0 '())]
       [parsed-rows (parse-value-rows value-rows op-indexes)]
       [combined (combine-values-and-operators parsed-rows operators op-indexes '())]
       [result-two (reduce + 0 (map compute-row combined))])
  (simple-format #t "Result for part 2: ~A\n" result-two))
