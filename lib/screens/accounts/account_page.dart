import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // 假設您有一個處理身份驗證的服務

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _isLoggedIn = false; // 這個應該根據實際的登入狀態來設定

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    // 假設 AuthService 是您用來管理用戶登入狀態的服務
    _isLoggedIn = await AuthService.isLoggedIn();
    if (!_isLoggedIn) {
      // 如果用戶未登入，導航到登入頁面
      Navigator.of(context).pushReplacementNamed('/login');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      // 如果用戶未登入，顯示加載指示器，直到我們檢查完畢
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 如果用戶已登入，顯示帳戶信息
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: const Center(
        child: Text('Welcome to your account page!'),
      ),
    );
  }
}