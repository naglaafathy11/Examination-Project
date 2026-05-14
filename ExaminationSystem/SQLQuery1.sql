USE [master]
GO
/****** Object:  Database [Examnation_System]    Script Date: 3/30/2026 1:18:42 PM ******/
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
/****** Object:  Table [dbo].[students]    Script Date: 3/30/2026 1:18:43 PM ******/
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
/****** Object:  Table [dbo].[courses]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[exams]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[student_exam]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  View [dbo].[vw_failed_students]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  View [dbo].[vw_course_success_rate]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[instructors]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  View [dbo].[vw_exam_overview]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[questions]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  View [dbo].[vw_questions_per_course]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  View [dbo].[vw_student_results]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[student_answers]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  View [dbo].[vw_student_answers_details]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[exam_questions]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  View [dbo].[vw_exam_questions_count]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  View [dbo].[vw_question_scores]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[instructor_course]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  View [dbo].[vw_instructor_courses]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[intake]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  View [dbo].[vw_students_per_intake]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  View [dbo].[vw_top_students]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[branch_track]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[branches]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[choices]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[tracks]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[training_managers]    Script Date: 3/30/2026 1:18:44 PM ******/
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
/****** Object:  Table [dbo].[users]    Script Date: 3/30/2026 1:18:44 PM ******/
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
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__choices__22EB765DD2731055]    Script Date: 3/30/2026 1:18:44 PM ******/
ALTER TABLE [dbo].[choices] ADD UNIQUE NONCLUSTERED 
(
	[q_id] ASC,
	[Iscorrect] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__instruct__B4A804545D0488CE]    Script Date: 3/30/2026 1:18:44 PM ******/
ALTER TABLE [dbo].[instructors] ADD UNIQUE NONCLUSTERED 
(
	[ins_email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
/****** Object:  Index [UQ__instruct__B9BE370E09F81E33]    Script Date: 3/30/2026 1:18:44 PM ******/
ALTER TABLE [dbo].[instructors] ADD UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
/****** Object:  Index [UQ__student___360EE635D91651CE]    Script Date: 3/30/2026 1:18:44 PM ******/
ALTER TABLE [dbo].[student_answers] ADD UNIQUE NONCLUSTERED 
(
	[st_id] ASC,
	[ex_id] ASC,
	[q_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [FG_Exams]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__students__219A408ECC7311AE]    Script Date: 3/30/2026 1:18:44 PM ******/
ALTER TABLE [dbo].[students] ADD UNIQUE NONCLUSTERED 
(
	[st_email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
/****** Object:  Index [UQ__students__B9BE370E5F3B95C1]    Script Date: 3/30/2026 1:18:44 PM ******/
ALTER TABLE [dbo].[students] ADD UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
/****** Object:  Index [UQ__training__B9BE370E7DEC32CC]    Script Date: 3/30/2026 1:18:44 PM ******/
ALTER TABLE [dbo].[training_managers] ADD UNIQUE NONCLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [Fg_usrs]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__users__7C9273C4CF5BF48D]    Script Date: 3/30/2026 1:18:44 PM ******/
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
USE [master]
GO
ALTER DATABASE [Examnation_System] SET  READ_WRITE 
GO
