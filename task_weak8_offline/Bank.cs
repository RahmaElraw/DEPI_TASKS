using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace task_session8_offline
{
    internal class Bank
    {
        private const string BanKName = "Rahma_Bank";
        private string BranchCode { get; set; }
        public int customerId {  get; set; }
        private List<Customer> customers = new List<Customer>();
        //
        public static int _nextId = 1;

        public Bank( string BranchCode)
        {
            this.BranchCode = BranchCode;
        }

        public int GenerateUniqueId()
        {
            customerId = _nextId++;
            return customerId;
        }

        public Customer AddCustomer(string customerName, string nationalId, DateTime dateOfBirth)
        {
            var customer = new Customer
            {
                customerId = GenerateUniqueId(),
                customerName = customerName,
                nationalId = nationalId,
                dateOfBirth = dateOfBirth
            };
            customers.Add(customer);
            return customer;
        }
      
        public bool UpdateCustomer(int customerId, string newName, DateTime newDateOfBirth)
        {
            Customer c = null;
            bool found= false;
            if (c.customerId== customerId) 
                found= true;
            if(!found)
                return false;
            else
            {
                c.customerName = newName;
                c.dateOfBirth = newDateOfBirth;
                return true;
            }

        }
        public bool RemoveCustomer(int customerId)
        {
            Customer c = null;
            bool found = false;
            if (c.customerId == customerId)
                found = true;
            if (!found)
                return false;
            else
            {
                customers.Remove(c);
                return true;
            }
        }

        public bool SearchCustomers(string item) 
        {
            Customer c= null;
            bool found = false;
            if(c.customerName.ToLower()==item.ToLower()
                || c.nationalId==item)
            {
                found = true;
            }
            return found;
        }

        public static Account CreateAccount(Customer c, string type, decimal initialBalance = 0,
         decimal interestRate = 0, decimal overdraftLimit = 0)
        {

            if (type != "Savings" && type != "Current")
            {
                Console.WriteLine("The Type must be Savings or Current");
                return null;
            }
            
                Account acc = new Account();
                acc.AccNum = acc.generatenum();
                acc.Type = type;
                acc.Balance = initialBalance;
                acc.dateOpened = DateTime.Now;

                if (type == "Savings")
                {
                    acc.InterestRate = interestRate;
                    acc.OverdraftLimit = 0;
                }
                else 
                {
                    acc.InterestRate = 0;
                    acc.OverdraftLimit = overdraftLimit;
                }
                c.Accounts.Add(acc);
            
            if (initialBalance > 0)
            {
                Transaction trans = new Transaction();
                trans.Date = DateTime.Now;
                trans.Type = "Deposit";
                trans.Amount = initialBalance;
                trans.BalanceAfter = acc.Balance;
                trans.Description = "Initial deposit";
                acc.Transactions.Add(trans);
            }
            return acc;
        }

        public void Deposit(Account acc,decimal amount)
        {
            if (amount <= 0)
                Console.WriteLine("amount can not be 0 or -");
            else
                acc.Balance += amount;
        }


        public void Withdraw(Account acc,decimal amount)
        {
            if (amount <= 0)
                Console.WriteLine("amount can not be 0 or -");
            else
            {
                acc.Balance -= amount;
            }
        }

        public void Transfer(Account fromAcc, Account toAcc, decimal amount)
        {
            if (amount <= 0)
                Console.WriteLine("amount can not be 0 or -");
            else
            {
                fromAcc.Balance -= amount;
                toAcc.Balance += amount;
            }
        }

       
        public decimal GetCustomerTotalBalance (int id)
        {
            Customer c = null;
            decimal total = 0;
            for (int i = 0; i < customers.Count; i++)
            {
                if (customers[i].customerId == id)
                {
                    c = customers[i];
                    break;
                }
            }
            if (c == null)
                return 0;
            else
            {
                for (int i = 0; i < c.Accounts.Count; i++)
                {
                    total += c.Accounts[i].Balance;
                }
                return total;
            }
        }

        public decimal CalculateMonthlyInterest(Account acc)
        {
            if(acc.Type!="Saving")
                return 0;
            else
            {
                decimal interest= (acc.Balance * acc.InterestRate) / 12;
                return interest;
            }
        }

        public void GetBankReport()
        {
            Console.WriteLine($"Bank Report: Name: {BanKName} ,Branch: {BranchCode}");
            for (int i = 0; i < customers.Count; i++)
            {
                Customer c = customers[i];
                Console.WriteLine($"Customer Name: {c.customerName} ,CustomerID: {c.customerId}");
                for (int j = 0; j < c.Accounts.Count; j++)
                {
                    Account acc = c.Accounts[j];
                    Console.WriteLine($"Account Number: {acc.AccNum} ( Account Type: {acc.Type} ,Balance: {acc.Balance} ,Opened: {acc.dateOpened})");
                }
                decimal totalBalance = GetCustomerTotalBalance(c.customerId);
                Console.WriteLine($"Total Balance: {totalBalance}");
                    
            }
        }
    }
}
