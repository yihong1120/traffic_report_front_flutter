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
    // 获取 Navigator 状态
    final navigator = Navigator.of(context);

    // 假设 AuthService 是您用来管理用户登录状态的服务
    _isLoggedIn = await AuthService.isLoggedIn();
    if (!_isLoggedIn) {
      // 如果用户未登录，使用先前获取的 Navigator 状态导航到登录页面
      navigator.pushReplacementNamed('/login');
    }
    // 通知 Flutter 需要重建 Widget
    if (mounted) {
      setState(() {});
    }
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