(load "./common.scm")

;; Check whether one id (as a string) is invalid or not
(define is-invalid-id
  (lambda (id)
    (let ([len (string-length id)])
      (if (= (modulo len 2) 1) #f
          (let ([half (/ len 2)])
            (string=? (substring id 0 half) (substring id half)))))))

;; Take a list of IDs (as numbers) and sum together the invalid ones
(define sum-invalids
  (lambda (ids)
    (reduce + 0
            (map
             (lambda (item)
               (let ([invalid? (is-invalid-id (number->string item))])
                 (if invalid? item 0))) ids))))

;; Make a list numbers from start until end
;; (make-range 1 3 '()) -> (1 2 3)
(define make-range
  (lambda (start end list)
    (cond
     [(= start end) (cons end list)]
     [else (make-range start (- end 1) (cons end list))])))

;; Turn a dash-separated string range into a list of numbers
;; (range-to-list "123-125") -> (123 124 125)
(define range-to-list
  (lambda (range-string)
    (let* ([parts (string-split range-string #\-)]
           [start (string->number (car parts))]
           [end (string->number (cadr parts))])
           (make-range start end '()))))

;; Take a list of ranges in the form of "11-22,33-44,55-66"
;; and sum the invalid IDs together.
(define process-list-of-ranges
  (lambda (range-list)
    (let ([ranges (string-split range-list #\,)])
      (reduce + 0
              (map (lambda (range-string)
                     (sum-invalids (range-to-list range-string))) ranges)))))

(let ([range-list (car (read-file-lines "day02-input.txt"))])
  (let ([result (process-list-of-ranges range-list)])
    (write-line (string-append "Sum of invalid IDs: " (number->string result)))))
