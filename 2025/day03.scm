(load "./common.scm")

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

(define process-list-of-batteries
  (lambda (lst)
    (reduce + 0
            (map (lambda (battery)
                   (let ([best-pair (find-max-pair battery)])
                     ;; (write-line (string-append "Best pair for " battery ": " (number->string best-pair)))
                     best-pair))
                 lst))))

(let ([battery-list (read-file-lines "day03-input.txt")])
  (let ([result-one (process-list-of-batteries battery-list)])
    (write-line (string-append "Part1: " (number->string result-one)))))
