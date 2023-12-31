import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AccountDeleteConfirmPage extends StatelessWidget {
  const AccountDeleteConfirmPage({super.key});

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

  void _deleteAccount(BuildContext context) async {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    bool deleted = await AuthService.deleteAccount();
    if (deleted) {
      navigator.pushReplacementNamed('/login');
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Failed to delete account')),
      );
    }
  }
}