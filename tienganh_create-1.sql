-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2021-01-25 06:25:15.022

-- tables
-- Table: Category
CREATE TABLE Category (
    Category_id char(10)  NOT NULL,
    Name varchar(30)  NOT NULL,
    CONSTRAINT Category_pk PRIMARY KEY (Category_id)
);

-- Table: Class
CREATE TABLE Class (
    Class_id char(10)  NOT NULL,
    course_id char(10)  NOT NULL,
    Teacher_id char(10)  NOT NULL,
    Start_date date  NOT NULL,
    End_date date  NOT NULL,
    price char(20)  NOT NULL,
    CONSTRAINT Class_pk PRIMARY KEY (Class_id)
);

-- Table: ClassTime
CREATE TABLE ClassTime (
    Class_id char(10)  NOT NULL,
    Schedule_id char(10)  NOT NULL,
    CONSTRAINT ClassTime_pk PRIMARY KEY (Class_id,Schedule_id)
);

-- Table: Class_student
CREATE TABLE Class_student (
    Class_id char(10)  NOT NULL,
    Student_id char(10)  NOT NULL,
    CS_id char(10)  NOT NULL,
    CONSTRAINT PK_class_student PRIMARY KEY (CS_id)
);

-- Table: Course
CREATE TABLE Course (
    course_id char(10)  NOT NULL,
    Category_id char(10)  NOT NULL,
    level_id char(10)  NOT NULL,
    Term varchar(20)  NOT NULL,
    Description varchar(300)  NOT NULL,
    NumOfSessions int  NOT NULL,
    CONSTRAINT Course_pk PRIMARY KEY (course_id)
);

-- Table: ExamResult
CREATE TABLE Exam (
    exam_id serial  NOT NULL,
    Result real  NOT NULL,
    CS_id char(10)  NOT NULL,
    type varchar(20)  NOT NULL,
    CONSTRAINT PK_exam PRIMARY KEY (exam_id)
);

CREATE INDEX fkIdx_108 on Exam (Result ASC);

-- Table: Level
CREATE TABLE "Level" (
    level_id char(10)  NOT NULL,
    name varchar(30)  NOT NULL,
    CONSTRAINT Level_pk PRIMARY KEY (level_id)
);

-- Table: Payment
CREATE TABLE Payment (
    Date date  NOT NULL,
    Status varchar(20)  NOT NULL,
    CS_id char(10)  NOT NULL,
    CONSTRAINT Payment_pk PRIMARY KEY (CS_id)
);

CREATE INDEX fkIdx_111 on Payment (CS_id ASC);

-- Table: Schedule
CREATE TABLE Schedule (
    Schedule_id char(10)  NOT NULL,
    Hours varchar(20)  NOT NULL,
    WeekDay varchar(20)  NOT NULL,
    CONSTRAINT Schedule_pk PRIMARY KEY (Schedule_id)
);

-- Table: Student
CREATE TABLE Student (
    Student_id char(10)  NOT NULL,
    FirstName varchar(30)  NOT NULL,
    LastName varchar(30)  NOT NULL,
    Phone varchar(20)  NOT NULL,
    Street varchar(50)  NOT NULL,
    DateOfBirth date  NOT NULL,
    Mail varchar(50)  NOT NULL,
    CONSTRAINT Student_pk PRIMARY KEY (Student_id)
);

-- Table: Teacher
CREATE TABLE Teacher (
    Teacher_id char(10)  NOT NULL,
    FirstName varchar(30)  NOT NULL,
    LastName varchar(30)  NOT NULL,
    Phone varchar(20)  NOT NULL,
    Mail varchar(50)  NOT NULL,
    CONSTRAINT Teacher_pk PRIMARY KEY (Teacher_id)
);

-- foreign keys
-- Reference: FK_0 (table: Class)
ALTER TABLE Class ADD CONSTRAINT FK_0
    FOREIGN KEY (course_id)
    REFERENCES Course (course_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_1 (table: Class)
ALTER TABLE Class ADD CONSTRAINT FK_1
    FOREIGN KEY (Teacher_id)
    REFERENCES Teacher (Teacher_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_107 (table: ExamResult)
ALTER TABLE Exam ADD CONSTRAINT FK_107
    FOREIGN KEY (CS_id)
    REFERENCES Class_student (CS_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_11 (table: ClassTime)
ALTER TABLE ClassTime ADD CONSTRAINT FK_11
    FOREIGN KEY (Class_id)
    REFERENCES Class (Class_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_110 (table: Payment)
ALTER TABLE Payment ADD CONSTRAINT FK_110
    FOREIGN KEY (CS_id)
    REFERENCES Class_student (CS_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_12 (table: ClassTime)
ALTER TABLE ClassTime ADD CONSTRAINT FK_12
    FOREIGN KEY (Schedule_id)
    REFERENCES Schedule (Schedule_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_2 (table: Class_student)
ALTER TABLE Class_student ADD CONSTRAINT FK_2
    FOREIGN KEY (Class_id)
    REFERENCES Class (Class_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_3 (table: Class_student)
ALTER TABLE Class_student ADD CONSTRAINT FK_3
    FOREIGN KEY (Student_id)
    REFERENCES Student (Student_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_4 (table: Course)
ALTER TABLE Course ADD CONSTRAINT FK_4
    FOREIGN KEY (Category_id)
    REFERENCES Category (Category_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: FK_5 (table: Course)
ALTER TABLE Course ADD CONSTRAINT FK_5
    FOREIGN KEY (level_id)
    REFERENCES "Level" (level_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

