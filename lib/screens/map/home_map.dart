import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(23.6978, 120.9605);
  String _searchKeyword = '';
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? ''; // 獲取 API 密鑰
    // 使用 apiKey 進行相關操作
    // 初始加載標記
    _loadMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _loadMarkers() async {
    // 此處模擬從後端加載標記數據
    // 您需要根據您的API替換這部分代碼
    // 假設從API獲取到的數據是一個包含經緯度和標題的列表

    List<Map<String, dynamic>> mockData = [
      {"lat": 23.6978, "lng": 120.9605, "title": "違規地點1"},
      // ... 其他數據
    ];

    setState(() {
      _markers.clear();
      for (var markerData in mockData) {
        final marker = Marker(
          markerId: MarkerId(markerData['title']),
          position: LatLng(markerData['lat'], markerData['lng']),
          infoWindow: InfoWindow(
            title: markerData['title'],
            snippet: '點擊查看詳情',
          ),
        );
        _markers.add(marker);
      }
    });
  }

  void _searchData() async {
    // 根據 _searchKeyword 進行搜索
    // 搜索後的處理可能會涉及與後端的交互
    // 更新 _markers 集合以反映搜索結果
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('交通違規報告系統')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) => _searchKeyword = value,
              decoration: InputDecoration(
                labelText: '搜索',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchData,
                ),
              ),
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 11.0,
              ),
              markers: _markers,
            ),
          ),
        ],
      ),
    );
  }
}
