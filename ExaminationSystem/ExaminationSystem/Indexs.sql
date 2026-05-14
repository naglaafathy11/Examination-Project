-- Students 
CREATE UNIQUE INDEX IX_students_email ON students(st_phone);

-- Questions 
CREATE INDEX IX_questions_course_type
ON questions(crs_id, q_type);

-- Exam Questions 
CREATE INDEX IX_exam_questions_exam
ON exam_questions(ex_id);

-- Student Exam 
CREATE INDEX IX_student_exam_exam_student
ON student_exam(ex_id, st_id);

-- Student Answers
CREATE INDEX IX_student_answers_exam_student
ON student_answers(ex_id, st_id);