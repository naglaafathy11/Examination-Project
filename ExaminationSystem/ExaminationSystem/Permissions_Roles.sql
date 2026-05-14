
use master;
go

if exists (select 1 from sys.server_principals where name = 'ExamAdmin')
    drop login ExamAdmin;
if exists (select 1 from sys.server_principals where name = 'ExamTrainingManager')
    drop login ExamTrainingManager;
if exists (select 1 from sys.server_principals where name = 'ExamInstructor')
    drop login ExamInstructor;
if exists (select 1 from sys.server_principals where name = 'ExamStudent')
    drop login ExamStudent;
go

create login ExamAdmin           with password = 'Admin@123!Secure';
create login ExamTrainingManager with password = 'Manager@123!Secure';
create login ExamInstructor      with password = 'Instructor@123!Secure';
create login ExamStudent         with password = 'Student@123!Secure';
go


-- ============================================================================
-- step 2: create database users
-- ============================================================================
use Examnation_System;
go

if exists (select 1 from sys.database_principals where name = 'ExamAdminUser')
    drop user ExamAdminUser;
if exists (select 1 from sys.database_principals where name = 'ExamTrainingManagerUser')
    drop user ExamTrainingManagerUser;
if exists (select 1 from sys.database_principals where name = 'ExamInstructorUser')
    drop user ExamInstructorUser;
if exists (select 1 from sys.database_principals where name = 'ExamStudentUser')
    drop user ExamStudentUser;
go

create user ExamAdminUser           for login ExamAdmin;
create user ExamTrainingManagerUser for login ExamTrainingManager;
create user ExamInstructorUser      for login ExamInstructor;
create user ExamStudentUser         for login ExamStudent;
go


-- ============================================================================
-- step 3: create roles
-- ============================================================================
if exists (select 1 from sys.database_principals where name = 'AdminRole'           and type = 'R') drop role AdminRole;
if exists (select 1 from sys.database_principals where name = 'TrainingManagerRole' and type = 'R') drop role TrainingManagerRole;
if exists (select 1 from sys.database_principals where name = 'InstructorRole'      and type = 'R') drop role InstructorRole;
if exists (select 1 from sys.database_principals where name = 'StudentRole'         and type = 'R') drop role StudentRole;
go

create role AdminRole;
create role TrainingManagerRole;
create role InstructorRole;
create role StudentRole;
go

-- assign users to roles
alter role AdminRole           add member ExamAdminUser;
alter role TrainingManagerRole add member ExamTrainingManagerUser;
alter role InstructorRole      add member ExamInstructorUser;
alter role StudentRole         add member ExamStudentUser;

-- admin gets full access
alter role db_owner add member ExamAdminUser;
go


-- ============================================================================
-- step 4: training manager permissions
-- can: manage branches, tracks, intakes, students, instructors, managers
--      read-only on exams and results for reporting
-- ============================================================================

-- tables
grant select, insert, update, delete on branches          to TrainingManagerRole;
grant select, insert, update, delete on tracks            to TrainingManagerRole;
grant select, insert, update, delete on branch_track      to TrainingManagerRole;
grant select, insert, update, delete on intake            to TrainingManagerRole;
grant select, insert, update, delete on users             to TrainingManagerRole;
grant select, insert, update, delete on students          to TrainingManagerRole;
grant select, insert, update, delete on instructors       to TrainingManagerRole;
grant select, insert, update, delete on training_managers to TrainingManagerRole;
grant select, insert, update, delete on courses           to TrainingManagerRole;
grant select, insert, update, delete on instructor_course to TrainingManagerRole;

-- read-only on exam tables
grant select on exams           to TrainingManagerRole;
grant select on questions       to TrainingManagerRole;
grant select on choices         to TrainingManagerRole;
grant select on exam_questions  to TrainingManagerRole;
grant select on student_exam    to TrainingManagerRole;
grant select on student_answers to TrainingManagerRole;

-- stored procedures
grant execute on sp_add_userr              to TrainingManagerRole;
grant execute on sp_set_user_status        to TrainingManagerRole;
grant execute on sp_change_password        to TrainingManagerRole;
grant execute on sp_add_branch             to TrainingManagerRole;
grant execute on sp_edit_branch            to TrainingManagerRole;
grant execute on sp_add_track              to TrainingManagerRole;
grant execute on sp_edit_track             to TrainingManagerRole;
grant execute on sp_assign_track_to_branch to TrainingManagerRole;
grant execute on sp_add_intake             to TrainingManagerRole;
grant execute on sp_edit_intake            to TrainingManagerRole;
grant execute on sp_add_student            to TrainingManagerRole;
grant execute on sp_edit_student           to TrainingManagerRole;
grant execute on sp_search_students        to TrainingManagerRole;
grant execute on sp_get_student_profile    to TrainingManagerRole;
grant execute on sp_get_students_by_intake to TrainingManagerRole;
grant execute on sp_add_instructor         to TrainingManagerRole;
grant execute on sp_assign_instructor_course to TrainingManagerRole;
grant execute on sp_get_instructor_courses to TrainingManagerRole;
grant execute on sp_add_course             to TrainingManagerRole;
grant execute on sp_add_training_manager   to TrainingManagerRole;

-- views
grant select on vw_student_results         to TrainingManagerRole;
grant select on vw_student_answers_details to TrainingManagerRole;
grant select on vw_exam_questions_count    to TrainingManagerRole;
grant select on vw_question_scores         to TrainingManagerRole;
grant select on vw_instructor_courses      to TrainingManagerRole;
grant select on vw_students_per_intake     to TrainingManagerRole;
grant select on vw_top_students            to TrainingManagerRole;
grant select on vw_failed_students         to TrainingManagerRole;
grant select on vw_course_success_rate     to TrainingManagerRole;
grant select on vw_exam_overview           to TrainingManagerRole;
grant select on vw_questions_per_course    to TrainingManagerRole;

-- functions
grant execute on fn_GetLetterGrade            to TrainingManagerRole;
grant execute on fn_PassOrFail                to TrainingManagerRole;
grant execute on fn_CountExamQuestions        to TrainingManagerRole;
grant execute on fn_CoursePassRate            to TrainingManagerRole;
grant execute on fn_IsUsernameAvailable       to TrainingManagerRole;
grant select  on fn_StudentExamHistory        to TrainingManagerRole;
grant select  on fn_ExamScoreboard            to TrainingManagerRole;
grant select  on fn_StudentPerformanceSummary to TrainingManagerRole;
grant select  on fn_CorrectiveCandidates      to TrainingManagerRole;

go


-- ============================================================================
-- step 5: instructor permissions
-- can: manage questions + exams + grade answers
--      read-only on students and structure
-- ============================================================================

-- tables: read-only on structure
grant select on branches          to InstructorRole;
grant select on tracks            to InstructorRole;
grant select on branch_track      to InstructorRole;
grant select on intake            to InstructorRole;
grant select on users             to InstructorRole;
grant select on students          to InstructorRole;
grant select on instructors       to InstructorRole;
grant select on courses           to InstructorRole;
grant select on instructor_course to InstructorRole;

-- tables: full access on questions and exams
grant select, insert, update         on questions       to InstructorRole;
grant select, insert, update, delete on choices         to InstructorRole;
grant select, insert, update         on exams           to InstructorRole;
grant select, insert, update, delete on exam_questions  to InstructorRole;
grant select, insert, update         on student_exam    to InstructorRole;
grant select, update                 on student_answers to InstructorRole;

-- stored procedures
grant execute on sp_add_question             to InstructorRole;
grant execute on sp_edit_question            to InstructorRole;
grant execute on sp_add_choice               to InstructorRole;
grant execute on sp_search_questions         to InstructorRole;
grant execute on sp_create_exam              to InstructorRole;
grant execute on sp_add_question_to_exam     to InstructorRole;
grant execute on sp_generate_random_exam     to InstructorRole;
grant execute on sp_assign_student_to_exam   to InstructorRole;
grant execute on sp_get_exam_details         to InstructorRole;
grant execute on sp_search_exams             to InstructorRole;
grant execute on sp_get_exams_by_course      to InstructorRole;
grant execute on sp_grade_text_answer        to InstructorRole;
grant execute on sp_get_pending_text_answers to InstructorRole;
grant execute on sp_get_exam_results         to InstructorRole;
grant execute on sp_calculate_student_result to InstructorRole;

-- views
grant select on vw_student_results         to InstructorRole;
grant select on vw_student_answers_details to InstructorRole;
grant select on vw_exam_questions_count    to InstructorRole;
grant select on vw_question_scores         to InstructorRole;
grant select on vw_instructor_courses      to InstructorRole;
grant select on vw_students_per_intake     to InstructorRole;
grant select on vw_top_students            to InstructorRole;
grant select on vw_failed_students         to InstructorRole;
grant select on vw_course_success_rate     to InstructorRole;
grant select on vw_exam_overview           to InstructorRole;
grant select on vw_questions_per_course    to InstructorRole;

-- functions
grant execute on fn_GetLetterGrade            to InstructorRole;
grant execute on fn_PassOrFail                to InstructorRole;
grant execute on fn_CountCorrectAnswers       to InstructorRole;
grant execute on fn_CountExamQuestions        to InstructorRole;
grant execute on fn_CoursePassRate            to InstructorRole;
grant execute on fn_ExamDurationMinutes       to InstructorRole;
grant select  on fn_StudentExamHistory        to InstructorRole;
grant select  on fn_ExamScoreboard            to InstructorRole;
grant select  on fn_CourseQuestionBank        to InstructorRole;
grant select  on fn_StudentAnswerSheet        to InstructorRole;
grant select  on fn_StudentPerformanceSummary to InstructorRole;
grant select  on fn_CorrectiveCandidates      to InstructorRole;
go


-- ============================================================================
-- step 6: student permissions
-- can: take exam, submit answers, view own results only
-- ============================================================================

-- tables: read-only on lookup data
grant select on users          to StudentRole;
grant select on students       to StudentRole;
grant select on courses        to StudentRole;
grant select on intake         to StudentRole;
grant select on branches       to StudentRole; 
grant select on tracks         to StudentRole;
grant select on exams          to StudentRole;
grant select on exam_questions to StudentRole;
grant select on questions      to StudentRole;
grant select on choices        to StudentRole;

-- tables: own exam records only
grant select                 on student_exam    to StudentRole;
grant select, insert, update on student_answers to StudentRole;

-- stored procedures
grant execute on sp_login                      to StudentRole;
grant execute on sp_change_password            to StudentRole;
grant execute on sp_get_student_exam           to StudentRole;
grant execute on sp_submit_answer              to StudentRole;
grant execute on sp_calculate_student_result   to StudentRole;
grant execute on sp_get_my_results             to StudentRole;
grant execute on sp_get_student_answer_details to StudentRole;
grant execute on sp_get_student_profile        to StudentRole;

-- views
grant select on vw_student_results         to StudentRole;
grant select on vw_student_answers_details to StudentRole;
grant select on vw_exam_overview           to StudentRole;

-- functions
grant execute on fn_GetLetterGrade      to StudentRole;
grant execute on fn_PassOrFail          to StudentRole;
grant execute on fn_ExamDurationMinutes to StudentRole;
grant select  on fn_StudentExamHistory  to StudentRole;
grant select  on fn_StudentAnswerSheet  to StudentRole;
go


-- ============================================================================
-- verification
-- ============================================================================
print '=== permissions applied successfully ===';
print '';
print 'logins:';
print '  admin:            ExamAdmin           / Admin@123!Secure';
print '  training manager: ExamTrainingManager / Manager@123!Secure';
print '  instructor:       ExamInstructor      / Instructor@123!Secure';
print '  student:          ExamStudent         / Student@123!Secure';
go

select
    dp.name          as role_name,
    o.name           as object_name,
    o.type_desc      as object_type,
    p.permission_name,
    p.state_desc     as grant_state
from sys.database_permissions p
join sys.database_principals dp on p.grantee_principal_id = dp.principal_id
join sys.objects o              on p.major_id             = o.object_id
where dp.name in ('TrainingManagerRole', 'InstructorRole', 'StudentRole')
order by dp.name, o.name, p.permission_name;