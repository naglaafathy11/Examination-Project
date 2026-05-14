CREATE TRIGGER TRCheckExamTotalDegree
ON exam_questions
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM
        (
            SELECT eq.ex_id, SUM(eq.q_degree) AS TotalQDegree
            FROM exam_questions eq
            WHERE eq.ex_id IN (SELECT DISTINCT ex_id FROM inserted)
            GROUP BY eq.ex_id
        ) AS S
        JOIN exams e ON e.ex_id = S.ex_id
        WHERE S.TotalQDegree > e.total_degree
    )
    BEGIN
        RAISERROR('Sum of question degrees exceeds exam total_degree.',16,1);
        ROLLBACK TRANSACTION;
    END
END;

--=========.2- Chicking Exam Time 

CREATE TRIGGER TR_CheckExamTime
ON student_answers
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        JOIN exams e ON e.ex_id = i.ex_id
        WHERE GETDATE() NOT BETWEEN
              DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', e.start_time), CAST(e.ex_date AS DATETIME))
          AND DATEADD(SECOND, DATEDIFF(SECOND, '00:00:00', e.end_time),   CAST(e.ex_date AS DATETIME))
    )
    BEGIN
        RAISERROR('Exam is not active now',16,1);
        ROLLBACK TRANSACTION;
    END
END;
--=========.3- Calc Question Answers

CREATE TRIGGER TR_CalcQuestionResult
ON student_answers
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE sa
    SET 
        sa.is_correct =
            CASE 
                WHEN sa.student_answer = q.correct_answer THEN 1
                ELSE 0
            END,
        sa.obtained_marks =
            CASE 
                WHEN sa.student_answer = q.correct_answer THEN eq.q_degree
                ELSE 0
            END
    FROM student_answers sa
    JOIN inserted i       ON sa.ans_id = i.ans_id
    JOIN questions q      ON q.q_id = sa.q_id
    JOIN exam_questions eq ON eq.q_id = sa.q_id AND eq.ex_id = sa.ex_id;
END;

--=========.4- Check Instructor Course

CREATE TRIGGER TR_CheckInstructorCourse
ON exams
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM inserted i
        LEFT JOIN instructor_course ic
            ON ic.ins_id = i.ins_id
           AND ic.crs_id = i.crs_id
        WHERE ic.ins_id IS NULL
    )
    BEGIN
        RAISERROR('Instructor not allowed to create exam for this course.',16,1);
        RETURN;
    END

    INSERT INTO exams
    (
        ex_type,
        crs_id,
        ins_id,
        in_id,
        ex_date,
        start_time,
        end_time,
        total_time,
        total_degree,
        year,
        allowance_options
    )
    SELECT
        ex_type,
        crs_id,
        ins_id,
        in_id,
        ex_date,
        start_time,
        end_time,
        total_time,
        total_degree,
        year,
        allowance_options
    FROM inserted;
END;

--=========.5- Delete Question InExam

CREATE TRIGGER TR_PreventDeleteQuestionInExam
ON questions
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM exam_questions eq
        JOIN deleted d ON eq.q_id = d.q_id
    )
    BEGIN
        RAISERROR('Cannot delete question used in exam.',16,1);
        RETURN;
    END

    DELETE FROM questions
    WHERE q_id IN (SELECT q_id FROM deleted);
END;
