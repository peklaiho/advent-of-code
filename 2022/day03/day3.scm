(load "../common.scm")

(define convert-to-integer
  (lambda (c)
    (if (char<? c #\a)
        (- (char->integer c) 38)
        (- (char->integer c) 96))))

(define string-to-int-list
  (lambda (s)
    (map convert-to-integer (string->list s))))

(define list-contains?
  (lambda (ls val)
    (cond
     [(null? ls) #f]
     [(= (car ls) val) #t]
     [else (list-contains? (cdr ls) val)])))

(define find-same-value
  (lambda (ls1 ls2)
    (cond
     [(null? ls1) (error "No same value in 2 lists")]
     [(list-contains? ls2 (car ls1)) (car ls1)]
     [else (find-same-value (cdr ls1) ls2)])))

(define find-same-value-in-3
  (lambda (ls1 ls2 ls3)
    (cond
     [(null? ls1) (error "No same value in 3 lists")]
     [(and (list-contains? ls2 (car ls1)) (list-contains? ls3 (car ls1))) (car ls1)]
     [else (find-same-value-in-3 (cdr ls1) ls2 ls3)])))

(define process-rucksack
  (lambda (sack)
    (let* ([halflen (/ (string-length sack) 2)]
           [ls1 (string-to-int-list (substring sack 0 halflen))]
           [ls2 (string-to-int-list (substring sack halflen))])
      (find-same-value ls1 ls2))))

(define process-group
  (lambda (group)
    (find-same-value-in-3 (car group) (cadr group) (caddr group))))

(define group-rucksacks-rec
  (lambda (sacks res)
    (cond
     [(null? sacks) res]
     [else (group-rucksacks-rec (cdddr sacks) (cons (list-head sacks 3) res))])))

(define group-rucksacks
  (lambda (sacks)
    (reverse (map (lambda (three) (map string-to-int-list three))
                  (group-rucksacks-rec sacks '())))))

(let ([rucksacks (read-file-lines "day3.txt")])
  (simple-format #t "Part 1: Sum of priorities of common items in all rucksacks: ~A\n" (apply + (map process-rucksack rucksacks)))
  (let ([groups (group-rucksacks rucksacks)])
    (simple-format #t "Part 2: Sum of priorities of badge items for groups of 3 rucksacks: ~A\n" (apply + (map process-group groups)))))

