using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_Task
{
    internal class MultipleChoiceQuestion : Question
    {
        public List<string> options { get; set; } =new List<string>();
        public string correctAnswer {  get; set; }

        public override bool CheckAnswer(string answer)
        {
            return correctAnswer.Trim().ToLower()==answer.Trim().ToLower();
        }
    } 
}
