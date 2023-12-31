import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // 假設您有一個處理身份驗證的服務

class AccountDeleteConfirmPage extends StatelessWidget {
  const AccountDeleteConfirmPage({super.key});

  void _deleteAccount(BuildContext context) async {
    // 假設 AuthService 有一個 deleteAccount 方法來處理帳戶刪除邏輯
    bool deleted = await AuthService.deleteAccount();
    if (deleted) {
      // 如果刪除成功，導航到登入頁面或其他頁面
      Navigator.of(context).pushReplacementNamed('/login');
    } else {
      // 如果刪除失敗，顯示錯誤消息
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Account Deletion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Are you sure you want to delete your account? This action cannot be undone.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showDeleteConfirmationDialog(context),
              child: const Text('Confirm Delete'),
            ),
            TextButton(
              onPressed: () {
                // Navigate back to the account page
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Account'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirm Delete'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteAccount(context);
              },
            ),
          ],
        );
      },
    );
  }
}