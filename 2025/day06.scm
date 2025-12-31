(load "./common.scm")

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
