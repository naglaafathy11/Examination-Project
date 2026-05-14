CREATE TABLE users
(
    user_id int identity Primary Key,
    user_name nvarchar(50) Unique NOT NULL,
    password nvarchar(MAX),
    role varchar(50) CHECK (role IN ('admin','student','training_manager','instructor')),
    is_active BIT default 1,
    created_date Datetime default GETDATE()
)ON FG_usrs


CREATE TABLE branches
(
    br_id int identity Primary Key,
    br_name varchar(100),
    br_location varchar(100)
)on [primary]

CREATE TABLE tracks
(
    tr_id int identity Primary Key,
    tr_name varchar(100),
    tr_description varchar(200)
)on [primary]

CREATE TABLE branch_track
(
    br_id int,
    tr_id int,
    start_date DATE,

    PRIMARY KEY (br_id, tr_id),

   Foreign key (br_id) REFERENCES branches(br_id),
   Foreign key (tr_id) REFERENCES tracks(tr_id)
)on [primary]

CREATE TABLE intake
(
    in_id int identity Primary Key,
    in_name VARCHAR(50),
    in_year int,
    br_id int,
    tr_id int,

    FOREIGN KEY (br_id, tr_id) REFERENCES branch_track(br_id, tr_id)
)on [primary]

CREATE TABLE students
(
    st_id int identity Primary Key,
    user_id int unique,
    st_name varchar(100),
    st_email varchar(100) UNIQUE,
    st_phone varchar(20),
    st_address varchar(200),
    st_dob date,
    in_id int,

    Foreign key (user_id) REferences users(user_id),
  Foreign key (in_id) References intake(in_id)
)on FG_usrs

CREATE TABLE instructors
(
    ins_id int identity Primary Key,
    user_id INT UNIQUE,
    ins_name VARCHAR(100),
    ins_email VARCHAR(100) UNIQUE,
    ins_phone VARCHAR(20),
    hire_date DATE,
    salary DECIMAL(10,2),

    Foreign key (user_id) References users(user_id)
)on FG_usrs


CREATE TABLE training_managers
(
    mgr_id int identity Primary Key,
    user_id int Unique,
    mgr_name varchar(100),
    mgr_email varchar(100),
    mgr_phone varchar(20),

   Foreign key (user_id) References users(user_id)
)on FG_usrs

CREATE TABLE courses
(
    crs_id int identity Primary Key,
    crs_name varchar(100),
    description varchar(500),
    max_degree int,
    min_degree int,

    CHECK (min_degree < max_degree)
)on [primary]

CREATE TABLE instructor_course
(
    ins_id int,
    crs_id int,
    in_id int,

    PRIMARY KEY (ins_id, crs_id, in_id),

    Foreign key (ins_id) References instructors(ins_id),
    Foreign key (crs_id) References courses(crs_id),
    Foreign key (in_id) References intake(in_id)
)on [primary]

CREATE TABLE exams
(
    ex_id int identity Primary Key,
    ex_type varchar(20) CHECK (ex_type IN ('exam','corrective')),
    crs_id int,
    ins_id int,
    in_id int,
    ex_date Date,
    start_time Time,
    end_time Time,
    total_time int,
    total_degree int,
    year int,
    allowance_options varchar(200),

   Foreign key (crs_id) References courses(crs_id),
   Foreign key (ins_id) References instructors(ins_id),
   Foreign key (in_id) References intake(in_id),

    CHECK (end_time > start_time)
)on FG_Exams;

CREATE TABLE questions
(
    q_id int identity Primary Key,
    q_text varchar(MAX),
    q_type varchar(20) CHECK (q_type IN ('mcq','truefalse','text')),
    correct_answer VARCHAR(MAX),
    crs_id int,
    created_by int,
    created_date DateTime Default GETDATE(),

    Foreign key (crs_id) References courses(crs_id),
   Foreign key (created_by) References instructors(ins_id)
)on[primary]

CREATE TABLE exam_questions
(
    ex_id int,
    q_id int,
    q_degree int,

  Primary Key (ex_id, q_id),

   Foreign key (ex_id) References exams(ex_id) ON DELETE CASCADE,
  Foreign key (q_id) References questions(q_id)
)on FG_Exams;

CREATE TABLE choices
(
    ch_id int identity Primary Key,
    q_id int,
    choice_text varchar(500),
    Iscorrect char(1),

    Foreign key  (q_id) References questions(q_id) ON DELETE CASCADE,
    unique (q_id, Iscorrect)
)on[primary]

CREATE TABLE student_exam
(
    st_id int,
    ex_id int,
    actual_start_time Datetime,
    actual_end_time Datetime,
    total_score decimal(5,2),
    obtained_degree decimal(5,2),

   Primary Key (st_id, ex_id),

    Foreign key (st_id) References students(st_id),
    Foreign key (ex_id) References exams(ex_id)
)ON FG_Exams;


CREATE TABLE student_answers
(
    ans_id int identity Primary Key,
    st_id int,
    ex_id int,
    q_id int,
    student_answer varchar(MAX),
    is_correct bit,
    obtained_marks decimal(5,2),
    ans_at datetime default GETDATE(),

    Foreign key (st_id, ex_id) References student_exam(st_id, ex_id),
    Foreign key (q_id) References questions(q_id),

    unique (st_id, ex_id, q_id)
)ON FG_Exams;



