(load "./common.scm")

;; ------
;; Part 1
;; ------

(define in-range?
  (lambda (id range)
    (and (>= id (car range)) (<= id (cdr range)))))

;; Escape early when a match is found using call-with-escape-continuation
(define in-ranges?
  (lambda (id ranges)
    (call-with-escape-continuation
     (lambda (return)
       (for-each
        (lambda (range)
          (when (in-range? id range)
            (return #t))) ranges)
       #f))))

(define count-fresh
  (lambda (ranges ids)
    (reduce + 0
            (map (lambda (id)
                   (if (in-ranges? id ranges) 1 0)) ids))))

(define parse-range
  (lambda (input dash-index)
    (cons (string->number (substring input 0 dash-index))
          (string->number (substring input (+ dash-index 1))))))

(define parse-input
  (lambda (input ranges ids)
    (cond
     [(null? input) (list (reverse ranges) (reverse ids))]
     [else
      (let* ([row (car input)]
             [dash (string-index row #\-)])
        (if (= (string-length row) 0)
            (parse-input (cdr input) ranges ids)
            (if dash
                (parse-input (cdr input) (cons (parse-range row dash) ranges) ids)
                (parse-input (cdr input) ranges (cons (string->number row) ids)))))])))

;; ------
;; Part 2
;; ------

(define sort-ranges
  (lambda (ranges)
    (sort ranges (lambda (r1 r2)
                   (< (car r1) (car r2))))))

(define merge-ranges
  (lambda (ranges result)
    (cond
     [(null? ranges) (reverse result)]
     [(null? result) (merge-ranges (cdr ranges) (cons (car ranges) result))]
     [else
      (let* ([current (car ranges)]
             [last (car result)])
        (if (<= (car current) (cdr last))
            (merge-ranges (cdr ranges) (cons (cons (min (car current) (car last))
                                                   (max (cdr current) (cdr last)))
                                             (cdr result)))
            (merge-ranges (cdr ranges) (cons current result))))])))

(define count-numbers-in-ranges
  (lambda (ranges)
    (reduce + 0 (map (lambda (range)
                       (+ 1 (- (cdr range) (car range)))) ranges))))

(define part-two
  (lambda (ranges)
    (count-numbers-in-ranges (merge-ranges (sort-ranges ranges) '()))))

;; ------
;; Common
;; ------

(let* ([raw-input (read-file-lines "day05-input.txt")]
       [parsed-input (parse-input raw-input '() '())]
       [ranges (car parsed-input)]
       [ids (cadr parsed-input)])
  (simple-format #t "Fresh items (part 1): ~A\n" (count-fresh ranges ids))
  (simple-format #t "Unique numbers (part 2): ~A\n" (part-two ranges)))
