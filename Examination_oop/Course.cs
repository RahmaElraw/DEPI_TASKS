using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_Task
{
    internal class Course
    {
        public string title {  get; set; }
        public string description { get; set; }
        public int max_degree {  get; set; }
        public List<Exam> Exams { get; set; } = new List<Exam>();

    }
}
