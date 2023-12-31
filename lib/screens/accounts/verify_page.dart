import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // 假設您有一個處理身份驗證的服務

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});

  @override
  _VerifyPageState createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _formKey = GlobalKey<FormState>();
  String _verificationCode = '';
  bool _isLoading = false;

  void _verify() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      // 在异步操作开始前获取 Navigator 和 ScaffoldMessenger 状态
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // 执行异步操作
      bool verified = await AuthService.verify(_verificationCode);

      // 使用先前获取的状态
      if (verified) {
        navigator.pushReplacementNamed('/home');
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Invalid verification code')),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Your Account'),
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
                        decoration: const InputDecoration(
                          labelText: 'Verification Code',
                          hintText: 'Enter your verification code',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your verification code';
                          }
                          return null;
                        },
                        onSaved: (value) => _verificationCode = value!,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _verify,
                        child: const Text('Verify'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}