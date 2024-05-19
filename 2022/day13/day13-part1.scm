(load "day13-funcs.scm")

(let* ([pairs (group-strings-by-delimiter (read-file-lines "day13.txt") "" '() '())]
       [result (map compare-pair pairs)]
       [indexes (find-indexes result 1 (list))])
  (simple-format #t "Result: ~A\n" result)
  (simple-format #t "Indexes with correct order: ~A\n" indexes)
  (simple-format #t "Sum of correct indexes: ~A\n" (apply + indexes)))
