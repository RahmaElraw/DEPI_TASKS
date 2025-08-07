namespace task2_oop
{
    internal class Program
    {
        static void Main(string[] args)
        {
            BANK bank1= new BANK();
            bank1.ShowAccountDetails();
            Console.WriteLine("--------------------------------------");
            BANK bank2= new BANK("Rahma ElRaw","01234567892345","01026357106","Cairo",10000);
            bank2.ShowAccountDetails();
        }
    }
}
