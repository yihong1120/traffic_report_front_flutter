import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // 假設您有一個處理身份驗證的服務

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({super.key});

  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final _formKey = GlobalKey<FormState>();
  String _oldPassword = '';
  String _newPassword = '';
  String _confirmNewPassword = '';
  bool _isLoading = false;

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      // 在执行异步操作前获取 Navigator 和 ScaffoldMessenger 状态
      final navigator = Navigator.of(context);
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      // 执行异步操作
      bool passwordChanged = await AuthService.changePassword(_oldPassword, _newPassword);

      // 根据操作结果使用先前获取的状态
      if (passwordChanged) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Password changed successfully')),
        );
        navigator.pop();
      } else {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Failed to change password')),
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
        title: const Text('Change Password'),
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
                        decoration: const InputDecoration(labelText: 'Old Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your old password';
                          }
                          return null;
                        },
                        onSaved: (value) => _oldPassword = value!,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'New Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a new password';
                          } else if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          _newPassword = value;
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Confirm New Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your new password';
                          } else if (value != _newPassword) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        onSaved: (value) => _confirmNewPassword = value!,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _changePassword,
                        child: const Text('Change Password'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}