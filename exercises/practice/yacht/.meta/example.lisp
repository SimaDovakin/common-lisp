(defpackage :yacht
  (:use :cl)
  (:export :score))
(in-package :yacht)

(defun hash-values (ht)
  (let ((vals '()))
    (progn
      (loop for v being each hash-value of ht do (setf vals (cons v vals)))
      vals)))

(defun frequencies (sequence)
  (let ((occurences (make-hash-table)))
    (reduce (lambda (acc n)
                (let ((freq (gethash n acc)))
                  (if freq
                      (progn
                        (setf (gethash n acc) (+ freq 1))
                        acc
                      )
                      (progn
                        (setf (gethash n acc) 1))))
                        acc)
            sequence
            :initial-value occurences)))

(defun full-house? (scores)
  (let* ((occurences (frequencies scores))
         (vals (hash-values occurences)))
        (equal '(2 3) (sort vals #'<))))

(defun four-of-a-king-dice (occurences)
  (let ((pair nil))
    (maphash (lambda (key val)
              (if (>= val 4)
                  (setf pair key)))
             occurences)
    pair))

(defun score (scores category)
  "Returns the score of the dice for the given category."
  (cond ((equal category "ones") (count 1 scores))
        ((equal category "twos") (* 2 (count 2 scores)))
        ((equal category "threes") (* 3 (count 3 scores)))
        ((equal category "fours") (* 4 (count 4 scores)))
        ((equal category "fives") (* 5 (count 5 scores)))
        ((equal category "sixes") (* 6 (count 6 scores)))
        ((equal category "full house") (if (full-house? scores)
                                           (reduce '+ scores)
                                           0))
        ((equal category "four of a kind") (let ((dice (four-of-a-king-dice (frequencies scores))))
                                                (if dice (* 4 dice) 0)))
        ((equal category "little straight") (if (equal '(1 2 3 4 5) (sort scores #'<))
                                                30
                                                0))
        ((equal category "big straight") (if (equal '(2 3 4 5 6) (sort scores #'<))
                                             30
                                             0))
        ((equal category "choice") (reduce '+ scores))
        ((equal category "yacht") (if (= 1 (hash-table-count (frequencies scores)))
                                      50
                                      0))
        (t 0)))
