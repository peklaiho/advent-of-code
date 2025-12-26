(load "./common.scm")

;; Return the value from grid by row/col
;; Return zero if out of bounds
(define grid-ref-check-bounds
  (lambda (grid row col)
    (cond
     [(or (< row 0) (>= row (length grid)) (< col 0)) 0]
     [else
      (let ([grid-row (list-ref grid row)])
        (cond
         [(>= col (length grid-row)) 0]
         [else (list-ref grid-row col)]))])))

;; Count how many neighboring ones this location has
(define count-neighbors
  (lambda (grid y x)
    (+
     (grid-ref-check-bounds grid (- y 1) (- x 1))
     (grid-ref-check-bounds grid (- y 1) x)
     (grid-ref-check-bounds grid (- y 1) (+ x 1))
     (grid-ref-check-bounds grid y (- x 1))
     (grid-ref-check-bounds grid y (+ x 1))
     (grid-ref-check-bounds grid (+ y 1) (- x 1))
     (grid-ref-check-bounds grid (+ y 1) x)
     (grid-ref-check-bounds grid (+ y 1) (+ x 1)))))

;; Return 1 for valid cell, otherwise 0
(define is-valid-cell
  (lambda (grid y x)
    (if (and (= (grid-ref-check-bounds grid y x) 1)
             (< (count-neighbors grid y x) 4)) 1 0)))

(define process-grid
  (lambda (grid)
    (let* ([rows (length grid)]
           [cols (length (car grid))]
           [coords (make-coordinate-list rows cols)])
      (map (lambda (yx)
             (let* ([y (car yx)]
                    [x (cadr yx)]
                    [result (is-valid-cell grid y x)])
               ;; (write-line (string-append "Result for " (number->string y) ", "
               ;;                            (number->string x) ": " (number->string result)))
               result))
             coords))))

;; Lets map @ to 1 and . to 0, because we like working with ones and zeroes
(define prepare-grid
  (lambda (raw-input)
    (map (lambda (row)
           (map (lambda (ch)
                  (if (char=? ch #\.) 0 1))
                (string->list row))) raw-input)))

(let* ([grid (prepare-grid (read-file-lines "day04-input.txt"))]
       [result (reduce + 0 (process-grid grid))])
  (write-line (string-append "Result for Part 1: " (number->string result))))
