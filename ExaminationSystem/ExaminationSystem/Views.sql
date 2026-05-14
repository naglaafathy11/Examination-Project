--view 1: Student Results Overview

--Description:

--Displays students’ performance in exams.
--Shows student name, course name, and exam details.
--Includes total score and obtained degree for each exam.
--Combines data from students, exams, and courses tables.
--Useful for generating reports and tracking student performance
go
CREATE VIEW vw_student_results
AS
SELECT 
    s.st_id,
    s.st_name,
    e.ex_id,
    e.ex_date,
    c.crs_name,
    se.total_score,
    se.obtained_degree
FROM students s
JOIN student_exam se ON s.st_id = se.st_id
JOIN exams e ON e.ex_id = se.ex_id
JOIN courses c ON c.crs_id = e.crs_id;
go
select * from vw_student_results


--View 2: Student Answers Details
--Description:
--- Lists all answers submitted by students for each question.
--- Displays question text, student answer, and correctness.
--- Includes marks obtained per question.
--- Helps instructors review answers and grading.


CREATE VIEW vw_student_answers_details
AS
SELECT
    s.st_name,
    e.ex_id,
    q.q_text,
    sa.student_answer,
    sa.is_correct,
    sa.obtained_marks
FROM student_answers sa
JOIN students s ON s.st_id = sa.st_id
JOIN exams e ON e.ex_id = sa.ex_id
JOIN questions q ON q.q_id = sa.q_id;

select * from vw_student_answers_details
--View 3: Exam Questions Count
--Description:
--- Shows total number of questions in each exam.
--- Helps verify exam completeness.
--- Useful for validating exam structure before publishing.

CREATE VIEW vw_exam_questions_count
AS
SELECT
    e.ex_id,
    COUNT(eq.q_id) AS total_questions
FROM exams e
JOIN exam_questions eq ON e.ex_id = eq.ex_id
GROUP BY e.ex_id;

select * from vw_exam_questions_count
--View 4: Question Scores Analysis
--Description:
--- Displays marks obtained by students for each question.
--- Helps analyze question difficulty level.
--- Useful for improving question quality and exam fairness.
CREATE VIEW vw_question_scores
AS
SELECT
    s.st_name,
    q.q_text,
    sa.obtained_marks
FROM student_answers sa
JOIN students s ON s.st_id = sa.st_id
JOIN questions q ON q.q_id = sa.q_id;

select * from vw_question_scores
--View 5: Instructor Courses
--Description:
--- Lists instructors and the courses they teach.
--- Includes intake information.
--- Helps in tracking teaching assignments and workload distribution.


CREATE VIEW vw_instructor_courses
AS
SELECT
    i.ins_name,
    c.crs_name,
    ic.in_id
FROM instructor_course ic
JOIN instructors i ON i.ins_id = ic.ins_id
JOIN courses c ON c.crs_id = ic.crs_id;

select * from vw_instructor_courses
--View 6: Students per Intake
--Description:
--- Displays number of students in each intake.
--- Helps track student distribution across batches.
--- Useful for administrative planning.

CREATE VIEW vw_students_per_intake
AS
SELECT
    i.in_name,
    COUNT(s.st_id) AS total_students
FROM intake i
LEFT JOIN students s ON s.in_id = i.in_id
GROUP BY i.in_name;

select * from vw_students_per_intake
--View 7: Top Students per Exam
--Description:
--- Identifies highest scoring student(s) in each exam.
--- Handles cases where multiple students have the same top score.
--- Useful for ranking and performance recognition.

CREATE VIEW vw_top_students
AS
SELECT 
    e.ex_id,
    s.st_name,
    se.total_score
FROM student_exam se
JOIN students s ON s.st_id = se.st_id
JOIN exams e ON e.ex_id = se.ex_id
WHERE se.total_score = (
    SELECT MAX(total_score)
    FROM student_exam
    WHERE ex_id = se.ex_id
);

select * from vw_top_students
--View 8: Failed Students
--Description:
--- Lists students who scored below the minimum required degree.
--- Displays course name and minimum passing degree.
--- Helps identify students who need improvement.
CREATE VIEW vw_failed_students
AS
SELECT
    s.st_name,
    c.crs_name,
    se.total_score,
    c.min_degree
FROM student_exam se
JOIN students s ON s.st_id = se.st_id
JOIN exams e ON e.ex_id = se.ex_id
JOIN courses c ON c.crs_id = e.crs_id
WHERE se.total_score < c.min_degree;

select * from vw_failed_students
--View 9: Course Success Rate
--Description:
--- Calculates success percentage for each course.
--- Based on number of passed students vs total students.
--- Useful for evaluating course effectiveness.

CREATE VIEW vw_course_success_rate
AS
SELECT
    c.crs_name,
    COUNT(CASE WHEN se.total_score >= c.min_degree THEN 1 END) * 100.0 
    / COUNT(*) AS success_rate
FROM student_exam se
JOIN exams e ON e.ex_id = se.ex_id
JOIN courses c ON c.crs_id = e.crs_id
GROUP BY c.crs_name;

select * from vw_course_success_rate
--View 10: Exam Overview
--Description:
--- Displays exam details including course, instructor, and intake.
--- Shows exam date, duration, and total degree.
--- Useful for centralized exam monitoring.

CREATE VIEW vw_exam_overview
AS
SELECT 
    e.ex_id,
    c.crs_name,
    i.ins_name,
    e.ex_date,
    e.total_degree,
    e.total_time
FROM exams e
JOIN courses c ON c.crs_id = e.crs_id
JOIN instructors i ON i.ins_id = e.ins_id;

select * from vw_exam_overview
--View 11: Questions per Course
--Description:
--- Lists all questions grouped by course.
--- Includes question type (MCQ, True/False, Text).
--- Helps manage and review the question bank.


CREATE VIEW vw_questions_per_course
AS
SELECT 
    c.crs_name,
    q.q_text,
    q.q_type
FROM questions q
JOIN courses c ON c.crs_id = q.crs_id;

select * from vw_questions_per_course