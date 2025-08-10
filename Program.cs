namespace Inheritance__Polymorphism_task
{
    internal class Program
    {
        // base class
        public class BankAccount
        {
            public int AccountNumber { get; set; }
            public string AccountHolder { get; set; }
            public decimal Balance { get; set; }
            public BankAccount(int accountNum, string accountHolder, decimal balance)
            {
                this.AccountNumber = accountNum;
                this.AccountHolder = accountHolder;
                this.Balance = balance;
            }
            public virtual decimal CalculateInterest()
            {
                return 0;
            }
            public virtual void ShowAccountDetails()
            {
                Console.WriteLine($"AccountNumber: {AccountNumber}");
                Console.WriteLine($"AccountHolder: {AccountHolder}");
                Console.WriteLine($"Balance: {Balance}");
            }
        }
        // drived classes
        public class SavingAccount : BankAccount
        {
            public decimal InterestRate { get; set; }
            public SavingAccount(int accountNum, string accountHolder, decimal balance, decimal interestRate)
                : base(accountNum, accountHolder, balance)
            {
                InterestRate = interestRate;
            }
            public override decimal CalculateInterest()
            {
                return Balance * InterestRate / 100;
            }
            public override void ShowAccountDetails()
            {
                base.ShowAccountDetails();
                Console.WriteLine($"InterestRate: {InterestRate}");
            }
        }
        public class CurrentAccount : BankAccount
        {
            public decimal OverdraftLimit { get; set; }
            public CurrentAccount(int accountNum, string accountHolder, decimal balance, decimal overdraftLimit)
                : base(accountNum, accountHolder, balance)
            {
                OverdraftLimit = overdraftLimit;
            }
            public override decimal CalculateInterest()
            {
                return 0;
            }
            public override void ShowAccountDetails()
            {
                base.ShowAccountDetails();
                Console.WriteLine($"OverdraftLimit {OverdraftLimit}");
            }

        }
        static void Main(string[] args)
        {
            SavingAccount saving = new SavingAccount(123, "Ali", 50000, 5);
            CurrentAccount current = new CurrentAccount(456, "Rahma", 40000, 1000);
            List<BankAccount> accounts = new List<BankAccount> { saving, current };
            foreach (var acc in accounts)
            {
                acc.ShowAccountDetails();
                Console.WriteLine($"Calculated Interest: {acc.CalculateInterest()}");
                Console.WriteLine("-------------------------------");
            }


        }
    }
}