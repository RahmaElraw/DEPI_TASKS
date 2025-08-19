using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_Task
{
    internal class Student
    {
        public int std_id { get; set; }
        public string name { get; set; }
        public string email { get; set; }
        public List<Course> EnrolledCourses { get; set; } = new List<Course>();
        public List<ExamResult> ExamResults { get; set; } = new List<ExamResult>();
    }
}
