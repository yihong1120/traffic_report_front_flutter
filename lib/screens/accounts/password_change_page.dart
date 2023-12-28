import 'package:flutter/material.dart';
import 'package:your_project_name/services/auth_service.dart'; // 假設您有一個處理身份驗證的服務

class PasswordChangePage extends StatefulWidget {
  const PasswordChangePage({Key? key}) : super(key: key);

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

      // 假設 AuthService 有一個 changePassword 方法來處理密碼更改邏輯
      bool passwordChanged = await AuthService.changePassword(_oldPassword, _newPassword);
      if (passwordChanged) {
        // 如果密碼更改成功，顯示成功消息並導航回帳戶頁面
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully')),
        );
        Navigator.of(context).pop();
      } else {
        // 如果密碼更改失敗，顯示錯誤消息
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to change password')),
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
        title: Text('Change Password'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Old Password'),
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
                        decoration: InputDecoration(labelText: 'New Password'),
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
                        decoration: InputDecoration(labelText: 'Confirm New Password'),
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
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _changePassword,
                        child: Text('Change Password'),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}