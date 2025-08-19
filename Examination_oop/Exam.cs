using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Examination_Task
{
    internal class Exam
    {
        public string title {  get; set; }
        public Course course { get; set; }
        public List<Question> questions { get; set; }= new List<Question>();
        public bool IsStarted {  get; set; }
        public decimal TotalMarks => questions.Sum(q => q.mark);
        public bool CanAddQuestion(decimal mark)
        {
            return (!IsStarted && (TotalMarks + mark) <100);
        }
        public Exam Duplicate(Course newcourse)
        {
            var newExam = new Exam
            {
                title = $"Copy of {title}",
                course = newcourse,
                questions = new List<Question>(questions),
                IsStarted = false
            };
            return newExam;
        }

    }
}
