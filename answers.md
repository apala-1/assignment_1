1. Identify and explain how each OOP principle is demonstrated in this code: 

# a. Where is encapsulation used and why?
-> Encapsulation is used in the BankAccount class where we 
   create private fields using _ so that other classes won't be able to modify it directly.

# b. How does inheritance help in this design?
-> Inheritance allows for reuse of common structure. 
   Here, SavingsAccount, CheckingAccount and PremiumAccount, all have fields like _accountNumber etc. They also share methods like displayInfo() and they override methods like withdraw() and deposit().

# c. Give examples of polymorphism in action.
-> The withdraw and deposit methods both are initialised
   in the parent class but they do different things in different accounts. In PremiumAccount, if balance is less than 10,000 we can't withdraw.. but in CheckingAccount, there's nto min balance requirement, but if the balance is less than 0, user pays overdraft fee of 35$.  

# d. What role does abstraction play?
-> Abstraction refers to hiding implementation. It hides
   unnecessary details and makes the code clean.

# 2. Extend the system by adding: 
# a. A StudentAccount class with no fees and a maximum balance of $5,000 
// Student Account
class StudentAccount extends BankAccount {
  static const double maxBalance = 5000;

  StudentAccount(int accNum, String name, double balance)
      : super(accNum, name, balance);

  @override
  void withdraw(double amount) {
    if (amount > balance) {
      print("Insufficient balance.");
      return;
    }
    balance = balance - amount;
    addTransaction("Withdrawn: \$${amount.toStringAsFixed(2)}");
  }

  @override
  void deposit(double amount) {
    if (balance + amount > maxBalance) {
      print("Cannot deposit: Maximum balance limit of \$5,000 reached.");
      return;
    }
    balance = balance + amount;
    addTransaction("Deposited: \$${amount.toStringAsFixed(2)}");
  }
}
# b. A method to calculate and apply monthly interest to all interest-bearing accounts 
@override
  double calculateInterest() => balance * interestRate;

  @override
  void applyInterest() {
    double interest = calculateInterest();
    balance = balance + interest;
    addTransaction("Interest applied: \$${interest.toStringAsFixed(2)}");
  }
# c. Transaction history tracking for each account
List<String> _transactionHistory = [];

  void addTransaction(String details) {
    _transactionHistory.add(details);
  }

# 3. Refactor suggestion: How would you improve the error handling and validation in this system?
-> I would raise Exceptions like InsufficientBalanceException so user can understand the problem better. 
-> Would also add try catch.