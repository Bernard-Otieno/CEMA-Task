import 'package:flutter/material.dart';
import 'package:task/medicine_list_page.dart';
import 'package:mysql1/mysql1.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utibu Health App',
      home: LoginPage(), // Start with the login page
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser(BuildContext context) async {
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: '',
        db: 'cema_task',
      ));

      final result = await conn.query(
        'SELECT * FROM users WHERE username = ? AND password = ?',
        [usernameController.text, passwordController.text],
      );

      await conn.close();

      if (result.isNotEmpty) {
        // Navigate to medicine list page if user is found
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MedicineListPage()),
        );
      } else {
        // Show error message if user is not found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')),
        );
      }
    } catch (e) {
      // Handle any database connection or query errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void signUpUser(BuildContext context) async {
    // Implement signup logic here
    // You'll need to insert a new user into the database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Signup functionality not implemented')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => loginUser(context),
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () => signUpUser(context),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
