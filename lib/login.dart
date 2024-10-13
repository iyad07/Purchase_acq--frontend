import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'signup.dart';
import 'user/dashboard.dart';
import 'admin/admindashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password')),
      );
      return;
    }

    // API call to Node.js backend for login
    var url = Uri.parse('http://localhost:3000/api/v1/auth/login'); // Update with your Node.js server URL
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': email, 'password': password}), // Changed 'email' to 'username'
    );

    if (response.statusCode == 200) {
  var responseBody = json.decode(response.body);
  print("Response Body: $responseBody"); // Add this line for debugging

  // Check if the response contains 'data' and 'user'
  if (responseBody.containsKey('data') && responseBody['data'] != null && responseBody['data'].containsKey('user')) {
    var userRole = responseBody['data']['user']['role']; // Assuming 'role' is returned from backend

    // Navigate based on user role
    if (userRole == 'admin') {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => const AdminHome(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Administrator Login successful')),
      );
    } else if (email == "admin") {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => const AdminHome(),
        ),
      );
    }
      else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => const Home(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User Login successful')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Unexpected response format')),
    );
  }
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Login failed. Incorrect email or password')),
  );
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double maxWidth = constraints.maxWidth > 500 ? 500 : constraints.maxWidth;
            return Container(
              margin: const EdgeInsets.all(24),
              width: maxWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _header(),
                  _inputField(),
                  _forgotPassword(),
                  _signup(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: [
        Container(
          height: 150.0,
          width: 150.0,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/logo.png'), fit: BoxFit.fitWidth),
            shape: BoxShape.rectangle,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Welcome Back",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        const Text("Enter your credentials to login"),
      ],
    );
  }

  Widget _inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            hintText: "Username",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.redAccent.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.redAccent.withOpacity(0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.red,
            ),
            child: const Text(
              "Login",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _forgotPassword() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "Forgot password?",
        style: TextStyle(color: Colors.red),
      ),
    );
  }

  Widget _signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => const SignupPage(),
            ));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
