(load "../common.scm")

(use-modules (ice-9 string-fun))

(define-inlinable (one? i) (= i 1))

(define parse-string
  (lambda (s)
    (call-with-input-string (string-replace-substring s "," " ")
                            (lambda (p)
                              (read p)))))

;; this is from day1.scm
(define group-strings-by-delimiter
  (lambda (ls delim cur res)
    (cond
     [(null? ls) (reverse (cons (reverse cur) res))]
     [(string=? (car ls) delim)
      (group-strings-by-delimiter (cdr ls) delim '() (cons (reverse cur) res))]
     [else
      (group-strings-by-delimiter (cdr ls) delim (cons (parse-string (car ls)) cur) res)])))

(define-inlinable (compare-integers left right)
  (cond
   [(< left right) 1]
   [(> left right) -1]
   [else 0]))

(define compare-values
  (lambda (left right)
    (cond
     [(and (list? left) (list? right))
      (compare-lists left right)]
     [(list? left)
      (compare-lists left (list right))]
     [(list? right)
      (compare-lists (list left) right)]
     [else
      (compare-integers left right)])))

(define compare-lists
  (lambda (left right)
    (cond
     ;; both lists empty
     [(and (null? left) (null? right)) 0]
     ;; left runs out of items
     [(null? left) 1]
     ;; right runs out of items
     [(null? right) -1]
     [else (let ([result (compare-values (car left) (car right))])
             (if (zero? result) (compare-lists (cdr left) (cdr right)) result))])))

(define compare-pair
  (lambda (pair)
    (let ([left (car pair)]
          [right (cadr pair)])
      (let ([result (compare-lists left right)])
        ;; (simple-format #t "Left: ~A, Right: ~A, Result: ~A\n" left right result)
        result))))

(define find-indexes
  (lambda (ls ind res)
    (cond
     [(null? ls) (reverse res)]
     [(one? (car ls)) (find-indexes (cdr ls) (1+ ind) (cons ind res))]
     [else (find-indexes (cdr ls) (1+ ind) res)])))
