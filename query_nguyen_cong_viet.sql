
--1 danh sach lop
select st.firstname,st.lastname,cs.class_id from student st,class_student cs
where st.student_id = cs.student_id and cs.class_id = 'C120'
order by st.lastname,st.firstname DESC;

--2 thêm học viên vào lớp
insert into class_student(class_id,student_id,CS_id)
values('C127','HV001','CS082');

--3 xóa học viên ra khỏi lớp
delete from class_student
where class_id = 'C127' and student_id = 'HV001';

--4 số lượng học viên của mỗi lớp
select cl.class_id,count(ct.student_id) as "SL học viên"
from class cl,class_student ct
where cl.class_id = ct.class_id
group by cl.class_id
order by cl.class_id ASC;

--5 lịch dạy của giáo viên trong tuần
select sc.weekday,te.firstname,te.lastname,sc.hours
from teacher te,class cl,classtime ct,schedule sc
where te.teacher_id = cl.teacher_id 
and cl.class_id = ct.class_id
and sc.schedule_id = ct.schedule_id
order by sc.weekday,sc.hours ASC;

--6 thông tin thời khóa biểu,tên khóa học,level của các lớp học
select cl.class_id,ca.name,le.*,sc.hours,sc.weekday
from class cl,course co,category ca,"Level" le,classtime ct,schedule sc
where cl.course_id = co.course_id 
and co.category_id = ca.category_id 
and co.level_id = le.level_id
and cl.class_id = ct.class_id
and ct.schedule_id = sc.schedule_id;

--7 thông tin thời khóa biểu của học viên
select st.firstname,st.lastname,sc.hours,sc.weekday
from student st,class_student cs,class cl,classtime ct,schedule sc
where st.student_id = cs.student_id
and cs.class_id = cl.class_id
and cl.class_id = ct.class_id
and ct.schedule_id = sc.schedule_id
and st.firstname = 'Nguyễn Công' and st.lastname = 'Việt';

--8 sắp xếp điểm từ cao xuống thấp của một lớp
select st.firstname,st.lastname,ex.result,cs.class_id,ex.type
from exam ex,student st,class_student cs
where st.student_id = cs.student_id 
and cs.CS_id = ex.CS_id and class_id = 'C120' and ex.type = 'giữa khóa'
order by ex.result DESC;

--9 những sinh viên có điểm cuối khóa 7 trở lên
select st.firstname,st.lastname,ex.result,cs.class_id,ex.type
from exam ex,student st,class_student cs
where st.student_id = cs.student_id 
and cs.CS_id = ex.CS_id and class_id = 'C120' and ex.type = 'cuối khóa'
and ex.result >= 7
order by ex.result DESC;

--10 xem điểm cuối khóa những sinh viên cao nhất của lớp
select st.firstname,st.lastname,ex.result,cs.class_id,ex.type
from exam ex,student st,class_student cs
where st.student_id = cs.student_id 
and cs.CS_id = ex.CS_id 
and ex.type = 'cuối khóa' 
and class_id = 'C120'
and ex.result in (select ex.result from exam ex,class_student cs 
where cs.CS_id = ex.CS_id and ex.type = 'cuối khóa' and cs.class_id = 'C120'
order by ex.result DESC limit 1)
order by cs.class_id,ex.result DESC;

--11 xem điểm cuối khóa của những sinh viên thứ hai của lớp 
select st.firstname,st.lastname,ex.result,cs.class_id,ex.type
from exam ex,student st,class_student cs
where st.student_id = cs.student_id 
and cs.CS_id = ex.CS_id 
and ex.type = 'cuối khóa' 
and cs.class_id = 'C120'
and ex.result = (select max(ex.result) from exam ex,class_student cs 
where cs.CS_id = ex.CS_id and ex.type = 'cuối khóa' and cs.class_id = 'C120'
and ex.result < (select max(ex.result) from exam ex,class_student cs 
where cs.CS_id = ex.CS_id and ex.type = 'cuối khóa' and cs.class_id = 'C120') )
order by cs.class_id,ex.result DESC;





