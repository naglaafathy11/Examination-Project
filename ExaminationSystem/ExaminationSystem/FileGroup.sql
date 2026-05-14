-- Create database with custom filegroups
Create Database Examnation_System
ON PRIMARY
(
    NAME = 'Examnation_System_main',
   
	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Examnation_System_main.mdf',
    SIZE = 100MB,
    MAXSIZE = UNLIMITED,
    FILEGROWTH = 50MB
),
FILEGROUP Fg_usrs
(
    NAME = 'Examnation_System_users',
   	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Examnation_System_users.ndf',

    SIZE = 50MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 50MB
),
FILEGROUP FG_Exams
(
    NAME = 'Examnation_System_exams',
   	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Examnation_System_exams.ndf',

    SIZE = 100MB,
    MAXSIZE = 1GB,
    FILEGROWTH = 50MB
)
LOG ON
(
    NAME = 'Examnation_System_logs',
   	filename = 'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\Examnation_System_logs.ldf',
    SIZE = 50MB,
    MAXSIZE = 500MB,
    FILEGROWTH = 25MB
);
GO



