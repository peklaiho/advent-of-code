(load "./common.scm")

;; Return the value from grid by row/col
(define grid-ref
  (lambda (grid row col)
    (list-ref (list-ref grid row) col)))

;; Same as grid-ref, but return zero if out of bounds
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

;; Lets map @ to 1 and . to 0, because we like working with ones and zeroes
(define prepare-grid
  (lambda (raw-input)
    (map (lambda (row)
           (map (lambda (ch)
                  (if (char=? ch #\.) 0 1))
                (string->list row))) raw-input)))

(let ([grid (prepare-grid (read-file-lines "day04-sample.txt"))])
  (count-neighbors grid 0 2))
