import 'package:flutter/material.dart';

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              '菜單',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context); // 关闭 Drawer
              Navigator.popUntil(context, ModalRoute.withName('/')); // 返回到根路由
            },
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text('Create Report'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/create'); // 更新为正确的路由
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Report'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/reports'); // 更新为正确的路由
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('Chatbot'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/chat'); // 更新为正确的路由
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Accounts'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/accounts'); // 更新为正确的路由
            },
          ),
          // 您可以根据需要添加更多的菜单项
        ],
      ),
    );
  }
}
