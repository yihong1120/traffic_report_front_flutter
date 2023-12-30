import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Navigation Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => _navigateTo(context, '/'), // 导航到主页，根据实际路由调整
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('Reports'),
            onTap: () => _navigateTo(context, '/reports'), // 调整为实际报告页面的路由
          ),
          ListTile(
            leading: Icon(Icons.chat),
            title: Text('Chatbot'),
            onTap: () => _navigateTo(context, '/chat'), // 调整为实际聊天页面的路由
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Accounts'),
            onTap: () => _navigateTo(context, '/accounts'), // 调整为实际账户页面的路由
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.pop(context); // 关闭抽屉
    if (ModalRoute.of(context)?.settings.name != route) {
      Navigator.pushNamed(context, route);
    }
  }
}
