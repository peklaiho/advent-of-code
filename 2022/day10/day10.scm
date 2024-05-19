(load "../common.scm")

(define x 1)
(define x-values '())

(define record-x
  (lambda ()
    (set! x-values (cons x x-values))))

(define add-to-x
  (lambda (y)
    (set! x (+ x y))))

(define cmd-noop
  (lambda ()
    (record-x)))

(define cmd-addx
  (lambda (num)
    (record-x)
    (record-x)
    (add-to-x num)))

(define parse-line
  (lambda (line)
    (cond
     [(string=? line "noop") (cmd-noop)]
     [else (cmd-addx (string->number (substring line 5)))])))

(define get-result-vector
  (lambda ()
    (list->vector (reverse x-values))))

(map parse-line (read-file-lines "day10.txt"))
(define result (get-result-vector))

(define get-result-for-index
  (lambda (ind)
    (* ind (vector-ref result (1- ind)))))

(simple-format #t "Result for part1: ~A\n"
               (apply + (map (lambda (i)
                               (get-result-for-index i))
                             '(20 60 100 140 180 220))))

(define draw-pixel
  (lambda (n)
    (let ((x-val (vector-ref result n))
          (m (modulo n 40)))
      (and (>= m (1- x-val)) (<= m (1+ x-val))))))

(simple-format #t "Length of results: ~A\nPart 2:\n" (vector-length result))

(do ((i 0 (1+ i)))
    ((>= i (vector-length result)))
  (simple-format #t "~A~A" (if (draw-pixel i) #\# #\.)
                 (if (zero? (modulo (1+ i) 40)) "\n" "")))
