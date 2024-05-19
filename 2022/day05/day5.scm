(load "../common.scm")

(define get-initial-stacks
  (lambda ()
    (vector
     (list #\N #\R #\J #\T #\Z #\B #\D #\F)
     (list             #\H #\J #\N #\S #\R)
     (list #\Q #\F #\Z #\G #\J #\N #\R #\C)
     (list     #\Q #\T #\R #\G #\N #\V #\F)
     (list                 #\F #\Q #\T #\L)
     (list #\N #\G #\R #\B #\Z #\W #\C #\Q)
     (list     #\M #\H #\N #\S #\L #\C #\F)
     (list         #\J #\T #\M #\Q #\N #\D)
     (list                     #\S #\G #\P))))

(define stacks (get-initial-stacks))

(define parse-move-line
  (lambda (line)
    (let ([words (string-split line #\space)])
      (list (1- (string->number (list-ref words 3)))
            (1- (string->number (list-ref words 5)))
            (string->number (list-ref words 1))))))

(define moves
  (map parse-move-line (read-file-lines "day5-moves.txt")))

(define pop-from-stack
  (lambda (index)
    (let* ([stack (vector-ref stacks index)]
           [result (car stack)])
      (vector-set! stacks index (cdr stack))
      result)))

(define push-in-stack
  (lambda (index val)
    (let ([stack (vector-ref stacks index)])
      (vector-set! stacks index (cons val stack))
      val)))

(define move-one
  (lambda (from to)
    (push-in-stack to (pop-from-stack from))))

(define move-many
  (lambda (from to count)
    (do ((i 0 (1+ i)))
        ((>= i count))
      (move-one from to))))

(define get-stack-tops
  (lambda ()
    (list (car (vector-ref stacks 0))
          (car (vector-ref stacks 1))
          (car (vector-ref stacks 2))
          (car (vector-ref stacks 3))
          (car (vector-ref stacks 4))
          (car (vector-ref stacks 5))
          (car (vector-ref stacks 6))
          (car (vector-ref stacks 7))
          (car (vector-ref stacks 8)))))

(simple-format #t "Part 1: Top of stacks at start: ~A\n" (get-stack-tops))
(map (lambda (move) (move-many (car move) (cadr move) (caddr move)))  moves)
(simple-format #t "Part 1: Top of stacks after moves: ~A\n" (get-stack-tops))

;;
;; ---------------------------------------------------------------------------
;;

(define move-many-in-order
  (lambda (from to count)
    (let* ([stack-from (vector-ref stacks from)]
           [stack-to (vector-ref stacks to)]
           [values (list-head stack-from count)])
      (vector-set! stacks from (list-tail stack-from count))
      (vector-set! stacks to (append values stack-to))
      values)))

(set! stacks (get-initial-stacks))

(simple-format #t "Part 2: Top of stacks at start: ~A\n" (get-stack-tops))
(map (lambda (move) (move-many-in-order (car move) (cadr move) (caddr move)))  moves)
(simple-format #t "Part 2: Top of stacks after moves: ~A\n" (get-stack-tops))
