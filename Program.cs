namespace task1_CS
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello!");
            Console.WriteLine("Input the first number:");
            string input1=Console.ReadLine();
            double num1;
            while(!double.TryParse(input1,out num1))
            {
                Console.WriteLine("Invalid input, try again");
                input1 = Console.ReadLine();
            }

            Console.WriteLine("Input the second number:");
            string input2 = Console.ReadLine();
            double num2;
            while (!double.TryParse(input2, out num2))
            {
                Console.WriteLine("Invalid input, try again");
                input2 = Console.ReadLine();
            }

            Console.WriteLine("What do you want to do with those numbers?");
            Console.WriteLine("[A]dd");
            Console.WriteLine("[S]ubtract");
            Console.WriteLine("[M]ultiply");

            string operation = Console.ReadLine().ToUpper();
            switch (operation)
            {
                case "A":
                    Console.WriteLine($"{num1} + {num2} = {num1+num2}");
                    break;

                case "S":
                    Console.WriteLine($"{num1} - {num2} = {num1 - num2}");
                    break;

                case "M":
                    Console.WriteLine($"{num1} * {num2} = {num1 * num2}");
                    break;
            }

            Console.WriteLine("Press any key to close");
            Console.ReadLine();
        }
    }
}
