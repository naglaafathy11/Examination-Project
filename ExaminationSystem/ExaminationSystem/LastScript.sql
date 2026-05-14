USE [master]
GO
/****** Object:  Database [Examnation_System]    Script Date: 3/31/2026 9:21:09 PM ******/
CREATE DATABASE [Examnation_System]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Examnation_System_main', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Examnation_System_main.mdf' , SIZE = 102400KB , MAXSIZE = UNLIMITED, FILEGROWTH = 51200KB ), 
 FILEGROUP [FG_Exams] 
( NAME = N'Examnation_System_exams', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Examnation_System_exams.ndf' , SIZE = 102400KB , MAXSIZE = 1048576KB , FILEGROWTH = 51200KB ), 
 FILEGROUP [Fg_usrs] 
( NAME = N'Examnation_System_users', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Examnation_System_users.ndf' , SIZE = 51200KB , MAXSIZE = 512000KB , FILEGROWTH = 51200KB )
 LOG ON 
( NAME = N'Examnation_System_logs', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Examnation_System_logs.ldf' , SIZE = 51200KB , MAXSIZE = 512000KB , FILEGROWTH = 25600KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Examnation_System] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Examnation_System].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Examnation_System] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Examnation_System] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Examnation_System] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Examnation_System] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Examnation_System] SET ARITHABORT OFF 
GO
ALTER DATABASE [Examnation_System] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Examnation_System] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Examnation_System] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Examnation_System] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Examnation_System] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Examnation_System] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Examnation_System] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Examnation_System] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Examnation_System] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Examnation_System] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Examnation_System] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Examnation_System] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Examnation_System] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Examnation_System] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Examnation_System] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Examnation_System] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Examnation_System] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Examnation_System] SET RECOVERY FULL 
GO
ALTER DATABASE [Examnation_System] SET  MULTI_USER 
GO
ALTER DATABASE [Examnation_System] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Examnation_System] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Examnation_System] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Examnation_System] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Examnation_System] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Examnation_System] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Examnation_System', N'ON'
GO
ALTER DATABASE [Examnation_System] SET QUERY_STORE = ON
GO
ALTER DATABASE [Examnation_System] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Examnation_System]
GO
/****** Object:  User [ExamTrainingManagerUser]    Script Date: 3/31/2026 9:21:10 PM ******/
CREATE USER [ExamTrainingManagerUser] FOR LOGIN [ExamTrainingManager] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ExamStudentUser]    Script Date: 3/31/2026 9:21:10 PM ******/
CREATE USER [ExamStudentUser] FOR LOGIN [ExamStudent] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ExamInstructorUser]    Script Date: 3/31/2026 9:21:10 PM ******/
CREATE USER [ExamInstructorUser] FOR LOGIN [ExamInstructor] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [ExamAdminUser]    Script Date: 3/31/2026 9:21:10 PM ******/
CREATE USER [ExamAdminUser] FOR LOGIN [ExamAdmin] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  DatabaseRole [TrainingManagerRole]    Script Date: 3/31/2026 9:21:10 PM ******/
CREATE ROLE [TrainingManagerRole]
GO
/****** Object:  DatabaseRole [StudentRole]    Script Date: 3/31/2026 9:21:10 PM ******/
CREATE ROLE [StudentRole]
GO
/****** Object:  DatabaseRole [InstructorRole]    Script Date: 3/31/2026 9:21:10 PM ******/
CREATE ROLE [InstructorRole]
GO
/****** Object:  DatabaseRole [AdminRole]    Script Date: 3/31/2026 9:21:10 PM ******/
CREATE ROLE [AdminRole]
GO
ALTER ROLE [TrainingManagerRole] ADD MEMBER [ExamTrainingManagerUser]
GO
ALTER ROLE [StudentRole] ADD MEMBER [ExamStudentUser]
GO
ALTER ROLE [InstructorRole] ADD MEMBER [ExamInstructorUser]
GO
ALTER ROLE [AdminRole] ADD MEMBER [ExamAdminUser]
GO
ALTER ROLE [db_owner] ADD MEMBER [ExamAdminUser]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CountCorrectAnswers]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_CountCorrectAnswers]
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
/****** Object:  UserDefinedFunction [dbo].[fn_CountExamQuestions]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_CountExamQuestions]
(
    @ex_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @cnt INT
    SELECT @cnt = COUNT(*) FROM exam_questions WHERE ex_id = @ex_id
    RETURN ISNULL(@cnt, 0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CoursePassRate]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_CoursePassRate]
(
    @crs_id INT
)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @total  INT
    DECLARE @passed INT

    SELECT @total = COUNT(*)
    FROM student_exam se
    JOIN exams e ON e.ex_id = se.ex_id
    WHERE e.crs_id = @crs_id

    SELECT @passed = COUNT(*)
    FROM student_exam se
    JOIN exams   e ON e.ex_id  = se.ex_id
    JOIN courses c ON c.crs_id = e.crs_id
    WHERE e.crs_id = @crs_id AND se.obtained_degree >= c.min_degree

    RETURN CASE WHEN @total = 0 THEN 0
                ELSE CAST(@passed * 100.0 / @total AS DECIMAL(5,2))
           END
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ExamDurationMinutes]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_ExamDurationMinutes]
(
    @ex_id INT
)
RETURNS INT
AS
BEGIN
    DECLARE @dur INT
    SELECT @dur = DATEDIFF(MINUTE, start_time, end_time)
    FROM exams WHERE ex_id = @ex_id
    RETURN ISNULL(@dur, 0)
END
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetLetterGrade]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   FUNCTION [dbo].[fn_GetLetterGrade]
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
/****** Object:  UserDefinedFunction [dbo].[fn_IsUsernameAvailable]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_IsUsernameAvailable]
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
/****** Object:  UserDefinedFunction [dbo].[fn_PassOrFail]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_PassOrFail]
(
    @st_id INT,
    @ex_id INT
)
RETURNS VARCHAR(6)
AS
BEGIN
    DECLARE @obtained DECIMAL(5,2)
    DECLARE @min_deg  INT

    SELECT @obtained = se.obtained_degree,
           @min_deg  = c.min_degree
    FROM student_exam se
    JOIN exams   e ON e.ex_id  = se.ex_id
    JOIN courses c ON c.crs_id = e.crs_id
    WHERE se.st_id = @st_id AND se.ex_id = @ex_id

    RETURN CASE WHEN @obtained >= @min_deg THEN 'PASSED' ELSE 'FAILED' END
END
GO
/****** Object:  Table [dbo].[students]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[students](
	[st_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[st_name] [varchar](100) NULL,
	[st_email] [varchar](100) NULL,
	[st_phone] [varchar](20) NULL,
	[st_address] [varchar](200) NULL,
	[st_dob] [date] NULL,
	[in_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[st_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
) ON [Fg_usrs]
GO
/****** Object:  Table [dbo].[courses]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[courses](
	[crs_id] [int] IDENTITY(1,1) NOT NULL,
	[crs_name] [varchar](100) NULL,
	[description] [varchar](500) NULL,
	[max_degree] [int] NULL,
	[min_degree] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[crs_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[exams]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[exams](
	[ex_id] [int] IDENTITY(1,1) NOT NULL,
	[ex_type] [varchar](20) NULL,
	[crs_id] [int] NULL,
	[ins_id] [int] NULL,
	[in_id] [int] NULL,
	[ex_date] [date] NULL,
	[start_time] [time](7) NULL,
	[end_time] [time](7) NULL,
	[total_time] [int] NULL,
	[total_degree] [int] NULL,
	[year] [int] NULL,
	[allowance_options] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[ex_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [FG_Exams]
) ON [FG_Exams]
GO
/****** Object:  Table [dbo].[student_exam]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[student_exam](
	[st_id] [int] NOT NULL,
	[ex_id] [int] NOT NULL,
	[actual_start_time] [datetime] NULL,
	[actual_end_time] [datetime] NULL,
	[total_score] [decimal](5, 2) NULL,
	[obtained_degree] [decimal](5, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[st_id] ASC,
	[ex_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [FG_Exams]
) ON [FG_Exams]
GO
/****** Object:  View [dbo].[vw_failed_students]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_failed_students]
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
GO
/****** Object:  View [dbo].[vw_course_success_rate]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_course_success_rate]
AS
SELECT
    c.crs_name,
    COUNT(CASE WHEN se.total_score >= c.min_degree THEN 1 END) * 100.0 
    / COUNT(*) AS success_rate
FROM student_exam se
JOIN exams e ON e.ex_id = se.ex_id
JOIN courses c ON c.crs_id = e.crs_id
GROUP BY c.crs_name;
GO
/****** Object:  Table [dbo].[instructors]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[instructors](
	[ins_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[ins_name] [varchar](100) NULL,
	[ins_email] [varchar](100) NULL,
	[ins_phone] [varchar](20) NULL,
	[hire_date] [date] NULL,
	[salary] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ins_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
) ON [Fg_usrs]
GO
/****** Object:  View [dbo].[vw_exam_overview]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_exam_overview]
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
GO
/****** Object:  Table [dbo].[questions]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[questions](
	[q_id] [int] IDENTITY(1,1) NOT NULL,
	[q_text] [varchar](max) NULL,
	[q_type] [varchar](20) NULL,
	[correct_answer] [varchar](max) NULL,
	[crs_id] [int] NULL,
	[created_by] [int] NULL,
	[created_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[q_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_questions_per_course]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_questions_per_course]
AS
SELECT 
    c.crs_name,
    q.q_text,
    q.q_type
FROM questions q
JOIN courses c ON c.crs_id = q.crs_id;
GO
/****** Object:  UserDefinedFunction [dbo].[fn_StudentExamHistory]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_StudentExamHistory]
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
        e.total_degree                                              AS full_mark,
        se.obtained_degree                                          AS student_mark,
        dbo.fn_GetLetterGrade(se.obtained_degree, e.total_degree)   AS grade,
        dbo.fn_PassOrFail(se.st_id, e.ex_id)                        AS result,
        se.actual_start_time,
        se.actual_end_time
    FROM student_exam se
    JOIN exams   e ON e.ex_id  = se.ex_id
    JOIN courses c ON c.crs_id = e.crs_id
    WHERE se.st_id = @st_id
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ExamScoreboard]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_ExamScoreboard]
(
    @ex_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        RANK() OVER (ORDER BY se.obtained_degree DESC)              AS rank_position,
        s.st_id,
        s.st_name,
        se.obtained_degree                                          AS student_mark,
        se.total_score                                              AS full_mark,
        CAST(se.obtained_degree * 100.0 / se.total_score
             AS DECIMAL(5,2))                                       AS percentage,
        dbo.fn_GetLetterGrade(se.obtained_degree, e.total_degree)   AS grade,
        dbo.fn_PassOrFail(s.st_id, @ex_id)                          AS result
    FROM student_exam se
    JOIN students s ON s.st_id = se.st_id
    JOIN exams    e ON e.ex_id = se.ex_id
    WHERE se.ex_id = @ex_id
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CourseQuestionBank]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_CourseQuestionBank]
(
    @crs_id INT,
    @q_type VARCHAR(20) = NULL   -- NULL = ?? ???????
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
        i.ins_name      AS created_by,
        q.created_date
    FROM questions q
    JOIN instructors i ON i.ins_id = q.created_by
    WHERE q.crs_id = @crs_id
      AND (@q_type IS NULL OR q.q_type = @q_type)
)
GO
/****** Object:  Table [dbo].[exam_questions]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[exam_questions](
	[ex_id] [int] NOT NULL,
	[q_id] [int] NOT NULL,
	[q_degree] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[ex_id] ASC,
	[q_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [FG_Exams]
) ON [FG_Exams]
GO
/****** Object:  Table [dbo].[student_answers]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[student_answers](
	[ans_id] [int] IDENTITY(1,1) NOT NULL,
	[st_id] [int] NULL,
	[ex_id] [int] NULL,
	[q_id] [int] NULL,
	[student_answer] [varchar](max) NULL,
	[is_correct] [bit] NULL,
	[obtained_marks] [decimal](5, 2) NULL,
	[ans_at] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[ans_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [FG_Exams]
) ON [FG_Exams] TEXTIMAGE_ON [FG_Exams]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_StudentAnswerSheet]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_StudentAnswerSheet]
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
        eq.q_degree         AS max_marks,
        sa.obtained_marks,
        sa.ans_at
    FROM student_answers sa
    JOIN questions      q  ON q.q_id  = sa.q_id
    JOIN exam_questions eq ON eq.ex_id = sa.ex_id AND eq.q_id = sa.q_id
    WHERE sa.st_id = @st_id AND sa.ex_id = @ex_id
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_StudentPerformanceSummary]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_StudentPerformanceSummary]
(
    @st_id INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        c.crs_name,
        COUNT(se.ex_id)                                             AS exams_taken,
        MAX(se.obtained_degree)                                     AS best_score,
        MIN(se.obtained_degree)                                     AS lowest_score,
        CAST(AVG(se.obtained_degree) AS DECIMAL(5,2))              AS avg_score,
        c.min_degree                                                AS passing_mark,
        COUNT(CASE WHEN se.obtained_degree >= c.min_degree THEN 1 END) AS passed_count,
        COUNT(CASE WHEN se.obtained_degree <  c.min_degree THEN 1 END) AS failed_count
    FROM student_exam se
    JOIN exams   e ON e.ex_id  = se.ex_id
    JOIN courses c ON c.crs_id = e.crs_id
    WHERE se.st_id = @st_id
    GROUP BY c.crs_name, c.min_degree
)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CorrectiveCandidates]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   FUNCTION [dbo].[fn_CorrectiveCandidates]
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
        se.obtained_degree  AS score,
        c.min_degree        AS passing_mark,
        e.ex_id             AS failed_exam_id
    FROM student_exam se
    JOIN students s ON s.st_id  = se.st_id
    JOIN exams    e ON e.ex_id  = se.ex_id
    JOIN courses  c ON c.crs_id = e.crs_id
    WHERE e.in_id    = @in_id
      AND e.ex_type  = 'exam'
      AND se.obtained_degree < c.min_degree
)
GO
/****** Object:  View [dbo].[vw_student_results]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_student_results]
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
GO
/****** Object:  View [dbo].[vw_student_answers_details]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_student_answers_details]
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
GO
/****** Object:  View [dbo].[vw_exam_questions_count]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_exam_questions_count]
AS
SELECT
    e.ex_id,
    COUNT(eq.q_id) AS total_questions
FROM exams e
JOIN exam_questions eq ON e.ex_id = eq.ex_id
GROUP BY e.ex_id;
GO
/****** Object:  View [dbo].[vw_question_scores]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_question_scores]
AS
SELECT
    s.st_name,
    q.q_text,
    sa.obtained_marks
FROM student_answers sa
JOIN students s ON s.st_id = sa.st_id
JOIN questions q ON q.q_id = sa.q_id;
GO
/****** Object:  Table [dbo].[instructor_course]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[instructor_course](
	[ins_id] [int] NOT NULL,
	[crs_id] [int] NOT NULL,
	[in_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ins_id] ASC,
	[crs_id] ASC,
	[in_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_instructor_courses]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_instructor_courses]
AS
SELECT
    i.ins_name,
    c.crs_name,
    ic.in_id
FROM instructor_course ic
JOIN instructors i ON i.ins_id = ic.ins_id
JOIN courses c ON c.crs_id = ic.crs_id;
GO
/****** Object:  Table [dbo].[intake]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[intake](
	[in_id] [int] IDENTITY(1,1) NOT NULL,
	[in_name] [varchar](50) NULL,
	[in_year] [int] NULL,
	[br_id] [int] NULL,
	[tr_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[in_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_students_per_intake]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_students_per_intake]
AS
SELECT
    i.in_name,
    COUNT(s.st_id) AS total_students
FROM intake i
LEFT JOIN students s ON s.in_id = i.in_id
GROUP BY i.in_name;
GO
/****** Object:  View [dbo].[vw_top_students]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_top_students]
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
GO
/****** Object:  Table [dbo].[branch_track]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[branch_track](
	[br_id] [int] NOT NULL,
	[tr_id] [int] NOT NULL,
	[start_date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[br_id] ASC,
	[tr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[branches]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[branches](
	[br_id] [int] IDENTITY(1,1) NOT NULL,
	[br_name] [varchar](100) NULL,
	[br_location] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[br_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[choices]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[choices](
	[ch_id] [int] IDENTITY(1,1) NOT NULL,
	[q_id] [int] NULL,
	[choice_text] [varchar](500) NULL,
	[Iscorrect] [char](1) NULL,
PRIMARY KEY CLUSTERED 
(
	[ch_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tracks]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tracks](
	[tr_id] [int] IDENTITY(1,1) NOT NULL,
	[tr_name] [varchar](100) NULL,
	[tr_description] [varchar](200) NULL,
PRIMARY KEY CLUSTERED 
(
	[tr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[training_managers]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[training_managers](
	[mgr_id] [int] IDENTITY(1,1) NOT NULL,
	[user_id] [int] NULL,
	[mgr_name] [varchar](100) NULL,
	[mgr_email] [varchar](100) NULL,
	[mgr_phone] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[mgr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
) ON [Fg_usrs]
GO
/****** Object:  Table [dbo].[users]    Script Date: 3/31/2026 9:21:10 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[user_name] [nvarchar](50) NOT NULL,
	[password] [nvarchar](max) NULL,
	[role] [varchar](50) NULL,
	[is_active] [bit] NULL,
	[created_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
) ON [Fg_usrs] TEXTIMAGE_ON [Fg_usrs]
GO
INSERT [dbo].[branch_track] ([br_id], [tr_id], [start_date]) VALUES (1, 1, CAST(N'2025-09-01' AS Date))
GO
INSERT [dbo].[branch_track] ([br_id], [tr_id], [start_date]) VALUES (2, 2, CAST(N'2025-09-01' AS Date))
GO
INSERT [dbo].[branch_track] ([br_id], [tr_id], [start_date]) VALUES (3, 3, CAST(N'2025-09-01' AS Date))
GO
INSERT [dbo].[branch_track] ([br_id], [tr_id], [start_date]) VALUES (4, 4, CAST(N'2025-09-01' AS Date))
GO
INSERT [dbo].[branch_track] ([br_id], [tr_id], [start_date]) VALUES (5, 5, CAST(N'2025-09-01' AS Date))
GO
INSERT [dbo].[branch_track] ([br_id], [tr_id], [start_date]) VALUES (6, 6, CAST(N'2025-09-01' AS Date))
GO
INSERT [dbo].[branch_track] ([br_id], [tr_id], [start_date]) VALUES (7, 7, CAST(N'2025-09-01' AS Date))
GO
INSERT [dbo].[branch_track] ([br_id], [tr_id], [start_date]) VALUES (8, 8, CAST(N'2025-09-01' AS Date))
GO
INSERT [dbo].[branch_track] ([br_id], [tr_id], [start_date]) VALUES (9, 9, CAST(N'2025-09-01' AS Date))
GO
INSERT [dbo].[branch_track] ([br_id], [tr_id], [start_date]) VALUES (10, 10, CAST(N'2025-09-01' AS Date))
GO
INSERT [dbo].[branch_track] ([br_id], [tr_id], [start_date]) VALUES (31, 21, CAST(N'2025-01-01' AS Date))
GO
SET IDENTITY_INSERT [dbo].[branches] ON 
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (1, N'Branch 1', N'Location 1, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (2, N'Branch 2', N'Location 2, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (3, N'Branch 3', N'Location 3, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (4, N'Branch 4', N'Location 4, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (5, N'Branch 5', N'Location 5, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (6, N'Branch 6', N'Location 6, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (7, N'Branch 7', N'Location 7, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (8, N'Branch 8', N'Location 8, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (9, N'Branch 9', N'Location 9, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (10, N'Branch 10', N'Location 10, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (11, N'Branch 1', N'Location 1, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (12, N'Branch 2', N'Location 2, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (13, N'Branch 3', N'Location 3, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (14, N'Branch 4', N'Location 4, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (15, N'Branch 5', N'Location 5, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (16, N'Branch 6', N'Location 6, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (17, N'Branch 7', N'Location 7, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (18, N'Branch 8', N'Location 8, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (19, N'Branch 9', N'Location 9, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (20, N'Branch 10', N'Location 10, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (21, N'Branch 1', N'Location 1, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (22, N'Branch 2', N'Location 2, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (23, N'Branch 3', N'Location 3, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (24, N'Branch 4', N'Location 4, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (25, N'Branch 5', N'Location 5, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (26, N'Branch 6', N'Location 6, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (27, N'Branch 7', N'Location 7, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (28, N'Branch 8', N'Location 8, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (29, N'Branch 9', N'Location 9, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (30, N'Branch 10', N'Location 10, Egypt')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (31, N'test branch updated', N'new city')
GO
INSERT [dbo].[branches] ([br_id], [br_name], [br_location]) VALUES (32, N'test branch', N'test city')
GO
SET IDENTITY_INSERT [dbo].[branches] OFF
GO
SET IDENTITY_INSERT [dbo].[choices] ON 
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (14, 4, N'Query Language', N'1')
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (15, 4, N'Design Tool', N'0')
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (17, 5, N'Unique Identifier', N'1')
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (18, 5, N'Duplicate Data', N'0')
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (19, 10, N'True', N'1')
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (20, 10, N'False', N'0')
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (49, 20, N'a blueprint for creating objects', N'1')
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (50, 20, N'a variable that stores data', N'0')
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (61, 22, N'a blueprint for creating objects', N'1')
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (62, 22, N'a variable that stores data', N'0')
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (65, 23, N'a blueprint for creating objects', N'1')
GO
INSERT [dbo].[choices] ([ch_id], [q_id], [choice_text], [Iscorrect]) VALUES (66, 23, N'a variable that stores data', N'0')
GO
SET IDENTITY_INSERT [dbo].[choices] OFF
GO
SET IDENTITY_INSERT [dbo].[courses] ON 
GO
INSERT [dbo].[courses] ([crs_id], [crs_name], [description], [max_degree], [min_degree]) VALUES (1, N'OOP', N'Description for course 1', 100, 50)
GO
INSERT [dbo].[courses] ([crs_id], [crs_name], [description], [max_degree], [min_degree]) VALUES (2, N'DB', N'Description for course 2', 100, 50)
GO
INSERT [dbo].[courses] ([crs_id], [crs_name], [description], [max_degree], [min_degree]) VALUES (3, N'DS', N'Description for course 3', 100, 50)
GO
INSERT [dbo].[courses] ([crs_id], [crs_name], [description], [max_degree], [min_degree]) VALUES (4, N'C#', N'Description for course 4', 100, 50)
GO
INSERT [dbo].[courses] ([crs_id], [crs_name], [description], [max_degree], [min_degree]) VALUES (5, N'LINQ', N'Description for course 5', 100, 50)
GO
INSERT [dbo].[courses] ([crs_id], [crs_name], [description], [max_degree], [min_degree]) VALUES (6, N'API', N'Description for course 6', 100, 50)
GO
INSERT [dbo].[courses] ([crs_id], [crs_name], [description], [max_degree], [min_degree]) VALUES (7, N'MVC', N'Description for course 7', 100, 50)
GO
INSERT [dbo].[courses] ([crs_id], [crs_name], [description], [max_degree], [min_degree]) VALUES (8, N'PYTHON', N'Description for course 8', 100, 50)
GO
INSERT [dbo].[courses] ([crs_id], [crs_name], [description], [max_degree], [min_degree]) VALUES (9, N'OS', N'Description for course 9', 100, 50)
GO
INSERT [dbo].[courses] ([crs_id], [crs_name], [description], [max_degree], [min_degree]) VALUES (10, N'NW', N'Description for course 10', 100, 50)
GO
INSERT [dbo].[courses] ([crs_id], [crs_name], [description], [max_degree], [min_degree]) VALUES (11, N'test course', N'a test course', 100, 50)
GO
SET IDENTITY_INSERT [dbo].[courses] OFF
GO
INSERT [dbo].[exam_questions] ([ex_id], [q_id], [q_degree]) VALUES (3, 4, 30)
GO
INSERT [dbo].[exam_questions] ([ex_id], [q_id], [q_degree]) VALUES (3, 5, 20)
GO
INSERT [dbo].[exam_questions] ([ex_id], [q_id], [q_degree]) VALUES (3, 7, 30)
GO
INSERT [dbo].[exam_questions] ([ex_id], [q_id], [q_degree]) VALUES (3, 9, 20)
GO
INSERT [dbo].[exam_questions] ([ex_id], [q_id], [q_degree]) VALUES (4, 20, 30)
GO
SET IDENTITY_INSERT [dbo].[exams] ON 
GO
INSERT [dbo].[exams] ([ex_id], [ex_type], [crs_id], [ins_id], [in_id], [ex_date], [start_time], [end_time], [total_time], [total_degree], [year], [allowance_options]) VALUES (3, N'exam', 1, 14, 1, CAST(N'2025-10-01' AS Date), CAST(N'10:00:00' AS Time), CAST(N'12:00:00' AS Time), 120, 100, 2025, NULL)
GO
INSERT [dbo].[exams] ([ex_id], [ex_type], [crs_id], [ins_id], [in_id], [ex_date], [start_time], [end_time], [total_time], [total_degree], [year], [allowance_options]) VALUES (4, N'exam', 11, 16, 11, CAST(N'2025-12-01' AS Date), CAST(N'09:00:00' AS Time), CAST(N'11:00:00' AS Time), 120, 100, 2025, NULL)
GO
SET IDENTITY_INSERT [dbo].[exams] OFF
GO
INSERT [dbo].[instructor_course] ([ins_id], [crs_id], [in_id]) VALUES (6, 1, 1)
GO
INSERT [dbo].[instructor_course] ([ins_id], [crs_id], [in_id]) VALUES (8, 4, 2)
GO
INSERT [dbo].[instructor_course] ([ins_id], [crs_id], [in_id]) VALUES (9, 5, 6)
GO
INSERT [dbo].[instructor_course] ([ins_id], [crs_id], [in_id]) VALUES (16, 1, 11)
GO
INSERT [dbo].[instructor_course] ([ins_id], [crs_id], [in_id]) VALUES (16, 11, 11)
GO
SET IDENTITY_INSERT [dbo].[instructors] ON 
GO
INSERT [dbo].[instructors] ([ins_id], [user_id], [ins_name], [ins_email], [ins_phone], [hire_date], [salary]) VALUES (6, 16, N'Ahmed Mohammed', N'ahmed.mohammed@iti.eg', N'01001110001', CAST(N'2022-01-15' AS Date), CAST(15000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[instructors] ([ins_id], [user_id], [ins_name], [ins_email], [ins_phone], [hire_date], [salary]) VALUES (7, 17, N'Ali Ahmed', N'ali.ahmed@iti.eg', N'01001110002', CAST(N'2022-01-15' AS Date), CAST(16000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[instructors] ([ins_id], [user_id], [ins_name], [ins_email], [ins_phone], [hire_date], [salary]) VALUES (8, 18, N'Omar Khaled', N'omar.khaled@iti.eg', N'01001110003', CAST(N'2022-01-15' AS Date), CAST(17000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[instructors] ([ins_id], [user_id], [ins_name], [ins_email], [ins_phone], [hire_date], [salary]) VALUES (9, 19, N'Nour Hassan', N'nour.hassan@iti.eg', N'01001110004', CAST(N'2022-01-15' AS Date), CAST(18000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[instructors] ([ins_id], [user_id], [ins_name], [ins_email], [ins_phone], [hire_date], [salary]) VALUES (10, 20, N'Mariam Ali', N'mariam.ali@iti.eg', N'01001110005', CAST(N'2022-01-15' AS Date), CAST(19000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[instructors] ([ins_id], [user_id], [ins_name], [ins_email], [ins_phone], [hire_date], [salary]) VALUES (11, 21, N'Alyaa Mahmoud', N'alyaa.mahmoud@iti.eg', N'01001110006', CAST(N'2022-01-15' AS Date), CAST(20000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[instructors] ([ins_id], [user_id], [ins_name], [ins_email], [ins_phone], [hire_date], [salary]) VALUES (12, 22, N'Nader Ibrahim', N'nader.ibrahim@iti.eg', N'01001110007', CAST(N'2022-01-15' AS Date), CAST(21000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[instructors] ([ins_id], [user_id], [ins_name], [ins_email], [ins_phone], [hire_date], [salary]) VALUES (13, 23, N'Mostafa Hassan', N'mostafa.hassan@iti.eg', N'01001110008', CAST(N'2022-01-15' AS Date), CAST(22000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[instructors] ([ins_id], [user_id], [ins_name], [ins_email], [ins_phone], [hire_date], [salary]) VALUES (14, 24, N'Abdelrahman Said', N'abdelrahman.said@iti.eg', N'01001110009', CAST(N'2022-01-15' AS Date), CAST(23000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[instructors] ([ins_id], [user_id], [ins_name], [ins_email], [ins_phone], [hire_date], [salary]) VALUES (15, 25, N'Youssef Ahmed', N'youssef.ahmed@iti.eg', N'01001110010', CAST(N'2022-01-15' AS Date), CAST(24000.00 AS Decimal(10, 2)))
GO
INSERT [dbo].[instructors] ([ins_id], [user_id], [ins_name], [ins_email], [ins_phone], [hire_date], [salary]) VALUES (16, 46, N'test instructor', N'testinstructor@test.com', N'01055555555', CAST(N'2022-01-01' AS Date), CAST(20000.00 AS Decimal(10, 2)))
GO
SET IDENTITY_INSERT [dbo].[instructors] OFF
GO
SET IDENTITY_INSERT [dbo].[intake] ON 
GO
INSERT [dbo].[intake] ([in_id], [in_name], [in_year], [br_id], [tr_id]) VALUES (1, N'Intake 41', 2025, 1, 1)
GO
INSERT [dbo].[intake] ([in_id], [in_name], [in_year], [br_id], [tr_id]) VALUES (2, N'Intake 42', 2025, 2, 2)
GO
INSERT [dbo].[intake] ([in_id], [in_name], [in_year], [br_id], [tr_id]) VALUES (3, N'Intake 43', 2025, 3, 3)
GO
INSERT [dbo].[intake] ([in_id], [in_name], [in_year], [br_id], [tr_id]) VALUES (4, N'Intake 44', 2025, 4, 4)
GO
INSERT [dbo].[intake] ([in_id], [in_name], [in_year], [br_id], [tr_id]) VALUES (5, N'Intake 45', 2025, 5, 5)
GO
INSERT [dbo].[intake] ([in_id], [in_name], [in_year], [br_id], [tr_id]) VALUES (6, N'Intake 46', 2025, 6, 6)
GO
INSERT [dbo].[intake] ([in_id], [in_name], [in_year], [br_id], [tr_id]) VALUES (7, N'Intake 47', 2025, 7, 7)
GO
INSERT [dbo].[intake] ([in_id], [in_name], [in_year], [br_id], [tr_id]) VALUES (8, N'Intake 48', 2025, 8, 8)
GO
INSERT [dbo].[intake] ([in_id], [in_name], [in_year], [br_id], [tr_id]) VALUES (9, N'Intake 49', 2025, 9, 9)
GO
INSERT [dbo].[intake] ([in_id], [in_name], [in_year], [br_id], [tr_id]) VALUES (10, N'Intake 50', 2025, 10, 10)
GO
INSERT [dbo].[intake] ([in_id], [in_name], [in_year], [br_id], [tr_id]) VALUES (11, N'test intake 99', 2025, 31, 21)
GO
SET IDENTITY_INSERT [dbo].[intake] OFF
GO
SET IDENTITY_INSERT [dbo].[questions] ON 
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (4, N'What is SQL?', N'mcq', N'Query Language', 1, 8, CAST(N'2026-03-30T17:05:15.207' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (5, N'What is primary key?', N'mcq', N'Unique Identifier', 1, 10, CAST(N'2026-03-30T17:05:15.217' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (7, N'Explain normalization', N'text', N'Normalization explanation', 1, 11, CAST(N'2026-03-30T17:05:15.220' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (8, N'What is SQL?', N'mcq', N'Query Language', 1, 13, CAST(N'2026-03-30T17:07:14.470' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (9, N'What is primary key?', N'mcq', N'Unique Identifier', 1, 10, CAST(N'2026-03-30T17:07:14.480' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (10, N'SQL is a programming language', N'truefalse', N'True', 1, 14, CAST(N'2026-03-30T17:07:14.483' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (11, N'Explain normalization', N'text', N'Normalization explanation', 1, 11, CAST(N'2026-03-30T17:07:14.483' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (12, N'what is 2+2?', N'mcq', N'4', 11, 16, CAST(N'2026-03-31T14:58:03.460' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (15, N'var is key word', N'truefalse', N'true', 11, 16, CAST(N'2026-03-31T15:00:46.540' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (16, N'What is Dependency Injection in .NET? Explain how it is implemented in ASP.NET Core and why it is considered a best practice.', N'text', N'Dependency Injection is a design pattern used to achieve Inversion of Control. In ASP.NET Core, it is built-in through the IServiceCollection and IServiceProvider. It allows loose coupling, better testability, and easier maintenance by injecting dependencies rather than creating them inside classes.', 11, 16, CAST(N'2026-03-31T15:03:36.203' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (20, N'what is object?', N'mcq', N'instance', 11, 16, CAST(N'2026-03-31T15:29:54.290' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (22, N'what is class?', N'mcq', N'blueprint', 11, 16, CAST(N'2026-03-31T20:33:50.897' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (23, N'what is class?', N'mcq', N'blueprint', NULL, 16, CAST(N'2026-03-31T20:42:33.620' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (24, N'var is key word', N'truefalse', N'true', NULL, 16, CAST(N'2026-03-31T20:42:34.037' AS DateTime))
GO
INSERT [dbo].[questions] ([q_id], [q_text], [q_type], [correct_answer], [crs_id], [created_by], [created_date]) VALUES (25, N'What is Dependency Injection in .NET? Explain how it is implemented in ASP.NET Core and why it is considered a best practice.', N'text', N'Dependency Injection is a design pattern used to achieve Inversion of Control. In ASP.NET Core, it is built-in through the IServiceCollection and IServiceProvider. It allows loose coupling, better testability, and easier maintenance by injecting dependencies rather than creating them inside classes.', NULL, 16, CAST(N'2026-03-31T20:42:34.207' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[questions] OFF
GO
SET IDENTITY_INSERT [dbo].[student_answers] ON 
GO
INSERT [dbo].[student_answers] ([ans_id], [st_id], [ex_id], [q_id], [student_answer], [is_correct], [obtained_marks], [ans_at]) VALUES (2, 10, 3, 4, N'Query Language', 1, CAST(30.00 AS Decimal(5, 2)), CAST(N'2026-03-30T17:49:44.637' AS DateTime))
GO
INSERT [dbo].[student_answers] ([ans_id], [st_id], [ex_id], [q_id], [student_answer], [is_correct], [obtained_marks], [ans_at]) VALUES (3, 10, 3, 5, N'Unique Identifier', 1, CAST(20.00 AS Decimal(5, 2)), CAST(N'2026-03-30T17:49:48.817' AS DateTime))
GO
INSERT [dbo].[student_answers] ([ans_id], [st_id], [ex_id], [q_id], [student_answer], [is_correct], [obtained_marks], [ans_at]) VALUES (4, 10, 3, 10, N'True', 1, CAST(30.00 AS Decimal(5, 2)), CAST(N'2026-03-30T17:49:51.790' AS DateTime))
GO
INSERT [dbo].[student_answers] ([ans_id], [st_id], [ex_id], [q_id], [student_answer], [is_correct], [obtained_marks], [ans_at]) VALUES (5, 9, 3, 4, N'Wrong Answer', 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-03-30T17:50:48.627' AS DateTime))
GO
INSERT [dbo].[student_answers] ([ans_id], [st_id], [ex_id], [q_id], [student_answer], [is_correct], [obtained_marks], [ans_at]) VALUES (6, 9, 3, 5, N'Unique Identifier', 1, CAST(20.00 AS Decimal(5, 2)), CAST(N'2026-03-30T17:50:52.533' AS DateTime))
GO
INSERT [dbo].[student_answers] ([ans_id], [st_id], [ex_id], [q_id], [student_answer], [is_correct], [obtained_marks], [ans_at]) VALUES (7, 9, 3, 10, N'False', 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-03-30T17:50:55.570' AS DateTime))
GO
INSERT [dbo].[student_answers] ([ans_id], [st_id], [ex_id], [q_id], [student_answer], [is_correct], [obtained_marks], [ans_at]) VALUES (11, 13, 4, 15, N'blueprint', 0, CAST(0.00 AS Decimal(5, 2)), CAST(N'2026-03-31T16:11:52.980' AS DateTime))
GO
INSERT [dbo].[student_answers] ([ans_id], [st_id], [ex_id], [q_id], [student_answer], [is_correct], [obtained_marks], [ans_at]) VALUES (14, 13, 4, 16, N'Dependency Injection is a design pattern used to achieve Inversion of Control. In ASP.NET Core, it is built-in through the IServiceCollection and IServiceProvider. It allows loose coupling, better testability, and easier maintenance by injecting dependencies rather than creating them inside classes.', 1, CAST(25.00 AS Decimal(5, 2)), CAST(N'2026-03-31T16:16:24.403' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[student_answers] OFF
GO
INSERT [dbo].[student_exam] ([st_id], [ex_id], [actual_start_time], [actual_end_time], [total_score], [obtained_degree]) VALUES (9, 3, CAST(N'2025-10-01T10:00:00.000' AS DateTime), CAST(N'2025-10-01T12:00:00.000' AS DateTime), CAST(20.00 AS Decimal(5, 2)), CAST(20.00 AS Decimal(5, 2)))
GO
INSERT [dbo].[student_exam] ([st_id], [ex_id], [actual_start_time], [actual_end_time], [total_score], [obtained_degree]) VALUES (10, 3, CAST(N'2025-10-01T10:00:00.000' AS DateTime), CAST(N'2025-10-01T12:00:00.000' AS DateTime), CAST(50.00 AS Decimal(5, 2)), CAST(50.00 AS Decimal(5, 2)))
GO
INSERT [dbo].[student_exam] ([st_id], [ex_id], [actual_start_time], [actual_end_time], [total_score], [obtained_degree]) VALUES (13, 4, CAST(N'2025-12-01T09:00:00.000' AS DateTime), CAST(N'2025-12-01T11:00:00.000' AS DateTime), CAST(25.00 AS Decimal(5, 2)), CAST(25.00 AS Decimal(5, 2)))
GO
SET IDENTITY_INSERT [dbo].[students] ON 
GO
INSERT [dbo].[students] ([st_id], [user_id], [st_name], [st_email], [st_phone], [st_address], [st_dob], [in_id]) VALUES (3, 26, N'Ali', N'sta@mail.com', N'0110000001', N'Cairo, Area 1', CAST(N'2003-01-01' AS Date), 1)
GO
INSERT [dbo].[students] ([st_id], [user_id], [st_name], [st_email], [st_phone], [st_address], [st_dob], [in_id]) VALUES (4, 27, N'Omar', N'stb@mail.com', N'0110000002', N'Cairo, Area 2', CAST(N'2003-02-01' AS Date), 2)
GO
INSERT [dbo].[students] ([st_id], [user_id], [st_name], [st_email], [st_phone], [st_address], [st_dob], [in_id]) VALUES (5, 28, N'Yamen', N'stc@mail.com', N'0110000003', N'Cairo, Area 3', CAST(N'2003-03-01' AS Date), 3)
GO
INSERT [dbo].[students] ([st_id], [user_id], [st_name], [st_email], [st_phone], [st_address], [st_dob], [in_id]) VALUES (6, 29, N'Kenan', N'std@mail.com', N'0110000004', N'Cairo, Area 4', CAST(N'2003-04-01' AS Date), 4)
GO
INSERT [dbo].[students] ([st_id], [user_id], [st_name], [st_email], [st_phone], [st_address], [st_dob], [in_id]) VALUES (7, 30, N'Malek', N'ste@mail.com', N'0110000005', N'Cairo, Area 5', CAST(N'2003-05-01' AS Date), 5)
GO
INSERT [dbo].[students] ([st_id], [user_id], [st_name], [st_email], [st_phone], [st_address], [st_dob], [in_id]) VALUES (8, 31, N'Yousseif', N'stf@mail.com', N'0110000006', N'Cairo, Area 6', CAST(N'2003-06-01' AS Date), 6)
GO
INSERT [dbo].[students] ([st_id], [user_id], [st_name], [st_email], [st_phone], [st_address], [st_dob], [in_id]) VALUES (9, 32, N'Nedal', N'stg@mail.com', N'0110000007', N'Cairo, Area 7', CAST(N'2003-07-01' AS Date), 7)
GO
INSERT [dbo].[students] ([st_id], [user_id], [st_name], [st_email], [st_phone], [st_address], [st_dob], [in_id]) VALUES (10, 33, N'Leen', N'sth@mail.com', N'0110000008', N'Cairo, Area 8', CAST(N'2003-08-01' AS Date), 8)
GO
INSERT [dbo].[students] ([st_id], [user_id], [st_name], [st_email], [st_phone], [st_address], [st_dob], [in_id]) VALUES (11, 34, N'Nour', N'sti@mail.com', N'0110000009', N'Cairo, Area 9', CAST(N'2003-09-01' AS Date), 9)
GO
INSERT [dbo].[students] ([st_id], [user_id], [st_name], [st_email], [st_phone], [st_address], [st_dob], [in_id]) VALUES (12, 35, N'Mariam', N'stj@mail.com', N'0110000010', N'Cairo, Area 10', CAST(N'2003-10-01' AS Date), 10)
GO
INSERT [dbo].[students] ([st_id], [user_id], [st_name], [st_email], [st_phone], [st_address], [st_dob], [in_id]) VALUES (13, 45, N'updated name', N'teststudent@test.com', N'01011111111', N'new address', CAST(N'2000-05-15' AS Date), 11)
GO
SET IDENTITY_INSERT [dbo].[students] OFF
GO
SET IDENTITY_INSERT [dbo].[tracks] ON 
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (1, N'.net', N'Description of track 1')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (2, N'node', N'Description of track 2')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (3, N'flutter', N'Description of track 3')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (4, N'mopile app', N'Description of track 4')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (5, N'ai', N'Description of track 5')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (6, N'ml', N'Description of track 6')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (7, N'data science', N'Description of track 7')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (8, N'nlp', N'Description of track 8')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (9, N'pi', N'Description of track 9')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (10, N'data engineer', N'Description of track 10')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (11, N'.net', N'Description of track 1')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (12, N'node', N'Description of track 2')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (13, N'flutter', N'Description of track 3')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (14, N'mopile app', N'Description of track 4')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (15, N'ai', N'Description of track 5')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (16, N'ml', N'Description of track 6')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (17, N'data science', N'Description of track 7')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (18, N'nlp', N'Description of track 8')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (19, N'pi', N'Description of track 9')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (20, N'data engineer', N'Description of track 10')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (21, N'test track', N'track for testing')
GO
INSERT [dbo].[tracks] ([tr_id], [tr_name], [tr_description]) VALUES (22, N'test track', N'track for testing')
GO
SET IDENTITY_INSERT [dbo].[tracks] OFF
GO
SET IDENTITY_INSERT [dbo].[training_managers] ON 
GO
INSERT [dbo].[training_managers] ([mgr_id], [user_id], [mgr_name], [mgr_email], [mgr_phone]) VALUES (1, 13, N' Fathi Mahmoud', N'fathi@iti.eg', N'01001112252')
GO
INSERT [dbo].[training_managers] ([mgr_id], [user_id], [mgr_name], [mgr_email], [mgr_phone]) VALUES (2, 36, N'Fatma Manager', N'fatma.mgr@iti.eg', N'01001112222')
GO
SET IDENTITY_INSERT [dbo].[training_managers] OFF
GO
SET IDENTITY_INSERT [dbo].[users] ON 
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (3, N'ins1', N'Ins@123', N'instructor', 1, CAST(N'2026-03-30T15:24:37.387' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (13, N'admin01', N'Admin@123', N'admin', 1, CAST(N'2026-03-30T16:01:22.663' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (16, N'ins_ahmed1', N'Ins@123', N'instructor', 1, CAST(N'2026-03-30T16:35:39.023' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (17, N'ins_ali2', N'Ins@123', N'instructor', 1, CAST(N'2026-03-30T16:35:39.023' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (18, N'ins_omar3', N'Ins@123', N'instructor', 1, CAST(N'2026-03-30T16:35:39.027' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (19, N'ins_nour4', N'Ins@123', N'instructor', 1, CAST(N'2026-03-30T16:35:39.027' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (20, N'ins_mariam5', N'Ins@123', N'instructor', 1, CAST(N'2026-03-30T16:35:39.030' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (21, N'ins_alyaa6', N'Ins@123', N'instructor', 1, CAST(N'2026-03-30T16:35:39.030' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (22, N'ins_nader7', N'Ins@123', N'instructor', 1, CAST(N'2026-03-30T16:35:39.030' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (23, N'ins_mostafa8', N'Ins@123', N'instructor', 1, CAST(N'2026-03-30T16:35:39.033' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (24, N'ins_abdel9', N'Ins@123', N'instructor', 1, CAST(N'2026-03-30T16:35:39.033' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (25, N'ins_youssef10', N'Ins@123', N'instructor', 1, CAST(N'2026-03-30T16:35:39.033' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (26, N'st1', N'St@123', N'student', 1, CAST(N'2026-03-30T16:38:18.363' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (27, N'st2', N'St@123', N'student', 1, CAST(N'2026-03-30T16:38:18.367' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (28, N'st3', N'St@123', N'student', 1, CAST(N'2026-03-30T16:38:18.367' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (29, N'st4', N'St@123', N'student', 1, CAST(N'2026-03-30T16:38:18.367' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (30, N'st5', N'St@123', N'student', 1, CAST(N'2026-03-30T16:38:18.370' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (31, N'st6', N'St@123', N'student', 1, CAST(N'2026-03-30T16:38:18.370' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (32, N'st7', N'St@123', N'student', 1, CAST(N'2026-03-30T16:38:18.370' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (33, N'st8', N'St@123', N'student', 1, CAST(N'2026-03-30T16:38:18.370' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (34, N'st9', N'St@123', N'student', 1, CAST(N'2026-03-30T16:38:18.370' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (35, N'st10', N'St@123', N'student', 1, CAST(N'2026-03-30T16:38:18.370' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (36, N'mgr01', N'Mgr@123', N'training_manager', 1, CAST(N'2026-03-30T16:47:50.533' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (45, N'tc_student_01', N'stpass@123', N'student', 1, CAST(N'2026-03-31T14:52:09.250' AS DateTime))
GO
INSERT [dbo].[users] ([user_id], [user_name], [password], [role], [is_active], [created_date]) VALUES (46, N'tc_ins_01', N'inspass@123', N'instructor', 1, CAST(N'2026-03-31T14:55:08.910' AS DateTime))
GO
SET IDENTITY_INSERT [dbo].[users] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__choices__22EB765DD2731055]    Script Date: 3/31/2026 9:21:11 PM ******/
ALTER TABLE [dbo].[choices] ADD UNIQUE NONCLUSTERED 
(
	[q_id] ASC,
	[Iscorrect] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_exam_questions_exam]    Script Date: 3/31/2026 9:21:11 PM ******/
CREATE NONCLUSTERED INDEX [IX_exam_questions_exam] ON [dbo].[exam_questions]
(
	[ex_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [FG_Exams]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__instruct__B4A804545D0488CE]    Script Date: 3/31/2026 9:21:11 PM ******/
ALTER TABLE [dbo].[instructors] ADD UNIQUE NONCLUSTERED 
(
	[ins_email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
/****** Object:  Index [UQ__instruct__B9BE370E09F81E33]    Script Date: 3/31/2026 9:21:11 PM ******/
ALTER TABLE [dbo].[instructors] ADD UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_questions_course_type]    Script Date: 3/31/2026 9:21:11 PM ******/
CREATE NONCLUSTERED INDEX [IX_questions_course_type] ON [dbo].[questions]
(
	[crs_id] ASC,
	[q_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [UQ__student___360EE635D91651CE]    Script Date: 3/31/2026 9:21:11 PM ******/
ALTER TABLE [dbo].[student_answers] ADD UNIQUE NONCLUSTERED 
(
	[st_id] ASC,
	[ex_id] ASC,
	[q_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [FG_Exams]
GO
/****** Object:  Index [IX_student_answers_exam_student]    Script Date: 3/31/2026 9:21:11 PM ******/
CREATE NONCLUSTERED INDEX [IX_student_answers_exam_student] ON [dbo].[student_answers]
(
	[ex_id] ASC,
	[st_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [FG_Exams]
GO
/****** Object:  Index [IX_student_exam_exam_student]    Script Date: 3/31/2026 9:21:11 PM ******/
CREATE NONCLUSTERED INDEX [IX_student_exam_exam_student] ON [dbo].[student_exam]
(
	[ex_id] ASC,
	[st_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [FG_Exams]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__students__219A408ECC7311AE]    Script Date: 3/31/2026 9:21:11 PM ******/
ALTER TABLE [dbo].[students] ADD UNIQUE NONCLUSTERED 
(
	[st_email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
/****** Object:  Index [UQ__students__B9BE370E5F3B95C1]    Script Date: 3/31/2026 9:21:11 PM ******/
ALTER TABLE [dbo].[students] ADD UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_students_email]    Script Date: 3/31/2026 9:21:11 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_students_email] ON [dbo].[students]
(
	[st_phone] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
/****** Object:  Index [UQ__training__B9BE370E7DEC32CC]    Script Date: 3/31/2026 9:21:11 PM ******/
ALTER TABLE [dbo].[training_managers] ADD UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__users__7C9273C4CF5BF48D]    Script Date: 3/31/2026 9:21:11 PM ******/
ALTER TABLE [dbo].[users] ADD UNIQUE NONCLUSTERED 
(
	[user_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
ALTER TABLE [dbo].[questions] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[student_answers] ADD  DEFAULT (getdate()) FOR [ans_at]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_date]
GO
ALTER TABLE [dbo].[branch_track]  WITH CHECK ADD FOREIGN KEY([br_id])
REFERENCES [dbo].[branches] ([br_id])
GO
ALTER TABLE [dbo].[branch_track]  WITH CHECK ADD FOREIGN KEY([tr_id])
REFERENCES [dbo].[tracks] ([tr_id])
GO
ALTER TABLE [dbo].[choices]  WITH CHECK ADD FOREIGN KEY([q_id])
REFERENCES [dbo].[questions] ([q_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[exam_questions]  WITH CHECK ADD FOREIGN KEY([ex_id])
REFERENCES [dbo].[exams] ([ex_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[exam_questions]  WITH CHECK ADD FOREIGN KEY([q_id])
REFERENCES [dbo].[questions] ([q_id])
GO
ALTER TABLE [dbo].[exams]  WITH CHECK ADD FOREIGN KEY([crs_id])
REFERENCES [dbo].[courses] ([crs_id])
GO
ALTER TABLE [dbo].[exams]  WITH CHECK ADD FOREIGN KEY([in_id])
REFERENCES [dbo].[intake] ([in_id])
GO
ALTER TABLE [dbo].[exams]  WITH CHECK ADD FOREIGN KEY([ins_id])
REFERENCES [dbo].[instructors] ([ins_id])
GO
ALTER TABLE [dbo].[instructor_course]  WITH CHECK ADD FOREIGN KEY([crs_id])
REFERENCES [dbo].[courses] ([crs_id])
GO
ALTER TABLE [dbo].[instructor_course]  WITH CHECK ADD FOREIGN KEY([in_id])
REFERENCES [dbo].[intake] ([in_id])
GO
ALTER TABLE [dbo].[instructor_course]  WITH CHECK ADD FOREIGN KEY([ins_id])
REFERENCES [dbo].[instructors] ([ins_id])
GO
ALTER TABLE [dbo].[instructors]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[intake]  WITH CHECK ADD FOREIGN KEY([br_id], [tr_id])
REFERENCES [dbo].[branch_track] ([br_id], [tr_id])
GO
ALTER TABLE [dbo].[questions]  WITH CHECK ADD FOREIGN KEY([created_by])
REFERENCES [dbo].[instructors] ([ins_id])
GO
ALTER TABLE [dbo].[questions]  WITH CHECK ADD FOREIGN KEY([crs_id])
REFERENCES [dbo].[courses] ([crs_id])
GO
ALTER TABLE [dbo].[student_answers]  WITH CHECK ADD FOREIGN KEY([q_id])
REFERENCES [dbo].[questions] ([q_id])
GO
ALTER TABLE [dbo].[student_answers]  WITH CHECK ADD FOREIGN KEY([st_id], [ex_id])
REFERENCES [dbo].[student_exam] ([st_id], [ex_id])
GO
ALTER TABLE [dbo].[student_exam]  WITH CHECK ADD FOREIGN KEY([ex_id])
REFERENCES [dbo].[exams] ([ex_id])
GO
ALTER TABLE [dbo].[student_exam]  WITH CHECK ADD FOREIGN KEY([st_id])
REFERENCES [dbo].[students] ([st_id])
GO
ALTER TABLE [dbo].[students]  WITH CHECK ADD FOREIGN KEY([in_id])
REFERENCES [dbo].[intake] ([in_id])
GO
ALTER TABLE [dbo].[students]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[training_managers]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[courses]  WITH CHECK ADD CHECK  (([min_degree]<[max_degree]))
GO
ALTER TABLE [dbo].[exams]  WITH CHECK ADD CHECK  (([end_time]>[start_time]))
GO
ALTER TABLE [dbo].[exams]  WITH CHECK ADD CHECK  (([ex_type]='corrective' OR [ex_type]='exam'))
GO
ALTER TABLE [dbo].[questions]  WITH CHECK ADD CHECK  (([q_type]='text' OR [q_type]='truefalse' OR [q_type]='mcq'))
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD CHECK  (([role]='instructor' OR [role]='training_manager' OR [role]='student' OR [role]='admin'))
GO
/****** Object:  StoredProcedure [dbo].[sp_add_branch]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_add_branch]
    @br_name     varchar(100),
    @br_location varchar(100)
as
begin
    set nocount on;
 
    insert into branches (br_name, br_location)
    values (@br_name, @br_location);
 
    select scope_identity() as new_branch_id;
end
GO
/****** Object:  StoredProcedure [dbo].[sp_add_choice]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 5.4 add choice to mcq / truefalse question
create   procedure [dbo].[sp_add_choice]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_add_course]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- module 5: course & question management
 
-- 5.1 add course
create   procedure [dbo].[sp_add_course]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_add_instructor]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_add_instructor]
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

GO
/****** Object:  StoredProcedure [dbo].[sp_add_intake]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 2.6 add intake
create   procedure [dbo].[sp_add_intake]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_add_question]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 5.2 add question
create   procedure [dbo].[sp_add_question]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_add_question_to_exam]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 6.2 add question to exam manually
create   procedure [dbo].[sp_add_question_to_exam]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_add_student]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_add_student]
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

GO
/****** Object:  StoredProcedure [dbo].[sp_add_track]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 2.3 add track
create   procedure [dbo].[sp_add_track]
    @tr_name        varchar(100),
    @tr_description varchar(200)
as
begin
    set nocount on;
 
    insert into tracks (tr_name, tr_description)
    values (@tr_name, @tr_description);
 
    select scope_identity() as new_track_id;
end
GO
/****** Object:  StoredProcedure [dbo].[sp_add_training_manager]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_add_training_manager]
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

GO
/****** Object:  StoredProcedure [dbo].[sp_add_userr]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_add_userr]
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
end

GO
/****** Object:  StoredProcedure [dbo].[sp_assign_instructor_course]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 4.2 assign instructor to course & intake
create   procedure [dbo].[sp_assign_instructor_course]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_assign_student_to_exam]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 6.4 assign student to exam
create   procedure [dbo].[sp_assign_student_to_exam]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_assign_track_to_branch]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 2.5 assign track to branch
create   procedure [dbo].[sp_assign_track_to_branch]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_calculate_student_result]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 7.2 calculate student final result
create   procedure [dbo].[sp_calculate_student_result]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_change_password]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_change_password]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_create_exam]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- module 6: exam management
 
-- 6.1 create exam
create   procedure [dbo].[sp_create_exam]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_edit_branch]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_edit_branch]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_edit_intake]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 2.7 edit intake
create   procedure [dbo].[sp_edit_intake]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_edit_question]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 5.3 edit question
create   procedure [dbo].[sp_edit_question]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_edit_student]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 3.2 edit student
create   procedure [dbo].[sp_edit_student]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_edit_track]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 2.4 edit track
create   procedure [dbo].[sp_edit_track]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_generate_random_exam]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 6.3 auto-generate random exam questions
create   procedure [dbo].[sp_generate_random_exam]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_get_exam_details]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 6.5 get exam details with questions
create   procedure [dbo].[sp_get_exam_details]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_get_exam_results]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 7.5 get full exam results (instructor view)
create   procedure [dbo].[sp_get_exam_results]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_get_exams_by_course]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 6.8 get all exams for a course
create   procedure [dbo].[sp_get_exams_by_course]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_get_instructor_courses]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 4.3 get instructor courses
create   procedure [dbo].[sp_get_instructor_courses]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_get_my_results]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 7.6 get student result summary (student view)
create   procedure [dbo].[sp_get_my_results]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_get_pending_text_answers]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 7.4 get text answers pending review (instructor)
create   procedure [dbo].[sp_get_pending_text_answers]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_get_student_answer_details]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 7.7 get student detailed answers
create   procedure [dbo].[sp_get_student_answer_details]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_get_student_exam]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 6.6 get exam for student (time-gated, no correct answers)
create   procedure [dbo].[sp_get_student_exam]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_get_student_profile]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 3.4 get student profile
create   procedure [dbo].[sp_get_student_profile]
    @st_id int
as
begin
    set nocount on;
 
    select s.*, i.in_name, i.in_year
    from   students s
    join   intake   i on s.in_id = i.in_id
    where  s.st_id = @st_id;
end
GO
/****** Object:  StoredProcedure [dbo].[sp_get_students_by_intake]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 3.5 get students by intake
create   procedure [dbo].[sp_get_students_by_intake]
    @in_id int
as
begin
    set nocount on;
 
    select s.st_id, s.st_name, s.st_email, s.st_phone, s.st_dob
    from   students s
    where  s.in_id = @in_id;
end
GO
/****** Object:  StoredProcedure [dbo].[sp_grade_text_answer]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 7.3 manually grade text answer (instructor)
create   procedure [dbo].[sp_grade_text_answer]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_login]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_login]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_search_exams]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 6.7 search exams
create   procedure [dbo].[sp_search_exams]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_search_questions]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 5.5 search question pool
create   procedure [dbo].[sp_search_questions]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_search_students]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- 3.3 search students
create   procedure [dbo].[sp_search_students]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_set_user_status]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create   procedure [dbo].[sp_set_user_status]
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
GO
/****** Object:  StoredProcedure [dbo].[sp_submit_answer]    Script Date: 3/31/2026 9:21:11 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- module 7: answer & grading
 
-- 7.1 submit student answer
create   procedure [dbo].[sp_submit_answer]
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
GO
USE [master]
GO
ALTER DATABASE [Examnation_System] SET  READ_WRITE 
GO
