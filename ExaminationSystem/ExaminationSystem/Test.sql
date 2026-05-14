use examnation_system;
go
-- module 1: user management
 
-- tc-u-01: add new user

declare @uid int;
exec sp_add_userr 'test_user_01', 'pass@123', 'student', @uid output;
select @uid as [new_user_id should be > 0];
-- cleanup
delete from users where user_name = 'test_user_01';
go
--duplicate username -> should raise error
 
begin try
    declare @uid1 int, @uid2 int;
    exec sp_add_userr 'dup_user', 'pass@123', 'student', @uid1 output;
    exec sp_add_userr 'dup_user', 'pass@123', 'student', @uid2 output;  
    print 'error: should have raised duplicate error!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
-- cleanup
delete from users where user_name = 'dup_user';
go
--login with valid credentials
 
declare @uid int;
exec sp_add_userr 'login_test', 'abc@123', 'instructor', @uid output;
exec sp_login 'login_test', 'abc@123'; -- should return 1 row
-- cleanup
delete from users where user_name = 'login_test';
go

--deactivate user 
 
declare @uid int;
exec sp_add_userr 'deact_user', 'pass@123', 'student', @uid output;
exec sp_set_user_status @uid, 0; -- deactivate
 
delete from users where user_name = 'deact_user';
go
--change password 
 
declare @uid int;
exec sp_add_userr 'chpwd_user', 'oldpass@1', 'student', @uid output;
exec sp_change_password @uid, 'oldpass@1', 'newpass@2';
-- verify new password works
exec sp_login 'chpwd_user', 'newpass@2'; -- should return 1 row
delete from users where user_name = 'chpwd_user';
go
--change password with wrong old password -> should fail
 
declare @uid int;
exec sp_add_userr 'chpwd2_user', 'oldpass@1', 'student', @uid output;
begin try
    exec sp_change_password @uid, 'wrongold', 'newpass@2';
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
delete from users where user_name = 'chpwd2_user';
go
--invalid role should fail (check constraint)
 
begin try
    declare @uid int;
    exec sp_add_userr 'role_user', 'pass@123', 'hacker', @uid output;
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
 
-- module 2: branch / track / intake
--add branch
 
exec sp_add_branch 'test branch30', 'test city30';
select * from branches where br_name = 'test branch30';
go

--edit branch
 
declare @bid int = 34;
exec sp_edit_branch @bid, 'test branch updated', 'new city';
select * from branches where br_id = @bid;
go
--edit non-existent branch -> should fail
begin try
    exec sp_edit_branch 99999, 'ghost branch', 'nowhere';
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
--add track
exec sp_add_track 'test track30', 'track for testing';
select * from tracks where tr_name = 'test track30';
go
--assign track to branch
declare @bid int = (select top 1 br_id from branches where br_name = 'test branch updated');
declare @tid int = (select top 1 tr_id from tracks where tr_name = 'test track30');
exec sp_assign_track_to_branch @bid, @tid, '2025-01-01';
select * from branch_track where br_id = @bid and tr_id = @tid;
go
--duplicate branch-track assignment -> should fail
declare @bid int = (select top 1 br_id from branches where br_name = 'test branch updated');
declare @tid int = (select top 1 tr_id from tracks where tr_name = 'test track30');
begin try
    exec sp_assign_track_to_branch @bid, @tid, '2025-01-01';
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
--add intake
declare @bid int = (select top 1 br_id from branches where br_name = 'test branch updated');
declare @tid int = (select top 1 tr_id from tracks where tr_name = 'test track30');
exec sp_add_intake 'test intake 100', 2025, @bid, @tid;
select * from intake where in_name = 'test intake 100';
go
--add intake for invalid branch-track combo -> should fail
begin try
    exec sp_add_intake 'bad intake', 2025, 99999, 99999;
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go


-- module 3: student management
--add student
declare @in int = (select top 1 in_id from intake where in_name = 'test intake 99');
exec sp_add_student 'test student100', 'teststudent100@test.com', '01099999999',
     'test address', '2000-05-15', @in, 'tc_student_01', 'stpass@123';
select * from students where st_email = 'teststudent100@test.com';
go
--duplicate username -> should fail
declare @in int = (select top 1 in_id from intake where in_name = 'test intake 99');
begin try
    exec sp_add_student 'test student2', 'teststudent2@test.com', '01099999998',
         'test address', '2000-05-15', @in, 'tc_student_01', 'stpass@123'; -- same username
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
--edit student
declare @sid int = (select st_id from students where st_email = 'teststudent@test.com');
exec sp_edit_student @sid, 'updated name', 'teststudent@test.com', '01011111111',
     'new address', '2000-05-15';
select st_name, st_phone from students where st_id = @sid;
go
--edit non-existent student -> should fail
begin try
    exec sp_edit_student 99999, 'ghost', 'ghost@test.com', '000', 'nowhere', '2000-01-01';
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
--search students by name
exec sp_search_students 'updated name', null;
go
--get student profile
declare @sid int = (select st_id from students where st_email = 'teststudent@test.com');
exec sp_get_student_profile @sid;
go
--get students by intake
declare @in int = (select top 1 in_id from intake where in_name = 'test intake 99');
exec sp_get_students_by_intake @in;
go


-- module 4: instructor management
--add instructor 
exec sp_add_instructor 'test instructor', 'testinstructor@test.com', '01055555555',
     '2022-01-01', 20000.00, 'tc_ins_01', 'inspass@123';
select * from instructors where ins_email = 'testinstructor@test.com';
go
--assign instructor to course & intake
declare @insid int = (select ins_id from instructors where ins_email = 'testinstructor@test.com');
declare @in int = (select top 1 in_id from intake where in_name = 'test intake 99');
exec sp_assign_instructor_course @insid, 1, @in;
select * from instructor_course where ins_id = @insid;
go
--duplicate instructor assignment -> should fail
declare @insid int = (select ins_id from instructors where ins_email = 'testinstructor@test.com');
declare @in int = (select top 1 in_id from intake where in_name = 'test intake 99');
begin try
    exec sp_assign_instructor_course @insid, 1, @in;
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
--get instructor courses
declare @insid int = (select ins_id from instructors where ins_email = 'testinstructor@test.com');
exec sp_get_instructor_courses @insid;
go



-- module 5: course & question management
--add course 
exec sp_add_course 'test course', 'a test course', 100, 50;
select * from courses where crs_name = 'test course';
go
--add course min >= max -> should fail
begin try
    exec sp_add_course 'bad course', 'desc', 50, 50;
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
 

-- add mcq question  
 -- course id
declare @cid int = (
    select top 1 crs_id 
    from courses 
    where crs_name = 'test course'
    order by crs_id desc
);

--   instructor id
declare @insid int = (
    select top 1 ins_id 
    from instructors 
    where ins_email = 'testinstructor@test.com'
    order by ins_id desc
);

if @cid is null
begin
    raiserror('course not found',16,1);
    return;
end

if @insid is null
begin
    raiserror('instructor not found',16,1);
    return;
end

exec sp_add_question 
    'what is class?', 
    'mcq', 
    'blueprint', 
    @cid, 
    @insid;

declare @qid int = (
    select top 1 q_id 
    from questions 
    where q_text = 'what is class?'
    order by q_id desc
);

exec sp_add_choice @qid, 'a blueprint for creating objects', 1;
exec sp_add_choice @qid, 'a variable that stores data', 0;
go 
 
--   course id  
declare @cid int = (
    select top 1 crs_id 
    from courses 
    where crs_name = 'test course'
    order by crs_id desc
);

-- instructor id  
declare @insid int = (
    select top 1 ins_id 
    from instructors 
    where ins_email = 'testinstructor@test.com'
    order by ins_id desc
);

--   add true/false question
exec sp_add_question 
    'var is key word', 
    'truefalse', 
    'true', 
    @cid, 
    @insid;

--  check
select * 
from questions 
where q_text = 'var is key word';
go
--add text question
-- get course id
declare @cid int = (
    select top 1 crs_id 
    from courses 
    where crs_name = 'test course'
    order by crs_id desc
);

-- get instructor id
declare @insid int = (
    select top 1 ins_id 
    from instructors 
    where ins_email = 'testinstructor@test.com'
    order by ins_id desc
);

-- add text question
exec sp_add_question 
    'What is Dependency Injection in .NET? Explain how it is implemented in ASP.NET Core and why it is considered a best practice.',
    'text', 
    'Dependency Injection is a design pattern used to achieve Inversion of Control. In ASP.NET Core, it is built-in through the IServiceCollection and IServiceProvider. It allows loose coupling, better testability, and easier maintenance by injecting dependencies rather than creating them inside classes.',
    @cid, 
    @insid;

-- check
select * 
from questions 
where q_text LIKE '%Dependency Injection%';
go
-- add question with invalid type -> should fail
declare @cid int = (
    select top 1 crs_id 
    from courses 
    where crs_name = 'test course'
    order by crs_id desc
);

declare @insid int = (
    select top 1 ins_id 
    from instructors 
    where ins_email = 'testinstructor@test.com'
    order by ins_id desc
);

begin try
    exec sp_add_question 
        'bad question', 
        'essay',    
        'answer', 
        @cid, 
        @insid;

    print 'error: should have failed!';
end try

begin catch
    print 'passed: ' + error_message();
end catch;
go
 
 
--edit question
declare @qid int = (
    select top 1 q_id
    from questions
    where q_text = 'what is class?'
    order by q_id desc
);

exec sp_edit_question 
    @qid, 
    'what is object?', 
    'instance';

select q_text, correct_answer 
from questions 
where q_id = @qid;
go
--search questions by course
declare @cid int = (
    select top 1 crs_id
    from courses
    where crs_name = 'test course'
    order by crs_id desc
);

--  
exec sp_search_questions @cid, null, null;
go


-- module 6: exam management
--create exam 
--  instructor id
declare @insid int = (
    select top 1 ins_id
    from instructors
    where ins_email = 'testinstructor@test.com'
    order by ins_id desc
);

--   course id
declare @cid int = (
    select top 1 crs_id
    from courses
    where crs_name = 'test course'
    order by crs_id desc
);

--  intake id
declare @in int = (
    select top 1 in_id
    from intake
    where in_name = 'test intake 99'
    order by in_id desc
);

if @insid is null or @cid is null or @in is null
begin
    raiserror('Instructor, Course, or Intake not found',16,1);
    return;
end

--  assign instructor to course if not exists
if not exists (
    select 1
    from instructor_course
    where ins_id = @insid and crs_id = @cid and in_id = @in
)
begin
    insert into instructor_course (in_id, ins_id, crs_id)
    values (@in, @insid, @cid);

    print 'Instructor assigned to course successfully';
end
else
    print 'Instructor already assigned to course';

exec sp_create_exam
    'exam',         -- exam name
    @cid,           -- course id
    @insid,         -- instructor id
    @in,            -- intake id
    '2025-12-01',   -- exam date
    '09:00',        -- start time
    '11:00',        -- end time
    120,            -- duration in minutes
    100,            -- total marks
    2025,           -- exam year
    null;           -- optional field

 
select *
from exams
where crs_id = @cid and ins_id = @insid;
go 

--create exam with total_degree > course max_degree -> should fail
--   instructor id
declare @insid int = (
    select top 1 ins_id
    from instructors
    where ins_email = 'testinstructor@test.com'
    order by ins_id desc
);

-- course id
declare @cid int = (
    select top 1 crs_id
    from courses
    where crs_name = 'test course'
    order by crs_id desc
);

--  intake id
declare @in int = (
    select top 1 in_id
    from intake
    where in_name = 'test intake 99'
    order by in_id desc
);

begin try
    exec sp_create_exam
        'exam', @cid, @insid, @in,
        '2025-12-05', '09:00', '11:00', 120, 999, 2025, null;
    print 'Exam created successfully';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
--create exam with end_time <= start_time -> should fail
 
declare @insid int = (
    select top 1 ins_id
    from instructors
    where ins_email = 'testinstructor@test.com'
    order by ins_id desc
);

declare @cid int = (
    select top 1 crs_id
    from courses
    where crs_name = 'test course'
    order by crs_id desc
);

declare @in int = (
    select top 1 in_id
    from intake
    where in_name = 'test intake 99'
    order by in_id desc
);


begin try
    exec sp_create_exam
        'exam', @cid, @insid, @in,
        '2025-12-05', '11:00', '09:00', 120, 100, 2025, null;
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
 
--add question to exam manually
 
declare @insid int = (
    select top 1 ins_id
    from instructors
    where ins_email = 'testinstructor@test.com'
    order by ins_id desc
);

declare @exid int = (
    select top 1 ex_id
    from exams
    where ins_id = @insid
    order by ex_id desc
);

declare @qid int = (
    select top 1 q_id
    from questions
    where q_text = 'what is object?'
    order by q_id desc
);

 
exec sp_add_question_to_exam @exid, @qid, 30;

 
select *
from exam_questions
where ex_id = @exid;
go

 
declare @insid int = (
    select top 1 ins_id
    from instructors
    where ins_email = 'testinstructor@test.com'
    order by ins_id desc
);

declare @exid int = (
    select top 1 ex_id
    from exams
    where ins_id = @insid
    order by ex_id desc
);

declare @qid2 int = (
    select top 1 q_id
    from questions
    where q_text = 'var is key word'
    order by q_id desc
);

 
begin try
    exec sp_add_question_to_exam @exid, @qid2, 999; -- degree exceeds exam total
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;

 
select *
from exam_questions
where ex_id = @exid;
go



-- ======================
-- assign student to exam
-- ======================
declare @exid int = (
    select top 1 ex_id
    from exams
    where ins_id = (select top 1 ins_id from instructors where ins_email = 'testinstructor@test.com')
    order by ex_id desc
);
declare @sid int = (
    select top 1 st_id
    from students
    where st_email = 'teststudent@test.com'
    order by st_id desc
);
exec sp_assign_student_to_exam @sid, @exid, '2025-12-01 09:00', '2025-12-01 11:00';
select * from student_exam where st_id = @sid and ex_id = @exid;
go

-- ======================
-- duplicate student-exam assignment -> should fail
-- ======================
declare @exid int = (
    select top 1 ex_id
    from exams
    where ins_id = (select top 1 ins_id from instructors where ins_email = 'testinstructor@test.com')
    order by ex_id desc
);
declare @sid int = (
    select top 1 st_id
    from students
    where st_email = 'teststudent@test.com'
    order by st_id desc
);
begin try
    exec sp_assign_student_to_exam @sid, @exid, '2025-12-01 09:00', '2025-12-01 11:00';
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go

-- ======================
-- get exam details
-- ======================
declare @exid int = (
    select top 1 ex_id
    from exams
    where ins_id = (select top 1 ins_id from instructors where ins_email = 'testinstructor@test.com')
    order by ex_id desc
);
exec sp_get_exam_details @exid;
go

-- ======================
-- search exams
-- ======================
declare @cid int = (
    select top 1 crs_id
    from courses
    where crs_name = 'test course'
    order by crs_id desc
);
exec sp_search_exams @crs_id = @cid;
go

-- ======================
-- get exams by course
-- ======================
declare @cid int = (
    select top 1 crs_id
    from courses
    where crs_name = 'test course'
    order by crs_id desc
);
exec sp_get_exams_by_course @cid;
go

-- ======================
-- module 7: answer & grading // trigger is not active
-- ======================
-- submit correct mcq answer
declare @exid int = (
    select top 1 ex_id
    from exams
    where ins_id = (select top 1 ins_id from instructors where ins_email = 'testinstructor@test.com')
    order by ex_id desc
);
declare @sid int = (
    select top 1 st_id
    from students
    where st_email = 'teststudent@test.com'
    order by st_id desc
);
declare @qid int = (
    select top 1 q_id
    from questions
    where q_text = 'what is class'
    order by q_id desc
);
exec sp_submit_answer @sid, @exid, @qid, 'blueprint';
select is_correct, obtained_marks
from student_answers
where st_id = @sid and ex_id = @exid and q_id = @qid;
go

-- submit wrong mcq answer -> safe with TRY/CATCH
begin try
    exec sp_submit_answer 9, 3, 7, 'wrongwrong';
    select is_correct from student_answers where st_id = 9 and ex_id = 3 and q_id = 7;
end try
begin catch
    print 'note: ' + error_message();
end catch;
go

-- duplicate answer submission -> should fail
declare @exid int = (
    select top 1 ex_id
    from exams
    where ins_id = (select top 1 ins_id from instructors where ins_email = 'testinstructor@test.com')
    order by ex_id desc
);
declare @sid int = (
    select top 1 st_id
    from students
    where st_email = 'teststudent@test.com'
    order by st_id desc
);
declare @qid int = (
    select top 1 q_id
    from questions
    where q_text = 'what is class?'
    order by q_id desc
);
begin try
    exec sp_submit_answer @sid, @exid, @qid, 'blueprint'; -- already submitted
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go

-- ======================
-- calculate student result
-- ======================
declare @exid int = (
    select top 1 ex_id
    from exams
    where ins_id = (select top 1 ins_id from instructors where ins_email = 'testinstructor@test.com')
    order by ex_id desc
);
declare @sid int = (
    select top 1 st_id
    from students
    where st_email = 'teststudent@test.com'
    order by st_id desc
);
exec sp_calculate_student_result @sid, @exid;
go


-- grade text answer with marks > question degree -> should fail
declare @exid int = (
    select top 1 ex_id
    from exams
    where ins_id = (select top 1 ins_id from instructors where ins_email = 'testinstructor@test.com')
    order by ex_id desc
);
declare @sid int = (
    select top 1 st_id
    from students
    where st_email = 'teststudent@test.com'
    order by st_id desc
);
declare @qid int = (
    select top 1 q_id
    from questions
    where q_text LIKE 'What is Dependency Injection in .NET%'
    order by q_id desc
);
begin try
    exec sp_grade_text_answer @sid, @exid, @qid, 9999, 1;
    print 'error: should have failed!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
--get exam results (instructor view)
exec sp_get_exam_results 3;
go
--get student results (student view)
exec sp_get_my_results 10;
go
--get student detailed answers
exec sp_get_student_answer_details 10, 3;
go


-- module 8: functions
--fn_getlettergrade
select dbo.fn_getlettergrade(90, 100) as [should be a],
       dbo.fn_getlettergrade(80, 100) as [should be b],
       dbo.fn_getlettergrade(65, 100) as [should be c],
       dbo.fn_getlettergrade(55, 100) as [should be d],
       dbo.fn_getlettergrade(30, 100) as [should be f];
go
--fn_passorfail
select dbo.fn_passorfail(10, 3) as [student 10 exam 3 result];
go
--fn_countcorrectanswers
select dbo.fn_countcorrectanswers(10, 3) as [should be >= 0];
go
--fn_countexamquestions
select dbo.fn_countexamquestions(3) as [question count for exam 3];
go
--fn_coursepassrate
select dbo.fn_coursepassrate(1) as [pass rate for course 1, should be 0-100];
go
--fn_examdurationminutes
select dbo.fn_examdurationminutes(3) as [should be 120];
go
--fn_isusernameavailable
select dbo.fn_isusernameavailable('admin01') as [should be 0 - taken],
       dbo.fn_isusernameavailable('totallynewuser999') as [should be 1 - available];
go
--fn_studentexamhistory (tvf)
select * from dbo.fn_studentexamhistory(10) order by ex_date desc;
go
--fn_examscoreboard (tvf)
select * from dbo.fn_examscoreboard(3) order by rank_position;
go
--fn_coursequestionbank (tvf)
select * from dbo.fn_coursequestionbank(1, null);
select * from dbo.fn_coursequestionbank(1, 'mcq');
go
--fn_studentanswersheet (tvf)
select * from dbo.fn_studentanswersheet(10, 3);
go
--fn_studentperformancesummary (tvf)
select * from dbo.fn_studentperformancesummary(10);
go
--fn_correctivecandidates (tvf)
 
select * from dbo.fn_correctivecandidates(1);
go



-- module 9: views
-- all views should return data without error
select top 5 * from vw_student_results;
go
 
select top 5 * from vw_student_answers_details;
go
 
select * from vw_exam_questions_count;
go
select top 5 * from vw_question_scores;
go
 
select * from vw_instructor_courses;
go
 
select * from vw_students_per_intake;
go
 
select * from vw_top_students;
go
 
select * from vw_failed_students;
go
 
select * from vw_course_success_rate;
go
 
select * from vw_exam_overview;
go
 
select * from vw_questions_per_course;
go
 


-- module 10: triggers
--tr_checkexamtime - answer outside exam time window
begin try
    insert into student_answers (st_id, ex_id, q_id, student_answer, is_correct, obtained_marks)
    values (10, 3, 5, 'unique identifier', 0, 0);
    print 'note: trigger allows (exam window check based on getdate vs exam time)';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
--tr_preventdeletequestioninexam
begin try
    delete from questions where q_id in (select q_id from exam_questions);
    print 'error: trigger should have blocked this!';
end try
begin catch
    print 'passed: ' + error_message();
end catch;
go
-- delete question not used in exam -> should succeed
declare @insid int = (select ins_id from instructors where ins_email = 'testinstructor@test.com');
declare @cid int = (select crs_id from courses where crs_name = 'test course');
exec sp_add_question 'temporary question to delete', 'text', 'answer', @cid, @insid;
declare @tqid int = (select q_id from questions where q_text = 'temporary question to delete');
delete from questions where q_id = @tqid;
if not exists (select 1 from questions where q_id = @tqid)
    print 'passed: unused question deleted successfully';
else
    print 'error: should have been deleted!';
go

select * 
from sys.database_permissions p
join sys.database_principals dp on p.grantee_principal_id = dp.principal_id
where dp.name = 'ExamStudentUser'
  and p.permission_name in ('UPDATE','INSERT','DELETE')

 