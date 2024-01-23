import 'package:flutter/material.dart';
import '../../services/auth_service.dart'; // 假设您有一个处理身份验证的服务

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  bool _isLoggedIn = false; // 这个应该根据实际的登录状态来设置
  String _username = ''; // 假设你有一个用户名变量
  String _email = ''; // 假设你有一个电子邮件变量

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
    } else {
      await _fetchUserInfo();  // 获取用户信息
    }
    // 通知 Flutter 需要重建 Widget
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _fetchUserInfo() async {
    var userInfo = await AuthService.getUserInfo();
    if (!mounted) return;  // 检查Widget是否还挂载

    if (userInfo != null) {
      setState(() {
        _username = userInfo['user']['username'] ?? 'N/A';  // 根据你的API调整字段名
        _email = userInfo['user']['email'] ?? 'N/A';        // 根据你的API调整字段名
      });
    } else {
      // 处理userInfo为空的情况，例如通过显示错误消息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch user info')),
      );
    }
  }

  void _logout() async {
    final navigator = Navigator.of(context);
    bool loggedOut = await AuthService.logout();
    if (!mounted) return;  // Add this check
    
    if (loggedOut) {
      // 如果注销成功，导航回登录页面
      navigator.pushReplacementNamed('/login');
    } else {
      // 如果注销失败，显示错误信息
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log out')),
      );
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // 用户名
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Username'),
              subtitle: Text(_username),
            ),
            const Divider(),
            // 电子邮件
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(_email),
            ),
            const Divider(),
            // 更改密码按钮
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.of(context).pushNamed('/password-change');
              },
            ),
            const Divider(),
            // 账户删除确认按钮
            ListTile(
              leading: const Icon(Icons.delete_forever),
              title: const Text('Delete Account'),
              onTap: () {
                Navigator.of(context).pushNamed('/account-delete-confirm');
              },
            ),
            const Divider(),
            // 社交连接页面按钮
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('Social Connections'),
              onTap: () {
                Navigator.of(context).pushNamed('/social-connections');
              },
            ),
            const Divider(),
            // 注销按钮
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }
}
