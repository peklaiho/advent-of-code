(load "./common.scm")

(define split-after-first-char
  (lambda (line)
    (cons (substring line 0 1) (string->number (substring line 1)))))

(define apply-left
  (lambda (val1 val2)
    (modulo (+ (modulo (- val1 val2) 100) 100) 100)))

(define apply-right
  (lambda (val1 val2)
    (modulo (+ val1 val2) 100)))

(define apply-rotation
  (lambda (initial-value rotation)
    (let ([val (cdr rotation)])
      (if (string=? (car rotation) "L")
          (apply-left initial-value val)
          (apply-right initial-value val)))))

(define crossings-left
  (lambda (val1 val2)
    (let ([result (- val1 val2)])
      (if (> result 0) 0
          (+ (if (= val1 0) 0 1) (quotient (- 0 result) 100))))))

(define crossings-right
  (lambda (val1 val2)
    (let ([result (+ val1 val2)])
      (if (< result 100) 0
          (+ 1 (quotient (- result 100) 100))))))

(define count-crossings
  (lambda (initial-value rotation)
    (let ([val (cdr rotation)])
      (if (string=? (car rotation) "L")
          (crossings-left initial-value val)
          (crossings-right initial-value val)))))

(define rotation-to-string
  (lambda (rotation)
    (string-append "(" (car rotation) " " (number->string (cdr rotation)) ")")))

(define count-zeroes
  (lambda (sequence value zeroes crossings)
    (cond
     [(null? sequence) (cons zeroes crossings)]
     [else (let* ([result (apply-rotation value (car sequence))]
                  [new-zeroes (if (= result 0) (+ zeroes 1) zeroes)]
                  [new-crossings (+ crossings (count-crossings value (car sequence)))])
             ;; (write-line (string-append "After rotation " (rotation-to-string (car sequence))
             ;;                            " value is " (number->string result)
             ;;                            " and we have " (number->string new-zeroes)
             ;;                            " zeroes and " (number->string new-crossings)
             ;;                            " crossings."))
             (count-zeroes (cdr sequence) result new-zeroes new-crossings))])))

(let* ([sequence (map split-after-first-char (read-file-lines "day01-input.txt"))]
       [result (count-zeroes sequence 50 0 0)])
  (write-line (string-append "Total number of zeroes: " (number->string (car result))))
  (write-line (string-append "Total number of crossings: " (number->string (cdr result)))))
