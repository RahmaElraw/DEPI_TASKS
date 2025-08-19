using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_Task
{
    internal class Instructor
    {
        public int inst_id { get; set; }
        public string name { get; set; }
        public string specialization { get; set; }
        public List<Course> TeachingCourses = new List<Course>();
    }
}
