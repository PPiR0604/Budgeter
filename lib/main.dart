import 'package:budgeter/Home.dart';
import 'package:budgeter/entities.dart';
import 'package:budgeter/logic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var path = 'data.db';
  if (kIsWeb) {
    // Change default factory on the web
    databaseFactory = databaseFactoryFfiWeb;
    path = 'web_data.db';
  }

  final dbConnection = await openDatabase(
    join(await getDatabasesPath(), path),
    onCreate: (db, version) async => await createTables(db, version),
    onConfigure: (db) {
      db.execute('PRAGMA foreign_keys = ON');
    },
    version: 5,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => UserDatabase(dbConnection), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // colorScheme: ColorScheme.highContrastLight(),
        colorSchemeSeed: Colors.orangeAccent,
        useMaterial3: true,
      ),
      home: LoginPage(context),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage(BuildContext context, {super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController UserContr = TextEditingController();
  TextEditingController PassContr = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black12, borderRadius: BorderRadius.circular(25)),
        width: 340,
        height: 350,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: 20)),
            const Text(
              "Login",
              style: TextStyle(fontSize: 25),
            ),
            const Text(
              "Selamat Datang Kembali!",
              style: TextStyle(fontSize: 10),
            ),
            const Padding(padding: EdgeInsets.only(top: 12)),
            SizedBox(
              width: 280,
              height: 70,
              child: TextFormField(
                controller: UserContr,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please input some value";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: 'Masukkan Username Anda',
                    labelText: 'Username',
                    labelStyle: TextStyle(fontSize: 13)),
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const Padding(padding: EdgeInsets.all(2)),
            SizedBox(
              width: 280,
              height: 70,
              child: TextFormField(
                obscureText: true,
                controller: PassContr,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please input some value";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: 'Masukkan Password Anda',
                    labelText: 'Password',
                    labelStyle: TextStyle(fontSize: 13)),
                style: const TextStyle(fontSize: 13),
              ),
            ),
            const Padding(padding: EdgeInsets.all(10)),
            SizedBox(
                width: 280,
                height: 30,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;
                    _formKey.currentState!.save();
                    final database = context.read<UserDatabase>();
                    final userList =
                        await database.Login(UserContr.text, PassContr.text);
                    if (userList.isNotEmpty) {
                      final user =
                          userList.first; // Ambil user pertama dari hasil query
                      database.activeUser = user;
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(user: user),
                        ),
                      );
                    } else {
                      if (kDebugMode) {
                        print("Username atau password salah");
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Username atau password salah!')),
                      );
                    }
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.black54)),
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.white70),
                  ),
                )),
            const Padding(padding: EdgeInsets.all(5)),
            SizedBox(
                width: 280,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPage()));
                  },
                  style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.white70)),
                  child: const Text(
                    "Register",
                    style: TextStyle(color: Colors.black54),
                  ),
                ))
          ],
        ),
      ),
    )));
  }
}

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameControler = TextEditingController();
  TextEditingController emailControler = TextEditingController();
  TextEditingController passwordControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final value = context.watch<UserDatabase>();
    return Scaffold(
        body: Center(
      child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(25)),
            width: 340,
            height: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(top: 20)),
                const Text(
                  "Register",
                  style: TextStyle(fontSize: 25),
                ),
                const Text(
                  "Selamat Datang! Daftarkan diri Anda!",
                  style: TextStyle(fontSize: 13),
                ),
                const Padding(padding: EdgeInsets.only(top: 12)),
                SizedBox(
                  width: 280,
                  height: 70,
                  child: TextFormField(
                    controller: usernameControler,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please input some value";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Masukkan Username Anda',
                        labelText: 'Username',
                        labelStyle: TextStyle(fontSize: 13)),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                SizedBox(
                  width: 280,
                  height: 70,
                  child: TextFormField(
                    controller: emailControler,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please input some value";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'someone@example.com',
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 13)),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                SizedBox(
                  width: 280,
                  height: 70,
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordControler,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please input some value";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Masukkan Password Anda',
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 13)),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                SizedBox(
                  width: 280,
                  height: 70,
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "please input some value";
                      }

                      if (value != passwordControler.text) {
                        return "Password Salah";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Masukkan Password Anda sekali lagi',
                        labelText: 'Konfirmasi Password',
                        labelStyle: TextStyle(fontSize: 13)),
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                SizedBox(
                    width: 280,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        _formKey.currentState!.save();
                        final transaction = User(
                            username: usernameControler.text,
                            email: emailControler.text,
                            password: passwordControler.text);
                        value.CreateUser(transaction);
                        print(usernameControler.text);
                        Navigator.pop(context);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.black54)),
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )),
                const Padding(padding: EdgeInsets.all(5)),
                SizedBox(
                    width: 280,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: const ButtonStyle(
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.white70)),
                      child: const Text(
                        "Sudah Punya Akun?",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ))
              ],
            ),
          )),
    ));
  }
}
