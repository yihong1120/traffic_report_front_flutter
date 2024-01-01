import 'package:flutter/material.dart';
// import 'package:../../services/auth_service.dart';

import '../../services/auth_service.dart'; // 假設您有一個處理身份驗證的服務

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 在执行异步操作前获取 Navigator 和 ScaffoldMessenger 状态
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // 执行异步操作
      bool loggedIn = await AuthService.login(_username, _password);

      // 根据操作结果使用先前获取的状态
      if (loggedIn) {
        navigator.pushReplacementNamed('/account');
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _register() {
    // 導航到註冊頁面
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                        onSaved: (value) => _username = value!,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value!,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _register,
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}