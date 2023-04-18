CREATE TABLE student_scores (
    student_id INT PRIMARY KEY,
    student_score INT
);

INSERT INTO student_scores VALUES
(1, 980),
(2, 960),
(3, 960),
(4, 990),
(5, 920),
(6, 960),
(7, 980),
(8, 960),
(9, 940),
(10, 940);

SELECT * FROM student_scores
ORDER BY student_score DESC;

SELECT student_id,
    student_score,
    rank() OVER (ORDER BY student_score DESC) AS student_rank,
    dense_rank() OVER (ORDER BY student_score DESC) AS student_drank
FROM student_scores
ORDER BY student_score DESC;