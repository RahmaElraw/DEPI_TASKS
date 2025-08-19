using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_Task
{
    internal abstract class Question
    {
        public string text { get; set; }
        public decimal mark { get; set; }
        public abstract bool CheckAnswer(string answer);

    }
}
