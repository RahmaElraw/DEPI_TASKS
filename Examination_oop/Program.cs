namespace Examination_Task
{
    internal class Program
    {
        static void Main(string[] args)
        {
            var system = new ExaminationSystem();
            Console.WriteLine("Add Courses");
            system.addcourse("oop", "Object Oriented programming", 100);
            system.addcourse("front-end", "web front-end", 100);
            system.addcourse("back-end", "web back-end", 100);
            system.addcourse("full-stack", "web full-stack", 100);
            system.addcourse("data analysis", "dealing with data", 100);
            system.addcourse("Ui-Ux", "designing", 100);
            system.addcourse("graphic design", "graphix", 100);
            system.addcourse("syber security", "Studying Syber Security", 100);

            Console.WriteLine("Add Students");
            system.addstudent(1, "ali salem", "ali@gmail.com");
            system.addstudent(2, "rahma hany", "rahma@gmail.com");
            system.addstudent(3, "mona ahmed", "mona@gmail.com");
            system.addstudent(4, "omer mohamed", "omer@gmail.com");
            system.addstudent(5, "said ali", "said@gmail.com");
            system.addstudent(6, "abdo nabil", "abdo@gmail.com");
            system.addstudent(7, "mena ahmed", "mena@gmail.com");
            system.addstudent(8, "safa wael", "safa@gmail.com");
            system.addstudent(9, "toqa amir", "toqa@gmail.com");
            system.addstudent(10, "salma tark", "salma@gmail.com");
            system.addstudent(11, "mena ibrahim", "menna@gmail.com");
            system.addstudent(12, "ashraket hafez", "shosho@gmail.com");
            system.addstudent(13, "arwa osama", "arwa@gmail.com");
            system.addstudent(14, "yara said", "yara@gmail.com"); system.addstudent(204, "Ali Salem", "ali@gmail.com");
            system.addstudent(15, "yossef mohamed", "yossef@gmail.com");
            system.addstudent(16, "shrouk samer", "shrok@gmail.com");
            system.addstudent(17, "mostafa hamed", "mostafa@gmail.com");
            system.addstudent(18, "hossam taha", "hossam@gmail.com");
            system.addstudent(19, "roqia ahmed", "roqa@gmail.com");
            system.addstudent(20, "martina mina", "tena@gmail.com");
            system.addstudent(21, "noran fawzy", "nora@gmail.com");

            Console.WriteLine("Add Instructores");
            system.addinstructor(11, "ahmed ibrahim", "oop");
            system.addinstructor(22, "mona sami", "front-end");
            system.addinstructor(33, "mohamed kamel", "back-end");
            system.addinstructor(44, "kareem emad", "full-stack");
            system.addinstructor(55, "hager essam", "data analysis");
            system.addinstructor(66, "nada mostafa", "Ui-Ux");
            system.addinstructor(77, "awatef elsaid", "graphic design");
            system.addinstructor(88, "aml sltan", "syber security");

            Console.WriteLine("Assign instructor to courses");
            system.AssignInstructor(11, "oop");
            system.AssignInstructor(22, "front-end");
            system.AssignInstructor(33, "back-end");
            system.AssignInstructor(44, "full-stack");
            system.AssignInstructor(55, "data analysis");
            system.AssignInstructor(66, "Ui-Ux");
            system.AssignInstructor(77, "graphic design");
            system.AssignInstructor(88, "syber security");

            Console.WriteLine("Assign Students to courses");
            system.EnrollStudent(1, "oop");
            system.EnrollStudent(2, "oop");
            system.EnrollStudent(3, "front-end");
            system.EnrollStudent(4, "front-end");
            system.EnrollStudent(5, "front-end");
            system.EnrollStudent(6, "back-end");
            system.EnrollStudent(7, "back-end");
            system.EnrollStudent(8, "full-stack");
            system.EnrollStudent(9, "full-stack");
            system.EnrollStudent(10, "full-stack");
            system.EnrollStudent(11, "data analysis");
            system.EnrollStudent(12, "data analysis");
            system.EnrollStudent(13, "Ui-Ux");
            system.EnrollStudent(14, "Ui-Ux");
            system.EnrollStudent(15, "graphic design");
            system.EnrollStudent(16, "graphic design");
            system.EnrollStudent(17, "graphic design");
            system.EnrollStudent(18, "graphic design");
            system.EnrollStudent(19, "syber security");
            system.EnrollStudent(20, "syber security");
            system.EnrollStudent(21, "syber security");

            Console.WriteLine("Create Exams");
            system.CreateExam("OOP Midterm", "oop");
            system.CreateExam("Front-End Midterm", "front-end");
            system.CreateExam("Back-End Midterm", "back-end");
            system.CreateExam("Full-Stack Midterm", "full-stack");
            system.CreateExam("Data Analysis Midterm", "data analysis");
            system.CreateExam("UI-UX Midterm", "Ui-Ux");
            system.CreateExam("Graphic Design Midterm", "graphic design");
            system.CreateExam("Cyber Security Midterm", "cyber security");


            Console.WriteLine("Add Questions to OOP Midterm");
            var oopMcq = new MultipleChoiceQuestion
            {
                text = "What is the main feature of OOP?",
                options = new List<string> { "Encapsulation", "Compilation", "Execution", "Interpretation" },
                correctAnswer = "Encapsulation",
                mark = 30
            };
            system.AddQuestionToExam("OOP Midterm", oopMcq);

            var oopTfq = new TrueFalseQuestion
            {
                text = "Is inheritance a feature of OOP?",
                CorrectAnswer = true,
                mark = 20
            };
            system.AddQuestionToExam("OOP Midterm", oopTfq);

            var oopEssay = new EssayQuestion
            {
                text = "Explain polymorphism in OOP",
                mark = 50
            };
            system.AddQuestionToExam("OOP Midterm", oopEssay);
            // try to add new questions
            Console.WriteLine("Test Maximum Degree Limit");
            var extraQuestion_oop = new MultipleChoiceQuestion
            {
                text = "Extra question",
                options = new List<string> { "A", "B" },
                correctAnswer = "A",
                mark = 50
            };
            system.AddQuestionToExam("OOP Midterm", extraQuestion_oop);



            Console.WriteLine("Add Questions to Cyber Security Midterm");
            var cyberMcq = new MultipleChoiceQuestion
            {
                text = "What is a firewall used for?",
                options = new List<string> { "Data storage", "Network security", "Code debugging", "UI design" },
                correctAnswer = "Network security",
                mark = 50
            };
            system.AddQuestionToExam("Cyber Security Midterm", cyberMcq);
            Console.WriteLine("Test Maximum Degree Limit");
            var extraQuestionn_network = new MultipleChoiceQuestion
            {
                text = "Extra question",
                options = new List<string> { "A", "B" },
                correctAnswer = "A",
                mark = 50
            };
            system.AddQuestionToExam("OOP Midterm", extraQuestionn_network);

            Console.WriteLine("Students Take OOP Midterm");
            system.TakeExam(1, "OOP Midterm", new List<string> { "Encapsulation", "true", "Good explanation" });
            system.TakeExam(2, "OOP Midterm", new List<string> { "Compilation", "false", "Weak explanation" });


            Console.WriteLine("Students Take Cyber Security Midterm");
            system.TakeExam(19, "Cyber Security Midterm", new List<string> { "Network security" });
            system.TakeExam(20, "Cyber Security Midterm", new List<string> { "Data storage" });

            Console.WriteLine("Test Removing Question After Exam Start");
            system.RemoveQuestionFromExam("OOP Midterm", oopMcq);



            Console.WriteLine("Show Exam Reports");
            system.ShowReport(1, "OOP Midterm");
            system.ShowReport(2, "OOP Midterm");
            system.ShowReport(3, "Cyber Security Midterm");
            system.ShowReport(4, "Cyber Security Midterm");



            Console.WriteLine("Compare Students");
            system.CompareStudents(1, 2, "OOP Midterm");
            system.CompareStudents(19, 20, "Cyber Security Midterm");


            Console.WriteLine("\nTest Non-Existent Exam Report");
            system.ShowReport(1, "Non-Existent Exam");

        }
    }
}
