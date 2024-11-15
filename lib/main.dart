import 'package:budgeter/Home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(136, 146, 146, 146),
          borderRadius: BorderRadius.circular(25)),
      width: 340,
      height: 320,
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
          const SizedBox(
            width: 280,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Masukkan Username Anda',
                  labelText: 'Username',
                  labelStyle: TextStyle(fontSize: 13)),
              style: TextStyle(fontSize: 10),
            ),
          ),
          const Padding(padding: EdgeInsets.all(2)),
          const SizedBox(
            width: 280,
            height: 40,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Masukkan Password Anda',
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 13)),
              style: TextStyle(fontSize: 10),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          SizedBox(
              width: 280,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
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
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
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
    )));
  }
}

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(136, 146, 146, 146),
          borderRadius: BorderRadius.circular(25)),
      width: 340,
      height: 400,
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
            style: TextStyle(fontSize: 10),
          ),
          const Padding(padding: EdgeInsets.only(top: 12)),
          const SizedBox(
            width: 280,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Masukkan Username Anda',
                  labelText: 'Username',
                  labelStyle: TextStyle(fontSize: 13)),
              style: TextStyle(fontSize: 10),
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 12)),
          const SizedBox(
            width: 280,
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'someone@example.com',
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 13)),
              style: TextStyle(fontSize: 10),
            ),
          ),
          const Padding(padding: EdgeInsets.all(2)),
          const SizedBox(
            width: 280,
            height: 40,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Masukkan Password Anda',
                  labelText: 'Password',
                  labelStyle: TextStyle(fontSize: 13)),
              style: TextStyle(fontSize: 10),
            ),
          ),
          const Padding(padding: EdgeInsets.all(2)),
          const SizedBox(
            width: 280,
            height: 40,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Masukkan Password Anda sekali lagi',
                  labelText: 'Konfirmasi Password',
                  labelStyle: TextStyle(fontSize: 13)),
              style: TextStyle(fontSize: 10),
            ),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          SizedBox(
              width: 280,
              height: 30,
              child: ElevatedButton(
                onPressed: () {},
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.black54)),
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
                    backgroundColor: WidgetStatePropertyAll(Colors.white70)),
                child: const Text(
                  "Sudah Punya Akun?",
                  style: TextStyle(color: Colors.black54),
                ),
              ))
        ],
      ),
    )));
  }
}
