(load "./common.scm")

(define debug #f)

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

;; Return 1 for cell to be removed, otherwise 0
(define remove-cell?
  (lambda (grid y x)
    (if (and (= (grid-ref-check-bounds grid y x) 1)
             (< (count-neighbors grid y x) 4)) 1 0)))

;; Copy a grid by copying all rows
(define copy-grid
  (lambda (grid)
    (map (lambda (row)
           (list-copy row)) grid)))

;; Set the given cell to zero
(define remove-cell!
  (lambda (grid y x)
    (let ([row (list-ref grid y)])
      (list-set! row x 0))))

;; Print the grid
(define print-grid
  (lambda (grid)
    (for-each (lambda (row)
                (write-line (string-append
                             (list->string
                              (map (lambda (val)
                                     (if (= val 1) #\@ #\.))
                                   row))))) grid)
    (newline)))

;; Returns list of two objects:
;; - new grid after removals
;; - count of removed items
(define process-grid
  (lambda (grid)
    (let* ([rows (length grid)]
           [cols (length (car grid))]
           [coords (make-coordinate-list rows cols)]
           [new-grid (copy-grid grid)])
      (let ([removed-count
             (reduce + 0
                     (map (lambda (yx)
                            (let* ([y (car yx)]
                                   [x (cadr yx)]
                                   [remove (remove-cell? grid y x)])
                              ;; (simple-format #t "Remove cell (~A/~A): ~A\n" y x remove)
                              (when (= remove 1)
                                (remove-cell! new-grid y x))
                              remove))
                          coords))])
        (list new-grid removed-count)))))

;; Perform multiple steps of removals
(define perform-removals
  (lambda (grid removed-count)
    (let* ([result (process-grid grid)]
           [new-grid (car result)]
           [new-removed (cadr result)])
      (when debug
        (simple-format #t "Removed ~A rolls of paper:\n" new-removed)
        (print-grid new-grid))
      (if (= new-removed 0) removed-count
          (perform-removals new-grid (+ removed-count new-removed))))))

;; Lets map @ to 1 and . to 0, because we like working with ones and zeroes
(define prepare-grid
  (lambda (raw-input)
    (map (lambda (row)
           (map (lambda (ch)
                  (if (char=? ch #\.) 0 1))
                (string->list row))) raw-input)))

(let ([grid (prepare-grid (read-file-lines "day04-input.txt"))])
  (when debug
    (write-line "Initial state:")
    (print-grid grid))
  (let ([total-removed (perform-removals grid 0)])
    (simple-format #t "Total removed: ~A\n" total-removed)))
