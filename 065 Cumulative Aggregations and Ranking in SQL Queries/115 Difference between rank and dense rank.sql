SELECT student_id,
    student_score,
    rank() OVER (ORDER BY student_score DESC) AS student_rank,
    dense_rank() OVER (ORDER BY student_score DESC) AS student_drank
FROM student_scores
ORDER BY student_score DESC;