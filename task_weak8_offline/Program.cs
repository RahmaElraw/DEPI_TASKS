namespace task_session8_offline
{
    internal class Program
    {
        static void Main(string[] args)
        {
            Bank bank = new Bank( "BR001");
            // add customers
            Customer customer1 = bank.AddCustomer("John Doe", "NAT123", new DateTime(1990, 5, 15));
            Customer customer2 = bank.AddCustomer("Jane Smith", "NAT456", new DateTime(1985, 8, 20));

            // add acounts
            Account savings = Bank.CreateAccount(customer1, "Savings", 1000, 0.05m);
            Account current = Bank.CreateAccount(customer1, "Current", 500, 0, 1000);
            Account savings2 = Bank.CreateAccount(customer2, "Savings", 2000, 0.03m);

            
            bank.Deposit(savings, 500);
            bank.Withdraw(current, 200);
            bank.Transfer(savings, savings2, 300);

           bank.GetBankReport();

            Console.WriteLine("\nMonthly Interest for Savings: " + bank.CalculateMonthlyInterest(savings).ToString("C"));
             
        }
    }
}
