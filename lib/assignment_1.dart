// Interest abstract class
abstract class InterestBearing {
  double calculateInterest();
  void applyInterest();
}

// Bank Account abstract class
abstract class BankAccount {
  int _accountNumber;
  String _accountHolderName;
  double _balance;
  List<String> _transactionHistory = [];

  // constructor
  BankAccount(this._accountNumber, this._accountHolderName, this._balance);

  // getters
  int get accountNumber => _accountNumber;
  String get accountHolderName => _accountHolderName;
  double get balance => _balance;
  List<String> get transactionHistory => _transactionHistory;

  // setters
  set accountHolderName(String name) {
    if (name.isNotEmpty) {
      _accountHolderName = name;
    } else {
      throw Exception("Name cannot be empty.");
    }
  }

  set balance(double amount) {
    _balance = amount;
  }

  // withdraw, deposit, displayInfo and addTransaction functions
  void withdraw(double amount);
  void deposit(double amount);

  void displayInfo() {
    print("\nAccount Number: $_accountNumber");
    print("Holder Name: $_accountHolderName");
    print("Balance: \$${_balance.toStringAsFixed(2)}");
    print("Transactions:");
    for (var tx in _transactionHistory) {
      print("  - $tx");
    }
  }

  void addTransaction(String details) {
    _transactionHistory.add(details);
  }
}

// Savings Account
class SavingsAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 500;
  static const double interestRate = 0.02;
  int _withdrawalCount = 0;

  // constructor
  SavingsAccount(int accNum, String name, double balance)
      : super(accNum, name, balance);

  // override functions from abstract class above
  @override
  void withdraw(double amount) {
    if (_withdrawalCount >= 3) {
      print("Withdrawal limit reached for this month!");
      return;
    }
    if (balance - amount < minBalance) {
      print("Cannot withdraw: Minimum balance of \$500 required.");
      return;
    }
    this.balance = this.balance - amount;
    _withdrawalCount++;
    addTransaction("Withdrawn: \$${amount.toStringAsFixed(2)}");
  }

  @override
  void deposit(double amount) {
    this.balance = this.balance + amount;
    addTransaction("Deposited: \$${amount.toStringAsFixed(2)}");
  }

  @override
  double calculateInterest() => balance * interestRate;

  @override
  void applyInterest() {
    double interest = calculateInterest();
    this.balance = this.balance + interest;
    addTransaction("Interest applied: \$${interest.toStringAsFixed(2)}");
  }
}

// Checking Account
class CheckingAccount extends BankAccount {
  static const double overdraftFee = 35.0;

  // constructor
  CheckingAccount(int accNum, String name, double balance)
      : super(accNum, name, balance);

  // overriding functions from class above
  @override
  void withdraw(double amount) {
    this.balance = this.balance - amount;
    if (this.balance < 0) {
      this.balance = this.balance - overdraftFee;
      addTransaction("Overdraft fee applied: \$35.00");
    }
    addTransaction("Withdrawn: \$${amount.toStringAsFixed(2)}");
  }

  @override
  void deposit(double amount) {
    this.balance = this.balance + amount;
    addTransaction("Deposited: \$${amount.toStringAsFixed(2)}");
  }
}

// Premium Account
class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000;
  static const double interestRate = 0.05;

  // constructor
  PremiumAccount(int accNum, String name, double balance)
      : super(accNum, name, balance);

  // overriding functions from abstract class above
  @override
  void withdraw(double amount) {
    if (balance - amount < minBalance) {
      print("Cannot withdraw: Minimum balance of \$10,000 required.");
      return;
    }
    this.balance = this.balance - amount;
    addTransaction("Withdrawn: \$${amount.toStringAsFixed(2)}");
  }

  @override
  void deposit(double amount) {
    this.balance = this.balance + amount;
    addTransaction("Deposited: \$${amount.toStringAsFixed(2)}");
  }

  @override
  double calculateInterest() => balance * interestRate;

  @override
  void applyInterest() {
    double interest = calculateInterest();
    balance = balance + interest;
    addTransaction("Interest applied: \$${interest.toStringAsFixed(2)}");
  }
}

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

// Bank Class
class Bank {
  List<BankAccount> _accounts = [];

  void createAccount(BankAccount account) {
    _accounts.add(account);
    print("Account created for ${account.accountHolderName}");
  }

  BankAccount? findAccount(int accNum) {
    try {
      return _accounts.firstWhere((acc) => acc.accountNumber == accNum);
    } catch (e) {
      print("Account not found: $e");
      return null;
    }
  }

  void transfer(int fromAcc, int toAcc, double amount) {
    var sender = findAccount(fromAcc);
    var receiver = findAccount(toAcc);

    if (sender == null || receiver == null) {
      print("Transfer failed: one or both accounts not found.");
      return;
    }

    sender.withdraw(amount);
    receiver.deposit(amount);
    sender.addTransaction("Transferred \$${amount.toStringAsFixed(2)} to ${receiver.accountHolderName}");
    receiver.addTransaction("Received \$${amount.toStringAsFixed(2)} from ${sender.accountHolderName}");
  }

  void applyMonthlyInterest() {
    for (var acc in _accounts) {
      if (acc is InterestBearing) {
        (acc as InterestBearing).applyInterest();
      }
    }
  }

  void showAllAccounts() {
    for (var acc in _accounts) {
      acc.displayInfo();
    }
  }
}

// MAIN FUNCTION
void main() {
  Bank bank = Bank();

  var acc1 = SavingsAccount(1001, "Alice", 1000);
  var acc2 = CheckingAccount(1002, "Bob", 200);
  var acc3 = PremiumAccount(1003, "Charlie", 15000);
  var acc4 = StudentAccount(1004, "David", 1000);

  bank.createAccount(acc1);
  bank.createAccount(acc2);
  bank.createAccount(acc3);
  bank.createAccount(acc4);

  acc1.deposit(500);
  acc1.withdraw(200);
  acc2.withdraw(300);
  acc3.deposit(500);
  acc4.deposit(4200);
  acc4.deposit(1000);

  bank.transfer(1001, 1002, 100);
  bank.applyMonthlyInterest();

  bank.showAllAccounts();
}
