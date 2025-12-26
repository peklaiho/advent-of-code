(load "./common.scm")

;; ------
;; Part 1
;; ------

(define find-max-pair-helper
  (lambda (lst best-pair previous-max)
    (cond
     [(null? lst) best-pair]
     [else
      (let* ([current (string->number (string (car lst)))]
             [candidate (if (>= previous-max 0)
                            (+ (* current 10) previous-max)
                            -1)]
             [new-best (if (> candidate best-pair)
                           candidate
                           best-pair)]
             [new-prev-max (if (> current previous-max)
                               current
                               previous-max)])
        (find-max-pair-helper (cdr lst) new-best new-prev-max))])))

(define find-max-pair
  (lambda (battery)
    (find-max-pair-helper (reverse (string->list battery)) -1 -1)))

;; ------
;; Part 2
;; ------

(define find-largest-12-helper
  (lambda (lst stack remove)
    (cond
     [(null? lst) (list-head (reverse stack) 12)]
     [else
      (let ([current (string->number (string (car lst)))])
        (cond
         [(and (> remove 0) (> (length stack) 0) (< (car stack) current))
          (find-largest-12-helper lst (cdr stack) (- remove 1))]
         [else
          (find-largest-12-helper (cdr lst) (cons current stack) remove)]))])))

(define find-largest-12
  (lambda (battery)
    (let ([result (find-largest-12-helper (string->list battery) '() (- (string-length battery) 12))])
      (number-list-to-number result))))

;; ------
;; Common
;; ------

(define process-list-of-batteries
  (lambda (lst test-fn)
    (reduce + 0
            (map (lambda (battery)
                   (let ([result (test-fn battery)])
                     ;; (write-line (string-append "Result for " battery ": " (number->string result)))
                     result))
                 lst))))

(let ([battery-list (read-file-lines "day03-input.txt")])
  (let ([result-one (process-list-of-batteries battery-list find-max-pair)]
        [result-two (process-list-of-batteries battery-list find-largest-12)])
    (write-line (string-append "Part1: " (number->string result-one)))
    (write-line (string-append "Part2: " (number->string result-two)))))
