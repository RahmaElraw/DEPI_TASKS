using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;

namespace task_session8_offline
{
    internal class Account
    {
        public int AccNum;
        public static int _nextnum = 1;
        public string Type { get; set; }
        public decimal Balance { get; set; }
        public DateTime dateOpened { get; set; }
        public decimal InterestRate { get; set; } // For Savings
        public decimal OverdraftLimit { get; set; } // For Current
        public List<Transaction> Transactions { get; set; } = new List<Transaction>();
        public int generatenum()
        {
            AccNum= _nextnum++;
            return AccNum;
        }

      
    }
}
