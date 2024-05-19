(load "../common.scm")

(define group-strings-by-delimiter
  (lambda (ls delim cur res)
    (cond
     [(null? ls) (reverse (cons (reverse cur) res))]
     [(string=? (car ls) delim)
      (group-strings-by-delimiter (cdr ls) delim '() (cons (reverse cur) res))]
     [else
      (group-strings-by-delimiter (cdr ls) delim (cons (car ls) cur) res)])))

(define calculate-group-sums
  (lambda (ls)
    (map
     (lambda (group)
       (apply + (map string->number group))) ls)))

(let ([calories (sort (calculate-group-sums (group-strings-by-delimiter (read-file-lines "day1.txt") "" '() '())) >)])
  (simple-format #t "Part 1: Most calories carried by single Elf: ~A\n" (car calories))
  (simple-format #t "Part 2: Total calories by 3 best Elves: ~A\n" (+ (car calories) (cadr calories) (caddr calories))))

