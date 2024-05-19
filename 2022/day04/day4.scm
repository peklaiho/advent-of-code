(load "../common.scm")

(define process-lines
  (lambda (lines)
    (map (lambda (line)
           (let ([pairs (string-split line #\,)])
             (list (string-split (car pairs) #\-) (string-split (cadr pairs) #\-))))
         lines)))

(define is-fully-contained
  (lambda (p1 p2)
    (let ([p1min (string->number (car p1))]
          [p1max (string->number (cadr p1))]
          [p2min (string->number (car p2))]
          [p2max (string->number (cadr p2))])
      (cond
       [(and (<= p1min p2min) (>= p1max p2max)) 1]
       [(and (<= p2min p1min) (>= p2max p1max)) 1]
       [else 0]))))

(define is-overlapping
  (lambda (p1 p2)
    (let ([p1min (string->number (car p1))]
          [p1max (string->number (cadr p1))]
          [p2min (string->number (car p2))]
          [p2max (string->number (cadr p2))])
      (cond
       [(<= (max p1min p2min) (min p1max p2max)) 1]
       [else 0]))))

(define check-ranges
  (lambda (ranges fn)
    (map (lambda (range)
           (fn (car range) (cadr range)))
         ranges)))

(let ([ranges (process-lines (read-file-lines "day4.txt"))])
  (simple-format #t "Part 1: Count of ranges that fully contain each other: ~A\n" (apply + (check-ranges ranges is-fully-contained)))
  (simple-format #t "Part 2: Count of overlapping ranges: ~A\n" (apply + (check-ranges ranges is-overlapping))))

