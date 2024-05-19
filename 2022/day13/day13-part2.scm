(load "day13-funcs.scm")

(define not-empty-string
  (lambda (s)
    (not (string=? s ""))))

(define comp-vals
  (lambda (x y)
    (let ([result (compare-lists x y)])
      (if (= result 1) #t #f))))

(define add-special-packets
  (lambda (ls)
    (cons '((2)) (cons '((6)) ls))))

(define index-of
  (lambda (ls a)
    (let ([res (member a ls)])
      (1+ (- (length ls) (length res))))))

(let* ([packets (map parse-string (filter not-empty-string (read-file-lines "day13.txt")))]
       [with-spec (add-special-packets packets)]
       [sorted (sort-list with-spec comp-vals)]
       [ind-a (index-of sorted '((2)))]
       [ind-b (index-of sorted '((6)))])
  (simple-format #t "Indexes: ~A ~A\n" ind-a ind-b)
  (simple-format #t "Multiplied: ~A\n" (* ind-a ind-b)))

