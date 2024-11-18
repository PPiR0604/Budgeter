import 'package:budgeter/entities.dart' as entity;
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

Future<void> createTables(Database connection, int version) async {
  version = 1;
  final queries = [
    'CREATE TABLE transactions(tsc_name TEXT, tsc_amount INTEGER, tsc_day INTEGER, tsc_month INTEGER, tsc_year INTEGER, tsc_hour INTEGER, tsc_minute INTEGER, tsc_category TEXT)',
    'CREATE TABLE wishlists(wl_name TEXT, wl_price INTEGER, wl_estimated_purchase_date INTEGER)',
    'CREATE TABLE bills(bill_name TEXT, bill_amount INTEGER, bill_interest REAL, bill_interval INTEGER bill_due_date INTEGER)',
    'CREATE TABLE report(rpt_month INTEGER, rpt_year INTEGER, rpt_total_income INTEGER, rpt_total_expense INTEGER, rpt_balance INTEGER)',
  ];

  for (var query in queries) {
    await connection.execute(query);
  }
}

class UserDatabase extends ChangeNotifier {
  final Database connection;
  
  UserDatabase(this.connection);

  /// Ambil data transaksi untuk bulan dan tahun tertentu
  Future<List<entity.Transaction>> fetchTransactions(
      int month, int year) async {
    final query = connection.query(
      'transactions',
      columns: [
        'tsc_name',
        'tsc_day',
        'tsc_month',
        'tsc_year',
        'tsc_hour',
        'tsc_minute',
        'tsc_amount',
        'tsc_category'
      ],
      where: 'tsc_month = ? AND tsc_year = ?',
      whereArgs: [month, year],
    );

    var transactions = List<entity.Transaction>.empty(growable: true);

    for (final {
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
          name: name,
          date: fullDate,
          amount: amount,
          category: category,
          type: type);

      transactions.add(transaction);
    }

    return transactions;
  }

  /// Ambil semua data transaksi dari database
  Future<List<entity.Transaction>> fetchAllTransactions() async {
    final query = connection.query(
      'transactions',
      columns: [
        'tsc_name',
        'tsc_day',
        'tsc_month',
        'tsc_year',
        'tsc_hour',
        'tsc_minute',
        'tsc_amount',
        'tsc_category'
      ],
    );

    var transactions = List<entity.Transaction>.empty(growable: true);

    for (final {
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
          name: name,
          date: fullDate,
          amount: amount,
          category: category,
          type: type);

      transactions.add(transaction);
    }

    return transactions;
  }

  /// Ambil laporan keuangan untuk bulan tertentu
  Future<entity.Report> fetchReport(int month, int year) async {
    final fullDate = DateTime.parse('$year${month}1');
    var totalIncome = 0;
    var totalExpense = 0;
    final transactions = await fetchTransactions(month, year);

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

  // Tambahkan transaksi ke database
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
    };

    await connection.transaction((txn) async {
      txn.insert('transactions', txnRecordMap);
    });

    notifyListeners();
  }
}
