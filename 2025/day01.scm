(load "./common.scm")

(define split-after-first-char
  (lambda (line)
    (cons (substring line 0 1) (cons (string->number (substring line 1)) '()))))

(define apply-left
  (lambda (val1 val2)
    (modulo (+ (modulo (- val1 val2) 100) 100) 100)))

(define apply-right
  (lambda (val1 val2)
    (modulo (+ val1 val2) 100)))

(define apply-rotation
  (lambda (initial-value rotation)
    (let ([val (cadr rotation)])
      (if (string=? (car rotation) "L")
          (apply-left initial-value val)
          (apply-right initial-value val)))))

(define rotation-to-string
  (lambda (rotation)
    (string-append "(" (car rotation) " " (number->string (cadr rotation)) ")")))

(define count-zeroes
  (lambda (sequence value zeroes)
    (cond
     [(null? sequence) zeroes]
     [else (let* ([result (apply-rotation value (car sequence))]
                  [new-zeroes (if (= result 0) (+ zeroes 1) zeroes)])
             ;; (write-line (string-append "After rotation " (rotation-to-string (car sequence))
             ;;                            " value is " (number->string result)
             ;;                            " and we have " (number->string new-zeroes) " zeroes."))
             (count-zeroes (cdr sequence) result new-zeroes))])))

(let* ([sequence (map split-after-first-char (read-file-lines "day01-input.txt"))]
       [zeroes (count-zeroes sequence 50 0)])
  (write-line (string-append "Total number of zeroes: " (number->string zeroes))))
