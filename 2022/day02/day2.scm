(load "../common.scm")

(define make-strategy-pairs
  (lambda (ls delim res)
    (cond
     [(null? ls) res]
     [else
      (let ([pair (cons (string-ref (car ls) 0) (string-ref (car ls) 2))])
        (make-strategy-pairs (cdr ls) delim (cons pair res)))])))

(define pair-to-score
  (lambda (pair)
    (cond
     [(and (char=? (car pair) #\A) (char=? (cdr pair) #\X)) 4] ;; rock - rock: draw
     [(and (char=? (car pair) #\A) (char=? (cdr pair) #\Y)) 8] ;; rock - paper: win
     [(and (char=? (car pair) #\A) (char=? (cdr pair) #\Z)) 3] ;; rock - scissors: lose
     [(and (char=? (car pair) #\B) (char=? (cdr pair) #\X)) 1] ;; paper - rock: lose
     [(and (char=? (car pair) #\B) (char=? (cdr pair) #\Y)) 5] ;; paper - paper: draw
     [(and (char=? (car pair) #\B) (char=? (cdr pair) #\Z)) 9] ;; paper - scissors: win
     [(and (char=? (car pair) #\C) (char=? (cdr pair) #\X)) 7] ;; scissors - rock: win
     [(and (char=? (car pair) #\C) (char=? (cdr pair) #\Y)) 2] ;; scissors - paper: lose
     [(and (char=? (car pair) #\C) (char=? (cdr pair) #\Z)) 6] ;; scissors - scissors: draw
     [else (error "Unknown values in pair")])))

(define pair-to-score-2
  (lambda (pair)
    (cond
     [(and (char=? (car pair) #\A) (char=? (cdr pair) #\X)) 3] ;; rock - lose: scissors
     [(and (char=? (car pair) #\A) (char=? (cdr pair) #\Y)) 4] ;; rock - draw: rock
     [(and (char=? (car pair) #\A) (char=? (cdr pair) #\Z)) 8] ;; rock - win: paper
     [(and (char=? (car pair) #\B) (char=? (cdr pair) #\X)) 1] ;; paper - lose: rock
     [(and (char=? (car pair) #\B) (char=? (cdr pair) #\Y)) 5] ;; paper - draw: paper
     [(and (char=? (car pair) #\B) (char=? (cdr pair) #\Z)) 9] ;; paper - win: scissors
     [(and (char=? (car pair) #\C) (char=? (cdr pair) #\X)) 2] ;; scissors - lose: paper
     [(and (char=? (car pair) #\C) (char=? (cdr pair) #\Y)) 6] ;; scissors - draw: scissors
     [(and (char=? (car pair) #\C) (char=? (cdr pair) #\Z)) 7] ;; scissors - win: rock
     [else (error "Unknown values in pair")])))

(let ([strategy (reverse (make-strategy-pairs (read-file-lines "day2.txt") " " '()))])
  (simple-format #t "Part 1: Total score: ~A\n" (apply + (map pair-to-score strategy)))
  (simple-format #t "Part 2: Total score: ~A\n" (apply + (map pair-to-score-2 strategy))))

