using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_Task
{
    internal class ExamResult
    {
        public Exam Exam { get; set; }
        public decimal Score { get; set; }
        public bool Passed => Score >= 50;
    }
}
