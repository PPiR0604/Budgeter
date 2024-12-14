import 'dart:async';
import 'package:budgeter/entities.dart' as entity;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

Future<void> createTables(Database connection, int version) async {
  version = 5;
  final queries = [
    'CREATE TABLE user(Id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT, email TEXT, password TEXT)',
    'CREATE TABLE transactions(tsc_name TEXT, tsc_amount INTEGER, tsc_day INTEGER, tsc_month INTEGER, tsc_year INTEGER, tsc_hour INTEGER, tsc_minute INTEGER, tsc_category TEXT, user_Id, INTEGER, FOREIGN KEY (user_Id) REFERENCES user(Id))',
    'CREATE TABLE wishlists(wl_Id INTEGER PRIMARY KEY AUTOINCREMENT, wl_name TEXT, wl_price INTEGER, wl_estimated_purchase_date INTEGER, user_Id, INTEGER, FOREIGN KEY (User_id) REFERENCES user(Id))',
    'CREATE TABLE bills(bill_name TEXT, bill_amount INTEGER, bill_interest REAL, bill_interval INTEGER bill_due_date INTEGER, user_Id, INTEGER, FOREIGN KEY (User_id) REFERENCES user(Id))',
    'CREATE TABLE report(rpt_month INTEGER, rpt_year INTEGER, rpt_total_income INTEGER, rpt_total_expense INTEGER, rpt_balance INTEGER, user_Id, INTEGER, FOREIGN KEY (User_id) REFERENCES user(Id))',
  ];

  for (var query in queries) {
    await connection.execute(query);
  }
}

class UserDatabase extends ChangeNotifier {
  final Database connection;
  late entity.User activeUser;

  UserDatabase(this.connection);

  Future<List<entity.User>> Login(String username, String password) async {
    final query = connection.query(
      'user',
      columns: [
        'Id',
        'username',
        'email',
        'password',
      ],
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    var transactions = List<entity.User>.empty(growable: true);
    for (final {
          'Id': id as int,
          'username': name as String,
          'email': email as String,
          'password': password0 as String,
        } in await query) {
      final transaction = entity.User.withId(
          id: id, username: name, email: email, password: password0);

      transactions.add(transaction);
    }

    return transactions;
  }

  /// Ambil data transaksi untuk bulan dan tahun tertentu
  Future<List<entity.Transaction>> fetchTransactions(
      int month, int year, String? category) async {
    final Future<List<Map<String, Object?>>> query;
    if (category != "") {
      query = connection.query(
        'transactions',
        columns: [
          'rowid',
          'tsc_name',
          'tsc_day',
          'tsc_month',
          'tsc_year',
          'tsc_hour',
          'tsc_minute',
          'tsc_amount',
          'tsc_category',
        ],
        where:
            'tsc_month = ? AND tsc_year = ? AND user_Id = ? AND tsc_category = ?',
        whereArgs: [month, year, activeUser.id, category],
      );
    } else {
      query = connection.query(
        'transactions',
        columns: [
          'rowid',
          'tsc_name',
          'tsc_day',
          'tsc_month',
          'tsc_year',
          'tsc_hour',
          'tsc_minute',
          'tsc_amount',
          'tsc_category',
        ],
        where: 'tsc_month = ? AND tsc_year = ? AND user_Id = ?',
        whereArgs: [month, year, activeUser.id],
      );
    }

    var transactions = List<entity.Transaction>.empty(growable: true);

    for (final {
          'rowid': id as int,
          'tsc_name': name as String,
          'tsc_day': day as int,
          'tsc_month': month as int,
          'tsc_year': year as int,
          'tsc_hour': hour as int,
          'tsc_minute': minute as int,
          'tsc_amount': amount as int,
          'tsc_category': category as String?,
        } in await query) {
      final fullDate = DateTime(year, month, day, hour, minute);
      final type = amount < 0
          ? entity.TransactionType.expense
          : entity.TransactionType.income;

      final transaction = entity.Transaction(
          id: id,
          name: name,
          date: fullDate,
          amount: amount,
          category: category,
          type: type);

      transactions.add(transaction);
    }

    return transactions;
  }

  //Ambil semua bulan dan tahun
  Future<List<String>> getTime() async {
    var list = List<String>.empty(growable: true);

    final query = await connection
        .rawQuery("SELECT DISTINCT tsc_month, tsc_year FROM transactions");

    for (var row in query) {
      String formattedTime =
          '${row['tsc_month']} ${row['tsc_year'].toString()}';
      list.add(formattedTime);
    }

    return list;
  }

  //ambil balance, income, dan expense untuk seminggu ini
  Future<int> getsummary(int flag) async {
    int tes = 0;
    String logic = "";
    if (flag == 1) {
      logic = "AND tsc_amount>0";
    } else if (flag == 2) {
      logic = "AND tsc_amount<0";
    }
    DateTime now = DateTime.now();
    List<Map> temp = await connection.rawQuery(
        "SELECT SUM(tsc_amount) AS HASIL FROM transactions WHERE user_id = ${activeUser.id} $logic AND tsc_day>=${now.day - 7} AND tsc_month = ${now.month}");

    if (temp[0]["HASIL"] == null) {
    } else {
      tes = temp[0]["HASIL"];
    }

    return tes;
  }

  //ambil balance, income, dan expense untuk report sebulan
  Future<int> getSummaryReport(int flag, int month, int year) async {
    int tes = 0;
    String logic = "";
    if (flag == 1) {
      logic = "AND tsc_amount>0";
    } else if (flag == 2) {
      logic = "AND tsc_amount<0";
    }
    List<Map> temp = await connection.rawQuery(
        "SELECT SUM(tsc_amount) AS HASIL FROM transactions WHERE user_id = ${activeUser.id} $logic AND tsc_year = $year AND tsc_month = $month");

    if (temp[0]["HASIL"] == null) {
    } else {
      tes = temp[0]["HASIL"];
    }

    return tes;
  }

  Future<int> getSavings(int flag) async {
    int tes = 0;
    String logic = "";
    if (flag == 1) {
      logic = "AND tsc_amount>0";
    } else if (flag == 2) {
      logic = "AND tsc_amount<0";
    }
    List<Map> temp = await connection.rawQuery(
        "SELECT SUM(tsc_amount) AS HASIL FROM transactions WHERE user_id = ${activeUser.id} $logic ");

    if (temp[0]["HASIL"] == null) {
    } else {
      tes = temp[0]["HASIL"];
    }

    return tes;
  }

  Future<List<entity.Chart>> getCharts(int flag) async {
    String logic = "";
    if (flag == 1) {
      logic = "AND tsc_amount > 0";
    } else if (flag == 2) {
      logic = "AND tsc_amount < 0";
    }

    // Query SQL
    List<Map<String, dynamic>> temp = await connection.rawQuery(
      "SELECT tsc_month, tsc_year, SUM(tsc_amount) AS total_amount "
      "FROM transactions "
      "WHERE user_id = ? $logic "
      "GROUP BY tsc_month, tsc_year",
      [activeUser.id], // Parameter untuk user_id
    );

    // Map hasil query ke dalam List<entity.Chart>
    var charts = List<entity.Chart>.empty(growable: true);

    for (final row in temp) {
      final month = row['tsc_month'] as int;
      final year = row['tsc_year'] as int;
      final amount = row['total_amount'] as int;

      final transaction = entity.Chart(amount: amount, time: "$month-$year");
      charts.add(transaction);
    }

    return charts;
  }

  /// Ambil semua data transaksi dari database
  Future<List<entity.Transaction>> fetchAllTransactions() async {
    final query = connection.query(
      'transactions',
      columns: [
        'rowid',
        'tsc_name',
        'tsc_day',
        'tsc_month',
        'tsc_year',
        'tsc_hour',
        'tsc_minute',
        'tsc_amount',
        'tsc_category'
      ],
      where: 'user_Id = ?',
      whereArgs: [activeUser.id],
    );

    var transactions = List<entity.Transaction>.empty(growable: true);

    for (final {
          'rowid': id as int,
          'tsc_name': name as String,
          'tsc_day': day as int,
          'tsc_month': month as int,
          'tsc_year': year as int,
          'tsc_hour': hour as int,
          'tsc_minute': minute as int,
          'tsc_amount': amount as int,
          'tsc_category': category as String?,
        } in await query) {
      final fullDate = DateTime(year, month, day, hour, minute);
      final type = amount < 0
          ? entity.TransactionType.expense
          : entity.TransactionType.income;

      final transaction = entity.Transaction(
          id: id,
          name: name,
          date: fullDate,
          amount: amount,
          category: category,
          type: type);

      transactions.add(transaction);
    }

    return transactions;
  }

  /// Ambil wishlist dari database
  Future<List<entity.Wishlist>> fetchWishlist() async {
    final query = connection.query(
      'wishlists',
      columns: [
        'wl_Id',
        'wl_name',
        'wl_price',
        'wl_estimated_purchase_date',
      ],
      where: 'user_Id = ?',
      whereArgs: [activeUser.id],
    );

    var wishlists = List<entity.Wishlist>.empty(growable: true);
    for (final {
          'wl_Id': id as int,
          'wl_name': name as String,
          'wl_price': price as int,
          'wl_estimated_purchase_date': rawEstimatedPurchaseDate as int,
        } in await query) {
      final estimatedPurchaseDate =
          DateTime.fromMillisecondsSinceEpoch(rawEstimatedPurchaseDate);
      wishlists.add(entity.Wishlist(
        id: id,
        name: name,
        price: price,
        estimatedDate: estimatedPurchaseDate,
      ));
    }

    return wishlists;
  }

  /// Ambil bill dari database
  Future<List<entity.Bill>> fetchBill() async {
    final query = connection.query(
      'bills',
      columns: [
        'roid',
        'bill_name',
        'bill_amount',
        'bill_interest',
        'bill_due_date',
        'bill_interval',
      ],
      where: 'user_Id = ?',
      whereArgs: [activeUser.id],
    );

    var bills = List<entity.Bill>.empty(growable: true);
    for (final {
          'roid': id as int,
          'bill_name': name as String,
          'bill_amount': amount as int,
          'bill_interest': interest as double,
          'bill_due_date': dueDate as DateTime,
          'bill_interval': interval as int,
        } in await query) {
      bills.add(entity.Bill(
        id: id,
        name: name,
        amount: amount,
        interest: interest,
        dueDate: dueDate,
        interval: interval,
      ));
    }

    return bills;
  }

  /// Ambil laporan keuangan untuk bulan tertentu
  Future<entity.Report> fetchReport(int month, int year) async {
    final fullDate = DateTime.parse('$year${month}1');
    var totalIncome = 0;
    var totalExpense = 0;
    final transactions = await fetchTransactions(month, year, "");

    // jumlahkan pemasukan dan pengeluaran
    for (var transaction in transactions) {
      if (transaction.type == entity.TransactionType.income) {
        totalIncome += transaction.amount;
      } else {
        totalExpense += transaction.amount;
      }
    }

    final balance = totalIncome - totalExpense;

    return entity.Report(
        date: fullDate,
        balance: balance,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        transactions: transactions);
  }

  /// Ambil laporan keuangan untuk semua bulan
  Future<List<entity.Report>> fetchReports() async {
    var reports = List<entity.Report>.empty(growable: true);

    // cari bulan yang memiliki report
    final monthYearQueryResult = connection.query(
      'transactions',
      columns: ['tsc_month', 'tsc_year'],
      orderBy: 'tsc_date',
      where: 'user_Id = ?',
      whereArgs: [activeUser.id],
      distinct: true,
    );

    for (final {
          'tsc_month': month as int,
          'tsc_year': year as int,
        } in await monthYearQueryResult) {
      reports.add(await fetchReport(month, year));
    }

    return reports;
  }

  //menambahkan user ke database
  Future<void> CreateUser(entity.User user) async {
    final txnRecordMap = {
      'Id': user.id,
      'username': user.username,
      'email': user.email,
      'password': user.password,
    };
    await connection.transaction((txn) async {
      await txn.insert('user', txnRecordMap);
    });

    notifyListeners();
  }

  /// Tambahkan transaksi ke database
  Future<void> pushTransaction(entity.Transaction transaction) async {
    final txnRecordMap = {
      'tsc_name': transaction.name,
      'tsc_day': transaction.date.day,
      'tsc_month': transaction.date.month,
      'tsc_year': transaction.date.year,
      'tsc_hour': transaction.date.hour,
      'tsc_minute': transaction.date.minute,
      'tsc_amount': transaction.amount,
      'tsc_category': transaction.category,
      'user_Id': activeUser.id,
    };

    await connection.transaction((txn) async {
      await txn.insert('transactions', txnRecordMap);
    });

    notifyListeners();
  }

  /// Tambahkan wishlist ke database
  Future<void> pushWishlist(entity.Wishlist wishlist) async {
    final wlRecordMap = {
      'wl_Id': wishlist.id,
      'wl_name': wishlist.name,
      'wl_price': wishlist.price,
      'wl_estimated_purchase_date': wishlist.estimatedDate.month,
      'user_Id': activeUser.id,
    };
    await connection.transaction((txn) async {
      await txn.insert('wishlists', wlRecordMap);
    });

    notifyListeners();
  }

  /// Tambahkan bill ke database
  Future<void> pushBill(entity.Bill bill) async {
    final billRecordMap = {
      'bill_name': bill.name,
      'bill_amount': bill.name,
      'bill_interest': bill.interest,
      'bill_due_date': bill.dueDate,
      'bill_interval': bill.dueDate,
      'user_Id': activeUser.id,
    };

    await connection.transaction((txn) async {
      await txn.insert('bills', billRecordMap);
    });

    notifyListeners();
  }

  /// Hapus wishlist dari database
  Future<void> deleteWishlist(int wlId) async {
    await connection.transaction((txn) async {
      await txn.delete(
        'wishlists',
        where: 'wl_Id = ? AND user_Id = ?',
        whereArgs: [wlId, activeUser.id],
      );
    });

    notifyListeners();
  }

  /// Hapus bill dari database
  Future<void> deleteBill(int billId) async {
    await connection.transaction((txn) async {
      await txn.delete(
        'bills',
        where: 'rowid = ? AND user_Id',
        whereArgs: [billId, activeUser.id],
      );
    });

    notifyListeners();
  }
}
