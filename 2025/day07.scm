(load "./common.scm")

;;; Part 1

;; Find indexes of splitters for a single row
(define (find-splitters row ind result)
  (cond
   [(>= ind (string-length row)) (reverse result)]
   [else (let ([is-splitter (char=? (string-ref row ind) #\^)])
           (find-splitters row (+ ind 1) (if is-splitter (cons ind result) result)))]))

;; Find indexes of splitters for all rows
(define (find-all-splitters rows)
  (map (lambda (row) (find-splitters row 0 '())) rows))

;; Find the index of the start (S character)
(define (find-start row)
  (string-index row #\S))

;; Add new indexes to beams, but avoid duplicates
(define (add-to-beams beams new-indexes)
  (cond
   [(null? new-indexes) beams]
   [else (let ([ind (car new-indexes)])
           (add-to-beams (if (or (< ind 0) (memv ind beams)) beams (cons ind beams)) (cdr new-indexes)))]))

(define (perform-process-step beams splitters new-beams splits)
  (cond
   [(null? beams) (cons (sort new-beams <) splits)]
   [else (let* ([ind (car beams)]
                [match (memv ind splitters)])
           (perform-process-step (cdr beams) splitters
                                 (add-to-beams new-beams (if match (list (- ind 1) (+ ind 1)) (list ind)))
                                 (+ splits (if match 1 0))))]))

;; Process a single step:
;; - Take list of beam indexes
;; - Take list of splitter indexes
;; - Return (new-beam-indexes . number-of-splits)
(define (process-step beams splitters)
  (perform-process-step beams splitters '() 0))

(define (process-all-steps beams splitters total-splits)
  (cond
   [(null? splitters) total-splits]
   [else (let ([result (process-step beams (car splitters))])
           (process-all-steps (car result) (cdr splitters) (+ total-splits (cdr result))))]))

(let* ([rows (read-file-lines "day07-input.txt")]
       [beams (list (find-start (car rows)))]
       [splitters (find-all-splitters (cdr rows))]
       [result-one (process-all-steps beams splitters 0)])
  (simple-format #t "Result for part 1: ~A\n" result-one))
