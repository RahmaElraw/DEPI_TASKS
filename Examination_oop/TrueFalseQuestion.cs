using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_Task
{
    internal class TrueFalseQuestion: Question
    {
        public bool CorrectAnswer {  get; set; }

        public override bool CheckAnswer(string answer)
        {
            return bool.TryParse(answer, out bool res) && res == CorrectAnswer;
        }
    }
}
