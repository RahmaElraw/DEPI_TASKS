using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace task_session8_offline
{
    internal class Customer
    {
        public int customerId;
        public string customerName;
        public string nationalId {  get; set; }
        public DateTime dateOfBirth;
        public List<Account> Accounts {  get; set; }=new List<Account>();

       
    }
}
