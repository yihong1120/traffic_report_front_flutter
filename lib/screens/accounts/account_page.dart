import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // 假设您有一个处理身份验证的服务

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  bool _isLoggedIn = false; // 这个应该根据实际的登录状态来设置
  // 可以添加更多的用户信息，例如用户名、电子邮件等

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

  void _logout() async {
    // 获取 Navigator 状态
    final navigator = Navigator.of(context);

    // 调用注销服务
    await AuthService.logout();
    // 导航回登录页面
    navigator.pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      // 如果用户未登录，显示加载指示器，直到我们检查完毕
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // 如果用户已登录，显示账户信息
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to your account page!'),
            const SizedBox(height: 20),
            // 显示更多的用户信息

            // 更改密码按钮
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/password-change');
              },
              child: const Text('Change Password'),
            ),

            // 账户删除确认按钮
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/account-delete-confirm');
              },
              child: const Text('Delete Account'),
            ),

            // 社交连接页面按钮
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/social-connections');
              },
              child: const Text('Social Connections'),
            ),

            // 注销按钮
            ElevatedButton(
              onPressed: _logout,
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
