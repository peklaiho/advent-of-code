(load "day13-funcs.scm")

;; found some test-cases on reddit:
;; https://www.reddit.com/r/adventofcode/comments/zm20vb/2022_day_13_part_1_i_think_i_got_it_right_but_i/

(define test-pair
  (lambda (pair)
    (let ([expected (caddr pair)]
          [result (compare-pair pair)])
      (simple-format #t "Pair: ~A, Result: ~A, Expected: ~A\n"
                     pair result expected)
      (when (not (= result expected))
        (simple-format #t "ERROR\n")))))

(let* ([pairs (group-strings-by-delimiter (read-file-lines "day13-testing.txt") "" '() '())])
  (map test-pair pairs))
