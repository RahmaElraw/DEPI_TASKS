using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_Task
{
    internal class ExaminationSystem
    {
        private List<Course> courses {  get; set; }= new List<Course>();
        private List<Student>students { get; set; } = new List<Student>();
        private List<Instructor> instructors { get; set; }=new List<Instructor>();
        private List<Exam> exams = new List<Exam>();

        public void addcourse(string _title, string _description, int _maximumDegree)
        {
            var course = new Course()
            {
                title = _title,
                description = _description,
                max_degree = _maximumDegree
            };
            courses.Add(course);
        }
        public void addstudent(int id, string _name, string _email) 
        {
            var student = new Student()
            {
                std_id = id,
                name = _name,
                email = _email
            };
            students.Add(student);
        }
        public void addinstructor(int id, string _name, string _specialization)
        {
            var instructor = new Instructor()
            {
                inst_id = id,
                name = _name,
                specialization = _specialization
            };
            instructors.Add(instructor);
        }
        public void AssignInstructor(int instructorId, string courseTitle)
        {
            var instructor = instructors.Find(i => i.inst_id == instructorId);
            var course=courses.Find(c=>c.title == courseTitle);
            if (instructor != null && course != null)
            {
                instructor.TeachingCourses.Add(course);
            }
            else
            {
                Console.WriteLine("Instructor or Course is not exists");
            }
        }
        public void EnrollStudent(int studentId, string courseTitle)
        {
            var student= students.Find(s=>s.std_id == studentId);
            var course=courses.Find(c=>c.title == courseTitle);
            if(student != null && course != null)
            {
                student.EnrolledCourses.Add(course);
            }
            else
            {
                Console.WriteLine("student or Course is not exists");
            }
        }
        public void CreateExam(string _title, string courseTitle)
        {
            var course=courses.Find(c=>c.title == courseTitle);
            if(course!=null)
            {
                var exam = new Exam
                {
                    title = _title,
                    course = course
                };
                course.Exams.Add(exam);
                exams.Add(exam);
            }
            else
            {
                Console.WriteLine("Course is not exists");
            }
        }
        public void AddQuestionToExam(string examTitle, Question question)
        {
            var exam=exams.Find(e=>e.title == examTitle);
            if(exam!=null && exam.CanAddQuestion(question.mark))
            {
                exam.questions.Add(question);
            }
            else
            {
                Console.WriteLine("Can not add Questions");
            }
        }
        public void RemoveQuestionFromExam(string examTitle, Question question)
        {
            var exam = exams.Find(e => e.title == examTitle);
            if(exam!=null && !exam.IsStarted)
            {
                exam.questions.Remove(question);
            }
            else
            {
                Console.WriteLine("can not remove Questions");
            }
        }
        public void DuplicateExam(string examTitle, string newCourseTitle)
        {
            var exam = exams.Find(e => e.title == examTitle);
            var newCourse = courses.Find(c => c.title == newCourseTitle);
            if (exam != null && newCourse != null)
            {
                var newExam = exam.Duplicate(newCourse);
                exams.Add(newExam);
                newCourse.Exams.Add(newExam);
            }
            else
            {
                Console.WriteLine("Course or Exam is not exists");
            }
        }
        public void TakeExam(int studentId, string examTitle, List<string> answers)
        {
            var student = students.Find(s => s.std_id == studentId);
            var exam = exams.Find(e => e.title == examTitle);
            if (student != null && exam != null)
            {
                if (!exam.IsStarted)
                {
                    exam.IsStarted = true;
                }
                decimal score = 0;
                for (int i = 0; i < exam.questions.Count && i < answers.Count; i++)
                {
                    if (!(exam.questions[i] is EssayQuestion) && exam.questions[i].CheckAnswer(answers[i]))
                    {
                        score += exam.questions[i].mark;
                    }
                }
                var result = new ExamResult { Exam = exam, Score = score };
                student.ExamResults.Add(result);
                Console.WriteLine($"{student.name} takes {score}/{exam.TotalMarks} in {examTitle}");
            }
            else
            {
                Console.WriteLine("Student or exam is not exists");
            }

        }
        public void ShowReport(int studentId, string examTitle)
        {
            var student = students.Find(s => s.std_id == studentId);
            var exam=exams.Find(e=>e.title == examTitle);
            if(student != null && exam != null)
            {
                var result=student.ExamResults.Find(r=>r.Exam.title ==  examTitle);
                if(result!=null)
                {
                    Console.WriteLine($"Exam: {examTitle}");
                    Console.WriteLine($"Student: {student.name}");
                    Console.WriteLine($"Course: {exam.course.title}");
                    Console.WriteLine($"Grade: {result.Score}");
                    Console.WriteLine($"Status {(result.Passed? "successful":"failed")}");
                }
                else
                {
                    Console.WriteLine("there are no Results");
                }
            }
            else
            {
                Console.WriteLine("Student or Exam is not Exists");
            }
        }
        // Compare two students
        public void CompareStudents(int studentId1, int studentId2, string examTitle)
        {
            var std1=students.Find(s1=>s1.std_id == studentId1);
            var std2=students.Find(s2=>s2.std_id == studentId2);
            var exam=exams.Find(e=>e.title==examTitle);
            if(std1 != null && std2 != null && exam!=null)
            {
                var res1=std1.ExamResults.Find(r1=>r1.Exam.title==examTitle);
                var res2 = std2.ExamResults.Find(r2 => r2.Exam.title == examTitle);
                if(res1 != null && res2 != null)
                {
                    Console.WriteLine($"{std1.name}: {res1.Score}/{exam.TotalMarks}");
                    Console.WriteLine($"{std2.name}: {res2.Score}/{exam.TotalMarks}");
                    if (res1.Score > res2.Score)
                        Console.WriteLine($"{std1.name} has greater mark");
                    else if (res1.Score < res2.Score)
                        Console.WriteLine($"{std2.name} has greater mark");
                    else
                        Console.WriteLine("marks of two students are equal");
                }
                else
                {
                    Console.WriteLine("there are no marks to compare");
                }
            }
            else
            {
                Console.WriteLine("student or exam is not exists");
            }
        }
    }
}
