using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace task2_oop
{
    internal class BANK
    {

        //Fields
        private const string _BankCode = "BNK001";
        private readonly DateTime CreatedDate;
        private int _accountNumber;
        private string _fullName;
        private string _nationalID;
        private string _phoneNumber;
        private string _address;
        private decimal _balance;


        //Properties (with Validation)
        public string fullName
        {
            get { return _fullName; }
            set
            {
                if (string.IsNullOrWhiteSpace(value))
                    Console.WriteLine("Name can not be NULL or EMPTY");
                else
                    _fullName = value;
            }
        }
        public string nationalID
        {
            get { return _nationalID; }
            set
            {
                if (value.Length != 14 || long.TryParse(value, out _))
                    Console.WriteLine("ID Must be exactly 14 digits");
                else 
                    _nationalID = value;
            }
        }
        public string phoneNumber
        {
            get { return _phoneNumber; }
            set
            {
                if (value.Length != 11 || value.StartsWith("01") || long.TryParse(value, out _))
                    Console.WriteLine("Phone number must be 11 digits and start with '01'.");
                else
                    _phoneNumber = value;
            }
        }
        public decimal balance
        {
            get { return _balance; }
            set
            {
                if (value < 0)
                    Console.WriteLine("Balance cannot be negative.");
                else
                    _balance = value;
            }
        }
        public string address
        {
            get { return _address; }
            set { _address= value; }
        }

        //Constructors
        public BANK()
        {
            CreatedDate = DateTime.Now;
            _accountNumber = new Random().Next(1000, 9999); // 1000 to 9998
            _fullName = "Default Name";
            _nationalID = "00000000000000";
            _phoneNumber = "01000000000";
            _address = "Not Provided";
            _balance = 0;
        }

        public BANK(string fullName, string nationalID, string phoneNumber, string address, decimal balance)
        {
            CreatedDate = DateTime.Now;
            _accountNumber = new Random().Next(1000, 9999);
            _fullName = fullName;
            _nationalID = nationalID;
            _phoneNumber = phoneNumber;
            _address = address;
            _balance = balance;
        }

        public BANK(string fullName, string nationalID, string phoneNumber, string address)
            :this(fullName, nationalID, phoneNumber, address,0) { }


        //Methods
        public void ShowAccountDetails()
        {
            Console.WriteLine("Account Details :");
            Console.WriteLine($"Bank Code     : {_BankCode}");
            Console.WriteLine($"Account Number: {_accountNumber}");
            Console.WriteLine($"Name          : {_fullName}");
            Console.WriteLine($"National ID   : {_nationalID}");
            Console.WriteLine($"Phone         : {_phoneNumber}");
            Console.WriteLine($"Address       : {_address}");
            Console.WriteLine($"Balance       : {_balance}");
            Console.WriteLine($"Created Date  : {CreatedDate}");
        }

        public bool IsValidNationalID()
        {
            return _nationalID.Length == 14 && long.TryParse(_nationalID, out _);
        }

        public bool IsValidPhoneNumber()
        {
            return _phoneNumber.Length == 11 && _phoneNumber.StartsWith("01") && long.TryParse(_phoneNumber, out _);
        }
    }
}
