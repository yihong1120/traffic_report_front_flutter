import 'package:flutter/material.dart';
import 'package:your_project_name/models/social_account.dart'; // 假設您有一個 SocialAccount 模型
import 'package:your_project_name/services/social_service.dart'; // 假設您有一個處理社交帳號的服務

class SocialConnectionsPage extends StatefulWidget {
  const SocialConnectionsPage({Key? key}) : super(key: key);

  @override
  _SocialConnectionsPageState createState() => _SocialConnectionsPageState();
}

class _SocialConnectionsPageState extends State<SocialConnectionsPage> {
  List<SocialAccount> _connectedAccounts = [];
  List<SocialProvider> _availableProviders = []; // 假設 SocialProvider 是一個包含提供者信息的模型

  @override
  void initState() {
    super.initState();
    _loadSocialConnections();
  }

  void _loadSocialConnections() async {
    // 加載已連結的社交帳號和可用的社交帳號提供者
    _connectedAccounts = await SocialService.getConnectedAccounts();
    _availableProviders = await SocialService.getAvailableProviders();
    setState(() {});
  }

  void _disconnectSocialAccount(SocialAccount account) async {
    // 處理取消連結邏輯
    bool disconnected = await SocialService.disconnectAccount(account);
    if (disconnected) {
      setState(() {
        _connectedAccounts.remove(account);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Account Connections'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Social Account Connections',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ..._connectedAccounts.map((account) => ListTile(
                      title: Text('Provider: ${account.provider}'),
                      subtitle: Text('UID: ${account.uid}'),
                      trailing: TextButton(
                        onPressed: () => _disconnectSocialAccount(account),
                        child: Text('Disconnect'),
                      ),
                    )),
                if (_connectedAccounts.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('No social accounts connected.'),
                  ),
                Text(
                  'Connect a social account:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ..._availableProviders.map((provider) => ListTile(
                      title: Text('Connect with ${provider.name}'),
                      onTap: () {
                        // 處理連結邏輯
                        SocialService.connectWithProvider(provider);
                      },
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}