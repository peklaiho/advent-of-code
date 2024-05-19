(load "../common.scm")

(define root-dir (make-hash-table))
(define current-dir '())

(define get-dir
  (lambda (ht names)
    ;; (simple-format #t "Get dir: ~S ~S\n" ht names)
    (cond
     [(null? names) ht]
     [else (get-dir (hash-ref ht (car names)) (cdr names))])))

(define get-current-dir
  (lambda ()
    (get-dir root-dir (reverse current-dir))))

(define get-dir-size
  (lambda (ht rec)
    (apply +
           (hash-map->list
            (lambda (key val)
              (cond
               [(hash-table? val) (if rec (get-dir-size val rec) 0)]
               [else val])) ht))))

(define get-current-dir-size
  (lambda (rec)
    (get-dir-size (get-current-dir) rec)))

(define get-subdirs-size-p
  (lambda (ht p)
    (apply +
           (hash-map->list
            (lambda (key val)
              (cond
               [(hash-table? val)
                (+ (let ((size (get-dir-size val #t)))
                     (if (p size) size 0))
                   (get-subdirs-size-p val p))]
               [else 0])) ht))))

(define get-part1-answer
  (lambda ()
    (let ((p (lambda (size) (<= size 100000))))
      (+ (get-subdirs-size-p root-dir p)
         (let ((root-size (get-dir-size root-dir #t)))
           (if (p root-size) root-size 0))))))

(define change-dir
  (lambda (dir)
    ;; (simple-format #t "Current: ~S, Change dir: ~S\n" current-dir dir)
    (cond
     [(string=? dir "/") (set! current-dir '())]
     [(string=? dir "..") (set! current-dir (cdr current-dir))]
     [else (set! current-dir (cons dir current-dir))])))

(define list-files
  (lambda () #t))

(define add-directory
  (lambda (name)
    ;; (simple-format #t "Current: ~S, Add dir: ~S\n" current-dir name)
    (hash-set! (get-current-dir) name (make-hash-table))))

(define add-file
  (lambda (size name)
    ;; (simple-format #t "Current: ~S, Add file: ~S ~S\n" current-dir name size)
    (hash-set! (get-current-dir) name size)))

(define parse-cmd
  (lambda (cmd)
    (cond
     [(string=? (substring cmd 0 2) "cd") (change-dir (substring cmd 3))]
     [(string=? (substring cmd 0 2) "ls") (list-files)]
     [else (error "Unknown command")])))

(define parse-line
  (lambda (line)
    (cond
     [(char=? (string-ref line 0) #\$) (parse-cmd (substring line 2))]
     [(string=? (substring line 0 3) "dir") (add-directory (substring line 4))]
     [else (let ([space (string-index line #\space)])
             (add-file (string->number (substring line 0 space))
                       (substring line (1+ space))))])))

;; Run with example data
(map parse-line (read-file-lines "day7.txt"))

(simple-format #t "Recursive root size: ~S\n" (get-dir-size root-dir #t))
(simple-format #t "Non-recursive root size: ~S\n" (get-dir-size root-dir #f))
(simple-format #t "Part 1 answer: ~S\n" (get-part1-answer))
