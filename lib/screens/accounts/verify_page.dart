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

      // 假設 AuthService 有一個 verify 方法來處理帳戶驗證邏輯
      bool verified = await AuthService.verify(_verificationCode);
      if (verified) {
        // 如果驗證成功，導航到首頁
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        // 如果驗證失敗，顯示錯誤消息
        ScaffoldMessenger.of(context).showSnackBar(
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