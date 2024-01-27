import 'package:flutter/material.dart';
import '../../models/social_account.dart';
import '../../services/social_service.dart';

class SocialConnectionsPage extends StatefulWidget {
  const SocialConnectionsPage({super.key});

  @override
  SocialConnectionsPageState createState() => SocialConnectionsPageState();
}

class SocialConnectionsPageState extends State<SocialConnectionsPage> {
  List<SocialAccount> _connectedAccounts = [];
  List<SocialProvider> _availableProviders = [];
  final SocialService _socialService = SocialService();

  @override
  void initState() {
    super.initState();
    _loadSocialConnections();
  }

  void _loadSocialConnections() async {
    try {
      _connectedAccounts = await _socialService.getConnectedAccounts();
      _availableProviders = await _socialService.getAvailableProviders();
      setState(() {});
    } catch (e) {
      // 弹窗显示错误或者以其他方式通知用户
      print('Error loading social connections: $e');
    }
  }

  void _disconnectSocialAccount(SocialAccount account) async {
    try {
      bool disconnected = await _socialService.disconnectAccount(account);
      if (disconnected) {
        setState(() {
          _connectedAccounts.remove(account);
        });
      }
    } catch (e) {
      // 弹窗显示错误或者以其他方式通知用户
      print('Error disconnecting account: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Account Connections'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Social Account Connections',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                ..._connectedAccounts.map(_buildConnectedAccountItem).toList(),
                if (_connectedAccounts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('No social accounts connected.'),
                  ),
                const Text(
                  'Connect a social account:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ..._availableProviders.map(_buildProviderItem).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedAccountItem(SocialAccount account) {
    return ListTile(
      title: Text('Provider: ${account.provider}'),
      subtitle: Text('UID: ${account.uid}'),
      trailing: TextButton(
        onPressed: () => _disconnectSocialAccount(account),
        child: const Text('Disconnect'),
      ),
    );
  }

  Widget _buildProviderItem(SocialProvider provider) {
    return ListTile(
      title: Text('Connect with ${provider.name}'),
      onTap: () {
        _socialService.connectWithProvider(provider);
      },
    );
  }
}
