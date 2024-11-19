/// Class yang merepresentasikan transaksi
class Transaction {
  Transaction({
    this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });

  final int? id;
  final String name;
  final int amount;
  final DateTime date;
  final TransactionType type;
  final String? category;
}

enum TransactionType { income, expense }

/// Class yang merepresentasikan pengeluaran berkala
class Bill {
  Bill({
    required this.id,
    required this.name,
    required this.amount,
    required this.interest,
    required this.dueDate,
    required this.interval,
  });
  
  final int id;
  final String name;
  final int amount;
  final double interest;
  final DateTime dueDate;
  final int interval;
}

/// Class yang merepresentasikan wishlist
class Wishlist {
  Wishlist({
    this.id,
    required this.name,
    required this.price,
    required this.estimatedDate,
  });

  final int? id;
  final String name;
  final int price;
  final DateTime estimatedDate;
}

/// Class yang merepresentasikan laporan keuangan bulanan
class Report {
  Report({
    required this.date,
    required this.balance,
    required this.totalIncome,
    required this.totalExpense,
    required this.transactions,
  });

  final DateTime date;
  final int balance;
  final int totalIncome;
  final int totalExpense;
  final List<Transaction> transactions;
}
