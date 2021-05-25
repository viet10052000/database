--- NGUYỄN TRUNG ĐỨC - 20184073 ---

-1-- Liệt kê thông tin các khóa học
Select c.course_id, category.name as category, l.name as levels, c.term, c.description,c.numofsessions
From course as c, category, "Level" as l
WHERE c.level_id = l.level_id AND c.category_id = category.category_id;

-2-- Sửa thông tin học viên
Update student
Set phone = '1234567890'
where student_id = 'HV001';

-3-- Học viên có điểm cuối khóa cao hơn trung bình cả lớp
Select cs.class_id, st.FirstName, st.LastName,e.result   
From student as st, class_student as cs, exam as e
Where st.student_id = cs.student_id 
and cs.CS_id = e.CS_id 
and cs.class_id = 'C120'
and e.type = 'cuối khóa' 
and e.result >= (Select avg(result) From exam Where class_id = 'C120') ;

-4--Giáo viên dạy ít nhất 1 khóa ielts, 1 khóa toeic 
Select tc.teacher_id, tc.FirstName, tc.LastName 
From teacher as tc, class as cl, course as c, category 
Where tc.teacher_id = cl.teacher_id and c.course_id = cl.course_id and c.category_id = category.category_id
and category.name = 'IELTS'
INTERSECT 
Select tc.teacher_id, tc.FirstName, tc.LastName 
From teacher as tc, class as cl, course as c, category 
Where tc.teacher_id = cl.teacher_id and c.course_id = cl.course_id and c.category_id = category.category_id
and category.name = 'TOEIC';

--5- Thông tin các lớp học học vào thứ 3 và thứ 5
select cl.*, sh.hours, sh.weekday from class as cl, classtime as ct, schedule as sh
Where cl.class_id = ct.class_id 
and sh.schedule_id = ct.schedule_id
and cl.class_id in
(select cl.class_id from class as cl, classtime as ct, schedule as sh
Where cl.class_id = ct.class_id 
and sh.schedule_id = ct.schedule_id
and sh.weekday = 'thứ 3'
INTERSECT
select cl.class_id from class as cl, classtime as ct, schedule as sh
Where cl.class_id = ct.class_id 
and sh.schedule_id = ct.schedule_id
and sh.weekday = 'thứ 6');

-6-- Thông tin giáo viên dạy nhiều lớp nhất
select * from teacher 
where teacher_id in 
( Select teacher_id from class group by teacher_id having count(teacher_id)=(Select count(teacher_id) from class
Group by (teacher_id)
Order by count(teacher_id) Desc
limit 1));

-7-- Tạo view đóng tiền của học viên
Create view hoadon as 
select st.student_id, st.firstname, st.lastname, cl.price, pm.date 
From class as cl, class_student as cs, payment as pm, student as st
Where cs.student_id = 'HV001' and cs.class_id = cl.class_id and cs.cs_id = pm.cs_id and pm.status = 'đã nộp';
select * from hoadon;

-8-- Hàm tính điểm tổng kết của 1 học viên trong 1 lớp( điểm tổng kết = điểm giữa khóa*0.3 + điểm cuối khóa*0.7)
Create Function diemtongket(_stID char,_clID char)
Returns real
AS 
$$
BEGIN
	return (select (
(select e.result*0.3 From class_student as cs, exam as e
Where cs.class_id = _clID and cs.student_id = _stID and cs.cs_id = e.cs_id and e.type = 'giữa khóa')+
(select e.result*0.7 From class_student as cs, exam as e
Where cs.class_id = _clID and cs.student_id = _stID and cs.cs_id = e.cs_id and e.type = 'cuối khóa')));
END
$$
Language plpgsql;

select diemtongket('HV001','C120');

-9-- Bảng điểm( gồm điểm giữa kì, cuối kì, tổng kết của 1 lớp)
Create Function giuaki(_stID char,_clID char)
Returns real
AS 
$$
BEGIN
	return  (select e.result From class_student as cs, exam as e
Where cs.class_id = _clID and cs.student_id = _stID and cs.cs_id = e.cs_id and e.type = 'giữa khóa');
END
$$
Language plpgsql;
Create Function cuoiki(_stID char,_clID char)
Returns real
AS 
$$
BEGIN
	return  (select e.result From class_student as cs, exam as e
Where cs.class_id = _clID and cs.student_id = _stID and cs.cs_id = e.cs_id and e.type = 'cuối khóa');
END
$$
Language plpgsql;

select st.student_id, st.firstname, st.lastname, giuaki(st.student_id,'C120'),cuoiki(st.student_id,'C120'),diemtongket(st.student_id,'C120')
From student as st, class_student as cs 
Where st.student_id = cs.student_id and cs.class_id = 'C120';

-10-- Thêm trường si số (num_of_st) vào bảng class, tạo trigger tăng si số khi thêm học viên mới vào lớp
ALTER table class add num_of_st integer;
Create Function numofst(_clID char)
Returns integer
AS 
$$
BEGIN
	return  (select count(*) from class_student as cs where cs.class_id = _clID );
END
$$
Language plpgsql;
update class 
set num_of_st = numofst(class_id);


CREATE OR REPLACE FUNCTION siso()
  RETURNS TRIGGER 
  AS
$$
BEGIN
	update class 
	set num_of_st = numofst(class_id);
	return new;
END;
$$
LANGUAGE PLPGSQL;
CREATE TRIGGER trigger_siso
  AFTER insert
  ON class_student
  FOR EACH ROW
  EXECUTE PROCEDURE siso();
INSERT into class_student values ('C120','HV078','CS082');

