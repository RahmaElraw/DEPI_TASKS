using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_Task
{
    internal class EssayQuestion : Question
    {
        public override bool CheckAnswer(string answer)
        {
            return false;
            // Essay-Text (no auto-check)
        }
    }
}
