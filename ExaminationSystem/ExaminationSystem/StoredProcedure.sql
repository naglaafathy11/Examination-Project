-- 1.1 add new user
create or alter procedure sp_add_userr
    @user_name nvarchar(50),
    @password  nvarchar(max),
    @role      varchar(50),
    @new_user_id int OUTPUT
as
begin
    set nocount on;

    if exists (select 1 from users where user_name = @user_name)
    begin
        raiserror('username already exists.', 16, 1);
        return;
    end


    insert into users (user_name, password, role)
    values (@user_name, @password, @role);

    set @new_user_id = scope_identity();

go

-- 1.2 login
create or alter procedure sp_login
    @user_name nvarchar(50),
    @password  nvarchar(max)
as
begin
    set nocount on;
 
    select user_id, user_name, role, is_active
    from users
    where user_name = @user_name
      and password  = @password
      and is_active = 1;
 
    if @@rowcount = 0
        raiserror('invalid credentials or inactive account.', 16, 1);
end
go
-- 1.3 activate / deactivate user
create or alter procedure sp_set_user_status
    @user_id   int,
    @is_active bit
as
begin
    set nocount on;
 
    update users
    set is_active = @is_active
    where user_id = @user_id;
 
    if @@rowcount = 0
        raiserror('user not found.', 16, 1);
end
go

-- 1.4 change password
create or alter procedure sp_change_password
    @user_id      int,
    @old_password nvarchar(max),
    @new_password nvarchar(max)
as
begin
    set nocount on;
 
    if not exists (select 1 from users where user_id = @user_id and password = @old_password)
    begin
        raiserror('old password is incorrect.', 16, 1);
        return;
    end
 
    update users set password = @new_password where user_id = @user_id;
    print 'password changed successfully.';
end
go

-- 2.1 add branch
create or alter procedure sp_add_branch
    @br_name     varchar(100),
    @br_location varchar(100)
as
begin
    set nocount on;
 
    insert into branches (br_name, br_location)
    values (@br_name, @br_location);
 
    select scope_identity() as new_branch_id;
end
go

-- 2.2 edit branch
create or alter procedure sp_edit_branch
    @br_id       int,
    @br_name     varchar(100),
    @br_location varchar(100)
as
begin
    set nocount on;
 
    update branches
    set br_name = @br_name, br_location = @br_location
    where br_id = @br_id;
 
    if @@rowcount = 0 raiserror('branch not found.', 16, 1);
end
go
 
-- 2.3 add track
create or alter procedure sp_add_track
    @tr_name        varchar(100),
    @tr_description varchar(200)
as
begin
    set nocount on;
 
    insert into tracks (tr_name, tr_description)
    values (@tr_name, @tr_description);
 
    select scope_identity() as new_track_id;
end
go
 
-- 2.4 edit track
create or alter procedure sp_edit_track
    @tr_id          int,
    @tr_name        varchar(100),
    @tr_description varchar(200)
as
begin
    set nocount on;
 
    update tracks
    set tr_name = @tr_name, tr_description = @tr_description
    where tr_id = @tr_id;
 
    if @@rowcount = 0 raiserror('track not found.', 16, 1);
end
go
 
-- 2.5 assign track to branch
create or alter procedure sp_assign_track_to_branch
    @br_id      int,
    @tr_id      int,
    @start_date date
as
begin
    set nocount on;
 
    if exists (select 1 from branch_track where br_id = @br_id and tr_id = @tr_id)
    begin
        raiserror('branch-track assignment already exists.', 16, 1);
        return;
    end
 
    insert into branch_track (br_id, tr_id, start_date)
    values (@br_id, @tr_id, @start_date);
end
go
 
-- 2.6 add intake
create or alter procedure sp_add_intake
    @in_name varchar(50),
    @in_year int,
    @br_id   int,
    @tr_id   int
as
begin
    set nocount on;
 
    if not exists (select 1 from branch_track where br_id = @br_id and tr_id = @tr_id)
    begin
        raiserror('branch-track combination does not exist.', 16, 1);
        return;
    end
 
    insert into intake (in_name, in_year, br_id, tr_id)
    values (@in_name, @in_year, @br_id, @tr_id);
 
    select scope_identity() as new_intake_id;
end
go
 
-- 2.7 edit intake
create or alter procedure sp_edit_intake
    @in_id   int,
    @in_name varchar(50),
    @in_year int
as
begin
    set nocount on;
 
    update intake
    set in_name = @in_name, in_year = @in_year
    where in_id = @in_id;
 
    if @@rowcount = 0 raiserror('intake not found.', 16, 1);
end
go

-- add student
create or alter procedure sp_add_student
    @st_name   varchar(100),
    @st_email  varchar(100),
    @st_phone  varchar(20),
    @st_address varchar(200),
    @st_dob    date,
    @in_id     int,
    @user_name nvarchar(50),
    @password  nvarchar(max)
as
begin
    set nocount on;
    begin transaction;
    begin try

        declare @new_user_id int;

        exec sp_add_userr 
            @user_name = @user_name,
            @password  = @password,
            @role      = 'student',
            @new_user_id = @new_user_id OUTPUT;

        insert into students (user_id, st_name, st_email, st_phone, st_address, st_dob, in_id)
        values (@new_user_id, @st_name, @st_email, @st_phone, @st_address, @st_dob, @in_id);

        select scope_identity() as new_student_id;

        commit;
    end try
    begin catch
        rollback;
        throw;
    end catch
end
go

-- 3.2 edit student
create or alter procedure sp_edit_student
    @st_id      int,
    @st_name    varchar(100),
    @st_email   varchar(100),
    @st_phone   varchar(20),
    @st_address varchar(200),
    @st_dob     date
as
begin
    set nocount on;
 
    if not exists (select 1 from students where st_id = @st_id)
    begin
        raiserror('student not found.', 16, 1);
        return;
    end
 
    update students
    set st_name    = @st_name,
        st_email   = @st_email,
        st_phone   = @st_phone,
        st_address = @st_address,
        st_dob     = @st_dob
    where st_id = @st_id;
end
go
 
-- 3.3 search students
create or alter procedure sp_search_students
    @search_term varchar(100) = null,
    @in_id       int          = null
as
begin
    set nocount on;
 
    select s.st_id, s.st_name, s.st_email, s.st_phone,
           i.in_name, i.in_year
    from   students s
    join   intake   i on s.in_id = i.in_id
    where  (@search_term is null
            or s.st_name  like '%' + @search_term + '%'
            or s.st_email like '%' + @search_term + '%')
      and  (@in_id is null or s.in_id = @in_id);
end
go
 
-- 3.4 get student profile
create or alter procedure sp_get_student_profile
    @st_id int
as
begin
    set nocount on;
 
    select s.*, i.in_name, i.in_year
    from   students s
    join   intake   i on s.in_id = i.in_id
    where  s.st_id = @st_id;
end
go
 
-- 3.5 get students by intake
create or alter procedure sp_get_students_by_intake
    @in_id int
as
begin
    set nocount on;
 
    select s.st_id, s.st_name, s.st_email, s.st_phone, s.st_dob
    from   students s
    where  s.in_id = @in_id;
end
go

-- 4.1 add instructor
create or alter procedure sp_add_instructor
    @ins_name  varchar(100),
    @ins_email varchar(100),
    @ins_phone varchar(20),
    @hire_date date,
    @salary    decimal(10,2),
    @user_name nvarchar(50),
    @password  nvarchar(max)
as
begin
    set nocount on;
    begin transaction;
    begin try

        declare @new_user_id int;

        exec sp_add_userr 
            @user_name = @user_name,
            @password  = @password,
            @role      = 'instructor',
            @new_user_id = @new_user_id OUTPUT;

        insert into instructors (user_id, ins_name, ins_email, ins_phone, hire_date, salary)
        values (@new_user_id, @ins_name, @ins_email, @ins_phone, @hire_date, @salary);

        select scope_identity() as new_instructor_id;

        commit;
    end try
    begin catch
        rollback;
        throw;
    end catch
end
go

-- 4.2 assign instructor to course & intake
create or alter procedure sp_assign_instructor_course
    @ins_id int,
    @crs_id int,
    @in_id  int
as
begin
    set nocount on;
 
    if exists (select 1 from instructor_course
               where ins_id = @ins_id and crs_id = @crs_id and in_id = @in_id)
    begin
        raiserror('assignment already exists.', 16, 1);
        return;
    end
 
    insert into instructor_course (ins_id, crs_id, in_id)
    values (@ins_id, @crs_id, @in_id);
end
go
 
-- 4.3 get instructor courses
create or alter procedure sp_get_instructor_courses
    @ins_id int
as
begin
    set nocount on;
 
    select c.crs_id, c.crs_name, c.description,
           c.max_degree, c.min_degree, i.in_name
    from   instructor_course ic
    join   courses c on ic.crs_id = c.crs_id
    join   intake  i on ic.in_id  = i.in_id
    where  ic.ins_id = @ins_id;
end
go

-- module 5: course & question management
 
-- 5.1 add course
create or alter procedure sp_add_course
    @crs_name   varchar(100),
    @description varchar(500),
    @max_degree int,
    @min_degree int
as
begin
    set nocount on;
 
    if @min_degree >= @max_degree
    begin
        raiserror('min_degree must be less than max_degree.', 16, 1);
        return;
    end
 
    insert into courses (crs_name, description, max_degree, min_degree)
    values (@crs_name, @description, @max_degree, @min_degree);
 
    select scope_identity() as new_course_id;
end
go
 
-- 5.2 add question
create or alter procedure sp_add_question
    @q_text        varchar(max),
    @q_type        varchar(20),   -- 'mcq', 'truefalse', 'text'
    @correct_answer varchar(max),
    @crs_id        int,
    @created_by    int
as
begin
    set nocount on;
 
    if @q_type not in ('mcq','truefalse','text')
    begin
        raiserror('invalid question type. use mcq, truefalse, or text.', 16, 1);
        return;
    end
 
    insert into questions (q_text, q_type, correct_answer, crs_id, created_by)
    values (@q_text, @q_type, @correct_answer, @crs_id, @created_by);
 
    select scope_identity() as new_question_id;
end
go
 
-- 5.3 edit question
create or alter procedure sp_edit_question
    @q_id          int,
    @q_text        varchar(max),
    @correct_answer varchar(max)
as
begin
    set nocount on;
 
    update questions
    set q_text         = @q_text,
        correct_answer = @correct_answer
    where q_id = @q_id;
 
    if @@rowcount = 0 raiserror('question not found.', 16, 1);
end
go
 
-- 5.4 add choice to mcq / truefalse question
create or alter procedure sp_add_choice
    @q_id       int,
    @choice_text varchar(500),
    @iscorrect  char(1)   -- '1' for correct, '0' for wrong
as
begin
    set nocount on;
 
    insert into choices (q_id, choice_text, iscorrect)
    values (@q_id, @choice_text, @iscorrect);
 
    select scope_identity() as new_choice_id;
end
go
 
-- 5.5 search question pool
create or alter procedure sp_search_questions
    @crs_id  int          = null,
    @q_type  varchar(20)  = null,
    @keyword varchar(200) = null
as
begin
    set nocount on;
 
    select q.q_id, q.q_text, q.q_type, q.correct_answer,
           c.crs_name, i.ins_name, q.created_date
    from   questions   q
    join   courses     c on c.crs_id = q.crs_id
    join   instructors i on i.ins_id = q.created_by
    where  (@crs_id  is null or q.crs_id = @crs_id)
      and  (@q_type  is null or q.q_type = @q_type)
      and  (@keyword is null or q.q_text like '%' + @keyword + '%');
end
go

-- module 6: exam management
 
-- 6.1 create exam
create or alter procedure sp_create_exam
    @ex_type           varchar(20),
    @crs_id            int,
    @ins_id            int,
    @in_id             int,
    @ex_date           date,
    @start_time        time,
    @end_time          time,
    @total_time        int,
    @total_degree      int,
    @year              int,
    @allowance_options varchar(200) = null
as
begin
    set nocount on;
 
    -- validate total_degree does not exceed course max_degree
    declare @max_degree int;
    select @max_degree = max_degree from courses where crs_id = @crs_id;
 
    if @total_degree > @max_degree
    begin
        raiserror('exam total degree exceeds course max degree.', 16, 1);
        return;
    end
 
    if @end_time <= @start_time
    begin
        raiserror('end_time must be after start_time.', 16, 1);
        return;
    end
 
    insert into exams (ex_type, crs_id, ins_id, in_id, ex_date,
                       start_time, end_time, total_time, total_degree, year, allowance_options)
    values (@ex_type, @crs_id, @ins_id, @in_id, @ex_date,
            @start_time, @end_time, @total_time, @total_degree, @year, @allowance_options);
 
    select scope_identity() as new_exam_id;
end
go
 
-- 6.2 add question to exam manually
create or alter procedure sp_add_question_to_exam
    @ex_id    int,
    @q_id     int,
    @q_degree int
as
begin
    set nocount on;
 
    -- check cumulative degrees
    declare @current_total int, @exam_total int;
 
    select @current_total = isnull(sum(q_degree), 0)
    from   exam_questions where ex_id = @ex_id;
 
    select @exam_total = total_degree from exams where ex_id = @ex_id;
 
    if (@current_total + @q_degree) > @exam_total
    begin
        raiserror('adding this question exceeds exam total degree.', 16, 1);
        return;
    end
 
    if exists (select 1 from exam_questions where ex_id = @ex_id and q_id = @q_id)
    begin
        raiserror('question already in exam.', 16, 1);
        return;
    end
 
    insert into exam_questions (ex_id, q_id, q_degree)
    values (@ex_id, @q_id, @q_degree);
end
go
 
-- 6.3 auto-generate random exam questions
create or alter procedure sp_generate_random_exam
    @ex_id       int,
    @crs_id      int,
    @mcq_count   int,
    @tf_count    int,
    @text_count  int,
    @degree_per_q int
as
begin
    set nocount on;
 
    declare @total_needed int = @mcq_count + @tf_count + @text_count;
    declare @total_degree int = @total_needed * @degree_per_q;
    declare @exam_max     int;
 
    select @exam_max = total_degree from exams where ex_id = @ex_id;
 
    if @total_degree > @exam_max
    begin
        raiserror('generated questions total degree exceeds exam max.', 16, 1);
        return;
    end
 
    -- random mcq
    insert into exam_questions (ex_id, q_id, q_degree)
    select top (@mcq_count) @ex_id, q_id, @degree_per_q
    from   questions
    where  crs_id  = @crs_id
      and  q_type  = 'mcq'
      and  q_id not in (select q_id from exam_questions where ex_id = @ex_id)
    order by newid();
 
    -- random truefalse
    insert into exam_questions (ex_id, q_id, q_degree)
    select top (@tf_count) @ex_id, q_id, @degree_per_q
    from   questions
    where  crs_id  = @crs_id
      and  q_type  = 'truefalse'
      and  q_id not in (select q_id from exam_questions where ex_id = @ex_id)
    order by newid();
 
    -- random text
    insert into exam_questions (ex_id, q_id, q_degree)
    select top (@text_count) @ex_id, q_id, @degree_per_q
    from   questions
    where  crs_id  = @crs_id
      and  q_type  = 'text'
      and  q_id not in (select q_id from exam_questions where ex_id = @ex_id)
    order by newid();
 
    print 'exam questions generated successfully.';
end
go
 
-- 6.4 assign student to exam
create or alter procedure sp_assign_student_to_exam
    @st_id             int,
    @ex_id             int,
    @actual_start_time datetime,
    @actual_end_time   datetime
as
begin
    set nocount on;
 
    if exists (select 1 from student_exam where st_id = @st_id and ex_id = @ex_id)
    begin
        raiserror('student already assigned to this exam.', 16, 1);
        return;
    end
 
    insert into student_exam (st_id, ex_id, actual_start_time, actual_end_time)
    values (@st_id, @ex_id, @actual_start_time, @actual_end_time);
end
go
 
-- 6.5 get exam details with questions
create or alter procedure sp_get_exam_details
    @ex_id int
as
begin
    set nocount on;
 
    -- exam info
    select e.*, c.crs_name, i.ins_name, intk.in_name
    from   exams       e
    join   courses     c    on c.crs_id = e.crs_id
    join   instructors i    on i.ins_id = e.ins_id
    join   intake      intk on intk.in_id = e.in_id
    where  e.ex_id = @ex_id;
 
    -- questions in exam
    select eq.q_id, q.q_text, q.q_type, eq.q_degree
    from   exam_questions eq
    join   questions      q  on q.q_id = eq.q_id
    where  eq.ex_id = @ex_id;
end
go
 
-- 6.6 get exam for student (time-gated, no correct answers)
create or alter procedure sp_get_student_exam
    @st_id int,
    @ex_id int
as
begin
    set nocount on;
 
    declare @now   datetime = getdate();
    declare @start datetime, @end datetime;
 
    select @start = actual_start_time, @end = actual_end_time
    from   student_exam
    where  st_id = @st_id and ex_id = @ex_id;
 
    if @start is null
    begin
        raiserror('student is not assigned to this exam.', 16, 1);
        return;
    end
 
    if @now < @start or @now > @end
    begin
        raiserror('exam is not available at this time.', 16, 1);
        return;
    end
 
    -- return questions and choices WITHOUT correct answer
    select eq.q_id, q.q_text, q.q_type, eq.q_degree,
           ch.ch_id, ch.choice_text
    from   exam_questions eq
    join   questions      q  on q.q_id  = eq.q_id
    left join choices     ch on ch.q_id = q.q_id
    where  eq.ex_id = @ex_id
    order  by eq.q_id, ch.ch_id;
end
go
 
-- 6.7 search exams
create or alter procedure sp_search_exams
    @crs_id  int         = null,
    @in_id   int         = null,
    @ins_id  int         = null,
    @ex_type varchar(20) = null,
    @year    int         = null
as
begin
    set nocount on;
 
    select e.ex_id, e.ex_type, e.ex_date, e.year,
           e.total_degree, e.total_time,
           c.crs_name, i.ins_name, intk.in_name
    from   exams       e
    join   courses     c    on c.crs_id   = e.crs_id
    join   instructors i    on i.ins_id   = e.ins_id
    join   intake      intk on intk.in_id = e.in_id
    where  (@crs_id  is null or e.crs_id  = @crs_id)
      and  (@in_id   is null or e.in_id   = @in_id)
      and  (@ins_id  is null or e.ins_id  = @ins_id)
      and  (@ex_type is null or e.ex_type = @ex_type)
      and  (@year    is null or e.year    = @year);
end
go
 
-- 6.8 get all exams for a course
create or alter procedure sp_get_exams_by_course
    @crs_id int
as
begin
    set nocount on;
 
    select e.ex_id, e.ex_type, e.ex_date, e.total_degree,
           e.start_time, e.end_time, i.ins_name
    from   exams       e
    join   instructors i on i.ins_id = e.ins_id
    where  e.crs_id = @crs_id
    order  by e.ex_date desc;
end
go

-- module 7: answer & grading
 
-- 7.1 submit student answer
create or alter procedure sp_submit_answer
    @st_id          int,
    @ex_id          int,
    @q_id           int,
    @student_answer varchar(max)
as
begin
    set nocount on;
 
    if exists (select 1 from student_answers
               where st_id = @st_id and ex_id = @ex_id and q_id = @q_id)
    begin
        raiserror('answer already submitted for this question.', 16, 1);
        return;
    end
 
    declare @q_type         varchar(20);
    declare @correct_answer varchar(max);
    declare @is_correct     bit = 0;
    declare @obtained_marks decimal(5,2) = 0;
    declare @q_degree       int;
 
    select @q_type         = q_type,
           @correct_answer = correct_answer
    from   questions where q_id = @q_id;
 
    select @q_degree = q_degree
    from   exam_questions where ex_id = @ex_id and q_id = @q_id;
 
    -- auto-check mcq and truefalse
    if @q_type in ('mcq', 'truefalse')
    begin
        if ltrim(rtrim(upper(@student_answer))) = ltrim(rtrim(upper(@correct_answer)))
        begin
            set @is_correct     = 1;
            set @obtained_marks = @q_degree;
        end
    end
    -- text: stays 0 until instructor grades manually
 
    insert into student_answers
        (st_id, ex_id, q_id, student_answer, is_correct, obtained_marks)
    values
        (@st_id, @ex_id, @q_id, @student_answer, @is_correct, @obtained_marks);
end
go
 
-- 7.2 calculate student final result
create or alter procedure sp_calculate_student_result
    @st_id int,
    @ex_id int
as
begin
    set nocount on;
 
    declare @total_score decimal(5,2);
    declare @min_degree  int;
 
    select @total_score = sum(obtained_marks)
    from   student_answers
    where  st_id = @st_id and ex_id = @ex_id;
 
    select @min_degree = c.min_degree
    from   exams e join courses c on c.crs_id = e.crs_id
    where  e.ex_id = @ex_id;
 
    update student_exam
    set total_score     = @total_score,
        obtained_degree = @total_score
    where st_id = @st_id and ex_id = @ex_id;
 
    select @total_score as total_score,
           @min_degree  as passing_degree,
           case when @total_score >= @min_degree then 'pass' else 'fail' end as result;
end
go
 
-- 7.3 manually grade text answer (instructor)
create or alter procedure sp_grade_text_answer
    @st_id      int,
    @ex_id      int,
    @q_id       int,
    @obtained_marks decimal(5,2),
    @is_correct bit
as
begin
    set nocount on;
 
    declare @q_degree int;
    select @q_degree = q_degree
    from   exam_questions where ex_id = @ex_id and q_id = @q_id;
 
    if @obtained_marks > @q_degree
    begin
        raiserror('marks cannot exceed question degree.', 16, 1);
        return;
    end
 
    update student_answers
    set obtained_marks = @obtained_marks,
        is_correct     = @is_correct
    where st_id = @st_id and ex_id = @ex_id and q_id = @q_id;
 
    print 'answer graded successfully.';
end
go
 
-- 7.4 get text answers pending review (instructor)
create or alter procedure sp_get_pending_text_answers
    @ex_id  int,
    @ins_id int
as
begin
    set nocount on;
 
    select sa.st_id, s.st_name,
           sa.q_id, q.q_text, q.correct_answer,
           sa.student_answer, sa.obtained_marks, sa.is_correct,
           eq.q_degree
    from   student_answers sa
    join   students        s  on s.st_id  = sa.st_id
    join   questions       q  on q.q_id   = sa.q_id
    join   exam_questions  eq on eq.ex_id = sa.ex_id and eq.q_id = sa.q_id
    join   exams           e  on e.ex_id  = sa.ex_id
    where  sa.ex_id = @ex_id
      and  q.q_type = 'text'
      and  e.ins_id = @ins_id
    order  by sa.st_id, sa.q_id;
end
go
 
-- 7.5 get full exam results (instructor view)
create or alter procedure sp_get_exam_results
    @ex_id int
as
begin
    set nocount on;
 
    select s.st_id, s.st_name,
           se.total_score, se.obtained_degree,
           e.total_degree,
           case when se.total_score >= c.min_degree then 'pass' else 'fail' end as status
    from   student_exam se
    join   students     s on s.st_id  = se.st_id
    join   exams        e on e.ex_id  = se.ex_id
    join   courses      c on c.crs_id = e.crs_id
    where  se.ex_id = @ex_id
    order  by se.total_score desc;
end
go
 
-- 7.6 get student result summary (student view)
create or alter procedure sp_get_my_results
    @st_id int
as
begin
    set nocount on;
 
    select e.ex_id, e.ex_date, e.ex_type,
           c.crs_name, se.total_score, e.total_degree,
           case when se.total_score >= c.min_degree then 'pass' else 'fail' end as status
    from   student_exam se
    join   exams   e on e.ex_id  = se.ex_id
    join   courses c on c.crs_id = e.crs_id
    where  se.st_id = @st_id
    order  by e.ex_date desc;
end
go
 
-- 7.7 get student detailed answers
create or alter procedure sp_get_student_answer_details
    @st_id int,
    @ex_id int
as
begin
    set nocount on;
 
    select q.q_id, q.q_text, q.q_type,
           sa.student_answer, sa.is_correct,
           sa.obtained_marks, eq.q_degree
    from   student_answers sa
    join   questions      q  on q.q_id  = sa.q_id
    join   exam_questions eq on eq.ex_id = sa.ex_id and eq.q_id = sa.q_id
    where  sa.st_id = @st_id and sa.ex_id = @ex_id
    order  by q.q_id;
end
go
-- add training manager
create or alter procedure sp_add_training_manager
    @mgr_name  varchar(100),
    @mgr_email varchar(100),
    @mgr_phone varchar(20),
    @user_name nvarchar(50),
    @password  nvarchar(max)
as
begin
    set nocount on;
    begin transaction;
    begin try

        declare @new_user_id int;

        exec sp_add_userr
            @user_name = @user_name,
            @password  = @password,
            @role      = 'training_manager',
            @new_user_id = @new_user_id OUTPUT;

        insert into training_managers (user_id, mgr_name, mgr_email, mgr_phone)
        values (@new_user_id, @mgr_name, @mgr_email, @mgr_phone);

        select scope_identity() as new_manager_id;

        commit;
    end try
    begin catch
        rollback;
        throw;
    end catch
end
go

DECLARE @admin_id INT;
 

 
EXEC sp_add_userr 
    @user_name = 'admin01',
    @password  = 'Admin@123',
    @role      = 'admin',
    @new_user_id = @admin_id OUTPUT;

 
DECLARE @id INT;
EXEC sp_add_userr 
    @user_name = 'ahmed',
    @password  = '123',
    @role      = 'student',
    @new_user_id = @id OUTPUT;
 
EXEC sp_add_training_manager 
    'Fatma Manager', 
    'fatma.mgr@iti.eg', 
    '01001112222', 
    'mgr01', 
    'Mgr@123';
GO
--Add Branches
EXEC sp_add_branch 'Branch 1', 'Location 1, Egypt';
EXEC sp_add_branch 'Branch 2', 'Location 2, Egypt';
EXEC sp_add_branch 'Branch 3', 'Location 3, Egypt';
EXEC sp_add_branch 'Branch 4', 'Location 4, Egypt';
EXEC sp_add_branch 'Branch 5', 'Location 5, Egypt';
EXEC sp_add_branch 'Branch 6', 'Location 6, Egypt';
EXEC sp_add_branch 'Branch 7', 'Location 7, Egypt';
EXEC sp_add_branch 'Branch 8', 'Location 8, Egypt';
EXEC sp_add_branch 'Branch 9', 'Location 9, Egypt';
EXEC sp_add_branch 'Branch 10', 'Location 10, Egypt';

-- 3. Add 10 Tracks
EXEC sp_add_track '.net', 'Description of track 1';
EXEC sp_add_track 'node', 'Description of track 2';
EXEC sp_add_track 'flutter', 'Description of track 3';
EXEC sp_add_track 'mopile app', 'Description of track 4';
EXEC sp_add_track 'ai', 'Description of track 5';
EXEC sp_add_track 'ml', 'Description of track 6';
EXEC sp_add_track 'data science', 'Description of track 7';
EXEC sp_add_track 'nlp', 'Description of track 8';
EXEC sp_add_track 'pi', 'Description of track 9';
EXEC sp_add_track 'data engineer', 'Description of track 10';



-- 4. Assign Track to Branch + Add 10 Intakes
EXEC sp_assign_track_to_branch 1, 1, '2025-09-01';
EXEC sp_assign_track_to_branch 2, 2, '2025-09-01';
EXEC sp_assign_track_to_branch 3, 3, '2025-09-01';
EXEC sp_assign_track_to_branch 4, 4, '2025-09-01';
EXEC sp_assign_track_to_branch 5, 5, '2025-09-01';
EXEC sp_assign_track_to_branch 6, 6, '2025-09-01';
EXEC sp_assign_track_to_branch 7, 7, '2025-09-01';
EXEC sp_assign_track_to_branch 8, 8, '2025-09-01';
EXEC sp_assign_track_to_branch 9, 9, '2025-09-01';
EXEC sp_assign_track_to_branch 10,10, '2025-09-01';

EXEC sp_add_intake 'Intake 41', 2025, 1, 1;
EXEC sp_add_intake 'Intake 42', 2025, 2, 2;
EXEC sp_add_intake 'Intake 43', 2025, 3, 3;
EXEC sp_add_intake 'Intake 44', 2025, 4, 4;
EXEC sp_add_intake 'Intake 45', 2025, 5, 5;
EXEC sp_add_intake 'Intake 46', 2025, 6, 6;
EXEC sp_add_intake 'Intake 47', 2025, 7, 7;
EXEC sp_add_intake 'Intake 48', 2025, 8, 8;
EXEC sp_add_intake 'Intake 49', 2025, 9, 9;
EXEC sp_add_intake 'Intake 50', 2025, 10,10;
 

EXEC sp_add_instructor 'Ahmed Mohammed', 'ahmed.mohammed@iti.eg',    '01001110001', '2022-01-15', 15000.00, 'ins_ahmed1',  'Ins@123';
EXEC sp_add_instructor 'Ali Ahmed',       'ali.ahmed@iti.eg',        '01001110002', '2022-01-15', 16000.00, 'ins_ali2',     'Ins@123';
EXEC sp_add_instructor 'Omar Khaled',     'omar.khaled@iti.eg',      '01001110003', '2022-01-15', 17000.00, 'ins_omar3',    'Ins@123';
EXEC sp_add_instructor 'Nour Hassan',     'nour.hassan@iti.eg',      '01001110004', '2022-01-15', 18000.00, 'ins_nour4',    'Ins@123';
EXEC sp_add_instructor 'Mariam Ali',      'mariam.ali@iti.eg',       '01001110005', '2022-01-15', 19000.00, 'ins_mariam5',  'Ins@123';
EXEC sp_add_instructor 'Alyaa Mahmoud',   'alyaa.mahmoud@iti.eg',    '01001110006', '2022-01-15', 20000.00, 'ins_alyaa6',   'Ins@123';
EXEC sp_add_instructor 'Nader Ibrahim',   'nader.ibrahim@iti.eg',    '01001110007', '2022-01-15', 21000.00, 'ins_nader7',   'Ins@123';
EXEC sp_add_instructor 'Mostafa Hassan',  'mostafa.hassan@iti.eg',   '01001110008', '2022-01-15', 22000.00, 'ins_mostafa8', 'Ins@123';
EXEC sp_add_instructor 'Abdelrahman Said','abdelrahman.said@iti.eg', '01001110009', '2022-01-15', 23000.00, 'ins_abdel9',   'Ins@123';
EXEC sp_add_instructor 'Youssef Ahmed',   'youssef.ahmed@iti.eg',    '01001110010', '2022-01-15', 24000.00, 'ins_youssef10','Ins@123';

GO

EXEC sp_add_course 'OOP', 'Description for course 1', 100, 50;
EXEC sp_add_course 'DB', 'Description for course 2', 100, 50;
EXEC sp_add_course 'DS', 'Description for course 3', 100, 50;
EXEC sp_add_course 'C#', 'Description for course 4', 100, 50;
EXEC sp_add_course 'LINQ', 'Description for course 5', 100, 50;
EXEC sp_add_course 'API', 'Description for course 6', 100, 50;
EXEC sp_add_course 'MVC', 'Description for course 7', 100, 50;
EXEC sp_add_course 'PYTHON', 'Description for course 8', 100, 50;
EXEC sp_add_course 'OS', 'Description for course 9', 100, 50;
EXEC sp_add_course 'NW','Description for course 10',100, 50;
DELETE FROM students;
DELETE FROM users WHERE role = 'student';
--Students
EXEC sp_add_student 'Ali', 'sta@mail.com', '0110000001', 'Cairo, Area 1', '2003-01-01', 1, 'st1', 'St@123';
EXEC sp_add_student 'Omar', 'stb@mail.com', '0110000002', 'Cairo, Area 2', '2003-02-01', 2, 'st2', 'St@123';
EXEC sp_add_student 'Yamen', 'stc@mail.com', '0110000003', 'Cairo, Area 3', '2003-03-01', 3, 'st3', 'St@123';
EXEC sp_add_student 'Kenan', 'std@mail.com', '0110000004', 'Cairo, Area 4', '2003-04-01', 4, 'st4', 'St@123';
EXEC sp_add_student 'Malek', 'ste@mail.com', '0110000005', 'Cairo, Area 5', '2003-05-01', 5, 'st5', 'St@123';
EXEC sp_add_student 'Yousseif', 'stf@mail.com', '0110000006', 'Cairo, Area 6', '2003-06-01', 6, 'st6', 'St@123';
EXEC sp_add_student 'Nedal', 'stg@mail.com', '0110000007', 'Cairo, Area 7', '2003-07-01', 7, 'st7', 'St@123';
EXEC sp_add_student 'Leen', 'sth@mail.com', '0110000008', 'Cairo, Area 8', '2003-08-01', 8, 'st8', 'St@123';
EXEC sp_add_student 'Nour', 'sti@mail.com', '0110000009', 'Cairo, Area 9', '2003-09-01', 9, 'st9', 'St@123';
EXEC sp_add_student 'Mariam', 'stj@mail.com', '0110000010', 'Cairo, Area 10','2003-10-01',10,'st10','St@123';
 
 --Questions + Choices
   
EXEC sp_add_question 'What is SQL?', 'mcq', 'Query Language', 1, 13;
EXEC sp_add_question 'What is primary key?', 'mcq', 'Unique Identifier', 1, 10;
EXEC sp_add_question 'SQL is a programming language', 'truefalse', 'True', 1, 14;
EXEC sp_add_question 'Explain normalization', 'text', 'Normalization explanation', 1, 11;


-- choices
DELETE FROM choices;
-- Q1
EXEC sp_add_choice 4, 'Query Language', '1';
EXEC sp_add_choice 4, 'Design Tool', '0';

-- Q2
EXEC sp_add_choice 5, 'Unique Identifier', '1';
EXEC sp_add_choice 5, 'Duplicate Data', '0';
 

-- Q3
EXEC sp_add_choice 10, 'True', '1';
EXEC sp_add_choice 10, 'False', '0';

--Exams
EXEC sp_create_exam 
    'exam',   -- ??? mcq
    1,
    14,
    1,
    '2025-10-01',
    '10:00',
    '12:00',
    120,
    100,
    2025,
    NULL;

 -- Add Questions to Exam

EXEC sp_add_question_to_exam 3, 4, 30;
EXEC sp_add_question_to_exam 3, 7, 30;
EXEC sp_add_question_to_exam 3, 9, 20;
EXEC sp_add_question_to_exam 3, 5, 20;


--Assign Students to Exam
EXEC sp_assign_student_to_exam 10, 3, '2025-10-01 10:00', '2025-10-01 12:00';
EXEC sp_assign_student_to_exam 9, 3, '2025-10-01 10:00', '2025-10-01 12:00';
EXEC sp_assign_student_to_exam 6, 3, '2025-10-01 10:00', '2025-10-01 12:00';

--Student Answers
EXEC sp_submit_answer 10, 3, 4, 'Query Language';
EXEC sp_submit_answer 10, 3, 5, 'Unique Identifier';
EXEC sp_submit_answer 10, 3, 10, 'True';


EXEC sp_submit_answer 9, 3, 4, 'Wrong Answer';
EXEC sp_submit_answer 9, 3, 5, 'Unique Identifier';
EXEC sp_submit_answer 9, 3, 10, 'False';

--Calculate Result
EXEC sp_calculate_student_result 10, 3;
EXEC sp_calculate_student_result 9, 3;

--instructor course 
EXEC sp_assign_instructor_course 
    6,   -- ins_id
    1,   -- course_id
    1;   -- intake_id

EXEC sp_assign_instructor_course 
    8,    
    4,   
    2;    


EXEC sp_assign_instructor_course 
    9,   
    5,   
    6;    

 