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
  List<SocialProvider> _availableProviders =
      []; // Assuming SocialProvider is a model containing provider information
  final SocialService _socialService =
      SocialService(); // Create an instance of SocialService

  @override
  void initState() {
    super.initState();
    _loadSocialConnections();
  }

  void _loadSocialConnections() async {
    // Load connected social accounts and available social account providers
    _connectedAccounts = await _socialService
        .getConnectedAccounts(); // Call the method on the instance
    _availableProviders = await SocialService
        .getAvailableProviders(); // Call the method on the instance
    setState(() {});
  }

  void _disconnectSocialAccount(SocialAccount account) async {
    // Handle disconnect logic
    bool disconnected = await SocialService.disconnectAccount(
        account); // Call the method on the instance
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
                ..._connectedAccounts.map((account) => ListTile(
                      title: Text('Provider: ${account.provider}'),
                      subtitle: Text('UID: ${account.uid}'),
                      trailing: TextButton(
                        onPressed: () => _disconnectSocialAccount(account),
                        child: const Text('Disconnect'),
                      ),
                    )),
                if (_connectedAccounts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('No social accounts connected.'),
                  ),
                const Text(
                  'Connect a social account:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ..._availableProviders.map((provider) => ListTile(
                      title: Text('Connect with ${provider.name}'),
                      onTap: () {
                        // Handle connect logic
                        SocialService.connectWithProvider(
                            provider); // Call the method on the instance
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
