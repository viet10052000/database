--- CAO HƯNG THỊNH - 20184200 ---

1. Xem thông tin cá nhân của học sinh
Select * from student 
2. Cập nhật thông tin cho giáo viên
UPDATE teacher SET phone = '0964589809' WHERE teacher_id ='GV003';
3. Xem thông tin về lớp học đang dạy
SELECT teacher.teacher_id, firstname, lastname, class_id, course_id, start_date, end_date
From teacher INNER JOIN class
ON teacher.teacher_id = class.teacher_id;
4. Xem lịch giảng dạy 
SELECT t.teacher_id, firstname, lastname, c.class_id, hours, weekday
From class c 
INNER JOIN teacher t ON t.teacher_id = c.teacher_id
INNER JOIN classtime ct ON c.class_id = ct.class_id
INNER JOIN Schedule s ON s.schedule_id = ct.schedule_id
where t.teacher_id = 'GV003';
5.Tạo trigger insert và update điểm
Create trigger Tgtac_diem AFTER INSERT,UPDATE  ON exam
Begin
declare @count decimal(4,2)
select @count= COUNT(*) from inserted where inserted.result > 10
select @count=COUNT(*) from inserted where inserted.result < 0
if (@count > 0)
begin
print N'Điểm nhập vào không thể nhỏ hơn 0 hoặc lớn hơn 10'
rollback tran
end 
end
6. Liệt kê các học viên ở trong lớp mình dạy
Select t.teacher_id, t.firstname, c.class_id,st.student_id, st.firstname, st.lastname,st.phone, Cg.Name
From teacher t
INNER JOIN class c ON t.teacher_id = c.teacher_id
INNER JOIN class_student cs ON cs.class_id = c.class_id
INNER JOIN student st ON st.student_id = cs.student_id
INNER JOIN course co ON co.course_id = c.course_id
INNER JOIN category cg ON cg.category_id = co.category_id
where t.teacher_id = 'GV001'
order by st.student_id ASC;
7. Thống kê và sắp xếp điểm của học viên mỗi bài kiểm tra của từng lớp theo thứ tự
Select c.class_id,st.student_id, st.firstname, st.lastname, e.exam_id, e.result, e.type
From class c 
INNER JOIN class_student cs ON cs.class_id = c.class_id
INNER JOIN student st ON st.student_id = cs.student_id
INNER JOIN exam e ON e.cs_id = cs.cs_id
where c.class_id = 'C120' and e.type = 'giữa khóa'
order by result desc;
8. Điểm trung bình giữa kì hoặc cuối kì của 1 lớp
Select c.class_id,e.type, AVG(er.result) as DiemTB
From teacher t
INNER JOIN class c ON t.teacher_id = c.teacher_id
INNER JOIN class_student cs ON cs.class_id = c.class_id
INNER JOIN student st ON st.student_id = cs.student_id
INNER JOIN ExamResult er ON er.student_id = st.student_id
INNER JOIN exam e ON e.exam_id = er.exam_id
group by c.class_id,e.type
order by e.type desc;
9. Đưa ra 3 học viên có điểm số tốt nhất ( hoặc không tốt nhất) trong các lớp
Select st.student_id, st.firstname, st.lastname, e.exam_id, e.result, e.type
From class_student cs
INNER JOIN student st ON st.student_id = cs.student_id
INNER JOIN exam e ON e.cs_id = cs.cs_id
where e.type='giữa khóa' and cs.class_id='C120' and e.result in (select e.result from exam e,class_student cs 
where cs.CS_id = e.CS_id and e.type = 'giữa khóa' and cs.class_id = 'C120'
order by e.result DESC limit 3)
order by cs.class_id,e.result ASC;
10. Liệt kê thông tin các lớp bắt đầu vào khoảng thời gian nào đó
SELECT class_id,teacher_id,course_id
    FROM class 
       WHERE start_date  
         BETWEEN '2020-02-04' 
            AND '2020-03-03';
11. Tạo trigger để inser dữ liệu vào
CREATE OR REPLACE FUNCTION student_insert_trigger_fnc()
  RETURNS trigger AS
$$
BEGIN
    INSERT INTO "student" ( "student_Id", "FirstName",CREATE OR REPLACE FUNCTION employee_insert_trigger_fnc()
  RETURNS trigger AS
$$
BEGIN
    INSERT INTO "student_id" ( "student_Id","FirstName", "LastName","phone" ,"street","dateofbirth","Mail")
         VALUES(NEW."student_Id",NEW."firstName",NEW."lastName",NEW"phone",NEW"Street",NEW"dateofbirth",NEW"Mail");
RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';
CREATE TRIGGER Student_insert_trigger
  AFTER INSERT
  ON "Student"
  FOR EACH ROW
  EXECUTE PROCEDURE student_insert_trigger_fnc();
13. Tạo procedure thêm dữ liệu vào các bảng
CREATE OR REPLACE FUNCTION add_category(Category_id CHAR(10), Name VARCHAR(30))
    RETURNS void AS $$
    BEGIN
      INSERT INTO Category VALUES (Category_id,name);
    END;
	 $$ LANGUAGE plpgsql;
12. Thêm cột cho bảng đã tồn tại
ALTER TABLE Exam
ADD COLUMN Resulttotal real NOT NULL;
14.Tạo trigger để mỗi khi nhập điểm sẽ tự tính điểm tổng kết 
create trigger diem_tongket 
before INSERT
on Exam 
for each row 
set exam.resulttotal = (30/100) * exam.result in (select exam.result from exam e where e.type = 'giữa khóa') + exam.result in (select exam.result from exam e where e.type = 'cuối khóa') * 70/100;
15. Khi học sinh đạt điểm cao trong lớp thì tiền học sẽ được discount
ALTER TABLE class_student 
ADD COLUMN discount INT;

CREATE OR REPLACE FUNCTION student_discount_on_exam_result()
  RETURNS trigger AS
$$
BEGIN

UPDATE class_student
SET discount = CASE WHEN NEW."RESULT" >= 8 AND NEW."RESULT" < 9 THEN 10
                    WHEN NEW."RESULT" > 9 THEN 20
                    ELSE 0
               END
WHERE "CS_id" = NEW."CS_id" ;

RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';
    
CREATE TRIGGER add_discount_after_update_good_result
 AFTER UPDATE
 ON "Exam"
 FOR EACH ROW
EXECUTE PROCEDURE student_discount_on_exam_result();