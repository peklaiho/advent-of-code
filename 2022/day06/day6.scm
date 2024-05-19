(load "../common.scm")

(define uniq-members?
  (lambda (ls)
    (cond
     [(null? ls) #t]
     [(memv (car ls) (cdr ls)) #f]
     [else (uniq-members? (cdr ls))])))

(define uniq-chars?
  (lambda (str)
    (uniq-members? (string->list str))))

(define index-of-min-uniq-chars
  (lambda (ls cnt idx)
    (cond
     [(< (length ls) cnt) #f]
     [(uniq-members? (list-head ls cnt)) idx]
     [else (index-of-min-uniq-chars (cdr ls) cnt (1+ idx))])))

(define solve-day6
  (lambda (str cnt)
    (+ (index-of-min-uniq-chars (string->list str) cnt 0) cnt)))

(let ([input (read-file-lines "day6.txt")])
  (simple-format #t "Part 1: Number of characters processed before start-of-packet marker: ~A\n" (solve-day6 (car input) 4))
  (simple-format #t "Part 2: Number of characters processed before start-of-message marker: ~A\n" (solve-day6 (car input) 14)))
