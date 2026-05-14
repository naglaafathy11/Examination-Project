USE Examnation_System;
GO

-------------------------------------------------------
-- FUNCTION 1: Get Letter Grade
-- Returns letter grade (A,B,C,D,F) based on obtained marks and max marks
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_GetLetterGrade
(
    @obtained  DECIMAL(5,2),
    @max_degree INT
)
RETURNS VARCHAR(2)
AS
BEGIN
    DECLARE @pct DECIMAL(5,2) = (@obtained * 100.0) / @max_degree
    RETURN CASE
        WHEN @pct >= 90 THEN 'A'
        WHEN @pct >= 75 THEN 'B'
        WHEN @pct >= 60 THEN 'C'
        WHEN @pct >= 50 THEN 'D'
        ELSE 'F'
    END
END
GO

-- Example usage: Get letter grades for all student exams
SELECT
    s.st_name,
    se.obtained_degree,
    e.total_degree,
    dbo.fn_GetLetterGrade(se.obtained_degree, e.total_degree) AS letter_grade
FROM student_exam se
JOIN students s ON s.st_id = se.st_id
JOIN exams e ON e.ex_id = se.ex_id;
GO

-------------------------------------------------------
-- FUNCTION 2: Pass or Fail
-- Returns 'PASSED' or 'FAILED' based on student's obtained marks and course passing mark
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_PassOrFail
(
    @st_id INT,
    @ex_id INT
)
RETURNS VARCHAR(6)
AS
BEGIN
    DECLARE @obtained DECIMAL(5,2)
    DECLARE @min_deg INT

    SELECT @obtained = se.obtained_degree,
           @min_deg  = c.min_degree
    FROM student_exam se
    JOIN exams e ON e.ex_id = se.ex_id
    JOIN courses c ON c.crs_id = e.crs_id
    WHERE se.st_id = @st_id AND se.ex_id = @ex_id

    RETURN CASE WHEN @obtained >= @min_deg THEN 'PASSED' ELSE 'FAILED' END
END
GO

-- Example usage: Check pass/fail for each student exam
SELECT
    s.st_name,
    e.ex_id,
    se.obtained_degree,
    dbo.fn_PassOrFail(s.st_id, e.ex_id) AS result
FROM student_exam se
JOIN students s ON s.st_id = se.st_id
JOIN exams e ON e.ex_id = se.ex_id;
GO

-------------------------------------------------------
-- FUNCTION 3: Count Correct Answers
-- Returns number of correct answers a student got in a specific exam
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_CountCorrectAnswers
(
    @st_id INT,
    @ex_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cnt INT
    SELECT @cnt = COUNT(*)
    FROM student_answers
    WHERE st_id = @st_id AND ex_id = @ex_id AND is_correct = 1
    RETURN ISNULL(@cnt, 0)
END
GO

-- Example usage: Count correct answers for a specific exam
SELECT
    s.st_name,
    dbo.fn_CountCorrectAnswers(s.st_id, se.ex_id) AS correct_answers,
    dbo.fn_CountExamQuestions(se.ex_id) AS total_questions
FROM student_exam se
JOIN students s ON s.st_id = se.st_id
WHERE se.ex_id = 3;
GO

-------------------------------------------------------
-- FUNCTION 4: Count Exam Questions
-- Returns total number of questions in an exam
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_CountExamQuestions
(
    @ex_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cnt INT
    SELECT @cnt = COUNT(*) 
    FROM exam_questions 
    WHERE ex_id = @ex_id
    RETURN ISNULL(@cnt, 0)
END
GO

-- Example usage: Get total questions for all exams
SELECT
    e.ex_id,
    c.crs_name,
    e.ex_date,
    dbo.fn_CountExamQuestions(e.ex_id) AS total_questions
FROM exams e
JOIN courses c ON c.crs_id = e.crs_id;
GO

-------------------------------------------------------
-- FUNCTION 5: Course Pass Rate
-- Returns percentage of students who passed a specific course
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_CoursePassRate
(
    @crs_id INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @total INT
    DECLARE @passed INT

    -- Total students who took this course
    SELECT @total = COUNT(*)
    FROM student_exam se
    JOIN exams e ON e.ex_id = se.ex_id
    WHERE e.crs_id = @crs_id

    -- Total students who passed
    SELECT @passed = COUNT(*)
    FROM student_exam se
    JOIN exams e ON e.ex_id = se.ex_id
    JOIN courses c ON c.crs_id = e.crs_id
    WHERE e.crs_id = @crs_id AND se.obtained_degree >= c.min_degree

    RETURN CASE WHEN @total = 0 THEN 0
                ELSE CAST(@passed * 100.0 / @total AS DECIMAL(5,2))
           END
END
GO

-- Example usage: Get pass rate for all courses
SELECT
    c.crs_id,
    c.crs_name,
    dbo.fn_CoursePassRate(c.crs_id) AS pass_rate_pct
FROM courses c
ORDER BY pass_rate_pct DESC;
GO

-------------------------------------------------------
-- FUNCTION 6: Exam Duration in Minutes
-- Returns exam duration in minutes
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_ExamDurationMinutes
(
    @ex_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @dur INT
    SELECT @dur = DATEDIFF(MINUTE, start_time, end_time)
    FROM exams 
    WHERE ex_id = @ex_id
    RETURN ISNULL(@dur, 0)
END
GO

-- Example usage: Get duration for all exams
SELECT
    e.ex_id,
    c.crs_name,
    e.start_time,
    e.end_time,
    dbo.fn_ExamDurationMinutes(e.ex_id) AS duration_minutes
FROM exams e
JOIN courses c ON c.crs_id = e.crs_id;
GO

-------------------------------------------------------
-- FUNCTION 7: Is Username Available
-- Returns 1 if username is available, 0 if already taken
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_IsUsernameAvailable
(
    @username NVARCHAR(50)
)
RETURNS BIT
AS
BEGIN
    RETURN CASE
        WHEN EXISTS (SELECT 1 FROM users WHERE user_name = @username)
        THEN 0 ELSE 1
    END
END
GO

-- Example usage
SELECT dbo.fn_IsUsernameAvailable('ali_2024') AS is_available;
SELECT CASE dbo.fn_IsUsernameAvailable('ali_2024')
        WHEN 1 THEN 'Username is available'
        ELSE 'Username already taken'
       END AS availability_status;
GO

-------------------------------------------------------
-- FUNCTION 8: Student Exam History (Table Function)
-- Returns all exams taken by a student with grade, result, start/end times
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_StudentExamHistory
(
    @st_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        e.ex_id,
        c.crs_name,
        e.ex_type,
        e.ex_date,
        e.total_degree AS full_mark,
        se.obtained_degree AS student_mark,
        dbo.fn_GetLetterGrade(se.obtained_degree, e.total_degree) AS grade,
        dbo.fn_PassOrFail(se.st_id, e.ex_id) AS result,
        se.actual_start_time,
        se.actual_end_time
    FROM student_exam se
    JOIN exams e ON e.ex_id = se.ex_id
    JOIN courses c ON c.crs_id = e.crs_id
    WHERE se.st_id = @st_id
)
GO

-- Example usage: Get exam history for student_id = 6
SELECT * FROM dbo.fn_StudentExamHistory(10) ORDER BY ex_date DESC;
SELECT * FROM dbo.fn_StudentExamHistory(9) WHERE result = 'FAILED';
GO

-------------------------------------------------------
-- FUNCTION 9: Exam Scoreboard (Table Function)
-- Returns ranking of students in an exam with percentage and grade
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_ExamScoreboard
(
    @ex_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        RANK() OVER (ORDER BY se.obtained_degree DESC) AS rank_position,
        s.st_id,
        s.st_name,
        se.obtained_degree AS student_mark,
        se.total_score AS full_mark,
        CAST(se.obtained_degree * 100.0 / se.total_score AS DECIMAL(5,2)) AS percentage,
        dbo.fn_GetLetterGrade(se.obtained_degree, e.total_degree) AS grade,
        dbo.fn_PassOrFail(s.st_id, @ex_id) AS result
    FROM student_exam se
    JOIN students s ON s.st_id = se.st_id
    JOIN exams e ON e.ex_id = se.ex_id
    WHERE se.ex_id = @ex_id
)
GO

-- Example usage: Get ranking for exam_id = 3
SELECT * FROM dbo.fn_ExamScoreboard(3) ORDER BY rank_position;
SELECT TOP 5 * FROM dbo.fn_ExamScoreboard(3) ORDER BY rank_position;
SELECT * FROM dbo.fn_ExamScoreboard(3) WHERE result = 'PASSED' ORDER BY rank_position;
GO

-------------------------------------------------------
-- FUNCTION 10: Course Question Bank (Table Function)
-- Returns all questions of a course, can filter by question type
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_CourseQuestionBank
(
    @crs_id INT,
    @q_type VARCHAR(20) = NULL   -- NULL = return all types
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        q.q_id,
        q.q_type,
        q.q_text,
        q.correct_answer,
        i.ins_name AS created_by,
        q.created_date
    FROM questions q
    JOIN instructors i ON i.ins_id = q.created_by
    WHERE q.crs_id = @crs_id
      AND (@q_type IS NULL OR q.q_type = @q_type)
)
GO

-- Example usage
SELECT * FROM dbo.fn_CourseQuestionBank(1, NULL) ORDER BY q_type, created_date;
SELECT * FROM dbo.fn_CourseQuestionBank(1, 'mcq');
SELECT * FROM dbo.fn_CourseQuestionBank(1, 'truefalse');
GO

-------------------------------------------------------
-- FUNCTION 11: Student Answer Sheet (Table Function)
-- Returns all answers of a student for a specific exam including correctness and marks
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_StudentAnswerSheet
(
    @st_id INT,
    @ex_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        q.q_id,
        q.q_type,
        q.q_text,
        sa.student_answer,
        q.correct_answer,
        sa.is_correct,
        eq.q_degree AS max_marks,
        sa.obtained_marks,
        sa.ans_at
    FROM student_answers sa
    JOIN questions q ON q.q_id = sa.q_id
    JOIN exam_questions eq ON eq.ex_id = sa.ex_id AND eq.q_id = sa.q_id
    WHERE sa.st_id = @st_id AND sa.ex_id = @ex_id
)
GO

-- Example usage
SELECT * FROM dbo.fn_StudentAnswerSheet(9, 3) ORDER BY q_id;
GO

-------------------------------------------------------
-- FUNCTION 12: Student Performance Summary (Table Function)
-- Returns summary stats of a student per course (best, lowest, avg score, pass/fail count)
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_StudentPerformanceSummary
(
    @st_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        c.crs_name,
        COUNT(se.ex_id) AS exams_taken,
        MAX(se.obtained_degree) AS best_score,
        MIN(se.obtained_degree) AS lowest_score,
        CAST(AVG(se.obtained_degree) AS DECIMAL(5,2)) AS avg_score,
        c.min_degree AS passing_mark,
        COUNT(CASE WHEN se.obtained_degree >= c.min_degree THEN 1 END) AS passed_count,
        COUNT(CASE WHEN se.obtained_degree < c.min_degree THEN 1 END) AS failed_count
    FROM student_exam se
    JOIN exams e ON e.ex_id = se.ex_id
    JOIN courses c ON c.crs_id = e.crs_id
    WHERE se.st_id = @st_id
    GROUP BY c.crs_name, c.min_degree
)
GO

-- Example usage
SELECT * FROM dbo.fn_StudentPerformanceSummary(9) WHERE failed_count > 0;
GO

-------------------------------------------------------
-- FUNCTION 13: Corrective Candidates (Table Function)
-- Returns students who failed exams in a specific intake
-------------------------------------------------------
CREATE OR ALTER FUNCTION fn_CorrectiveCandidates
(
    @in_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT DISTINCT
        s.st_id,
        s.st_name,
        s.st_email,
        c.crs_name,
        se.obtained_degree AS score,
        c.min_degree AS passing_mark,
        e.ex_id AS failed_exam_id
    FROM student_exam se
    JOIN students s ON s.st_id = se.st_id
    JOIN exams e ON e.ex_id = se.ex_id
    JOIN courses c ON c.crs_id = e.crs_id
    WHERE e.in_id = @in_id
      AND e.ex_type = 'exam'
      AND se.obtained_degree < c.min_degree
)
GO

-- Example usage
SELECT * FROM dbo.fn_CorrectiveCandidates(1) ORDER BY crs_name, score;
SELECT crs_name, COUNT(*) AS students_need_corrective
FROM dbo.fn_CorrectiveCandidates(1)
GROUP BY crs_name;
GO