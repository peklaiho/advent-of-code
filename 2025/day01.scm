(load "./common.scm")

(define split-after-first-char
  (lambda (line)
    (cons (substring line 0 1) (cons (string->number (substring line 1)) '()))))

(define apply-left
  (lambda (val1 val2)
    (let ([res (- val1 val2)])
      (if (< res 0) (+ res 100) res))))

(define apply-right
  (lambda (val1 val2)
    (let ([res (+ val1 val2)])
      (if (> res 99) (- res 100) res))))

(define apply-rotation
  (lambda (initial-value rotation)
    (let ([val (cadr rotation)])
      (if (string=? (car rotation) "L")
          (apply-left initial-value val)
          (apply-right initial-value val)))))

(let ([lines (read-file-lines "day01-sample.txt")])
  (map write-line (map split-after-first-char lines)))

(write-line (apply-rotation 98 '("R" 1)))
(write-line (apply-rotation 99 '("R" 1)))
(write-line (apply-rotation 99 '("R" 2)))
(write-line (apply-rotation 2 '("L" 1)))
(write-line (apply-rotation 1 '("L" 1)))
(write-line (apply-rotation 0 '("L" 1)))
(write-line (apply-rotation 0 '("L" 2)))
