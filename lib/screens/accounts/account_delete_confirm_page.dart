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
              onPressed: () => _handleDialogResponse(context, _showDeleteConfirmationDialog(context)),
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

  AlertDialog _createDeleteConfirmationDialog(BuildContext context) {
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
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                bool result = await _performAccountDeletion(context);
                _handleDeletionResult(context, result);
              },
            ),
  void _handleDialogResponse(BuildContext context, AlertDialog dialog) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  bool _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return _createDeleteConfirmationDialog(context);
      },
    ) ?? false;
  }
          ],
        );
      },
    );
  }

  Future<bool> _performAccountDeletion(BuildContext context) async {
    return await AuthService.deleteAccount();
  }

  void _handleDeletionResult(BuildContext context, bool result) {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    if (result) {
      navigator.pushReplacementNamed('/login');
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Failed to delete account')),
      );
    }
  }
}