import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

var logger = Logger();

/// A StatefulWidget that represents the home map page of the Traffic Violation Report System.
class HomeMapPage extends StatefulWidget {
  const HomeMapPage({super.key});

  @override
  State<HomeMapPage> createState() => _HomeMapPageState();
}

/// A State class that represents the state of the home map page in the Traffic Violation Report System.
class _HomeMapPageState extends State<HomeMapPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(23.6978, 120.9605);
  String _searchKeyword = '';
  DateTimeRange? _selectedDateRange;
  final Set<Marker> _markers = {};
  String _selectedTimeRange = '今日';

  // 定義時間範圍選項
  final List<String> _timeRangeOptions = [
    '今日',
    '昨天',
    '過去七天',
    '過去一個月',
    '過去半年',
    '過去一年',
    '自訂時間範圍',
  ];

  @override
  void initState() {
    super.initState();
    // String GOOGLE_MAPS_API_KEY =
    //    dotenv.env['GOOGLE_MAPS_API_KEY'] ?? ''; // 獲取 API 密鑰
    // 使用 apiKey 進行相關操作
    // 初始加載標記
    _loadMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Loads the markers from the backend API and updates the _markers set.
  ///
  /// This function retrieves marker data from the backend API and updates the _markers set with the data obtained.
    try {
      var url = Uri.parse('http://127.0.0.1:8000/api/traffic-violation-markers/');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        setState(() {
          _markers.clear();
          for (var markerData in data) {
            final marker = Marker(
              markerId: MarkerId(markerData['title'] ?? 'Unknown'), // 使用 'Unknown' 作為後備值
              position: LatLng(markerData['lat'], markerData['lng']),
              infoWindow: InfoWindow(
                title: markerData['title'] ?? 'Unknown', // 同上
                snippet: '點擊查看詳情',
              ),
            );
            _markers.add(marker);
          }
        });
      } else {
        logger.e('Failed to load markers. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error loading markers: $e');
    }
  }

    /// Searches for data based on the _searchKeyword and _selectedDateRange and updates the _markers set.
  ///
  /// This function triggers a search based on the _searchKeyword and _selectedDateRange, and updates the _markers set with the search results.
  void _searchData() async {
    // 根據 _searchKeyword 和 _selectedDateRange 進行搜索
    // 搜索後的處理可能會涉及與後端的交互
    // 更新 _markers 集合以反映搜索結果

    // 這裡是搜索邏輯的假設實現，你需要根據你的後端API進行調整
    logger.i('搜索关键字: $_searchKeyword');
    if (_selectedDateRange != null) {
      logger.i(
          '搜索时间范围: ${_selectedDateRange!.start} - ${_selectedDateRange!.end}');
    } else {
      logger.i('搜索预设时间范围: $_selectedTimeRange');
    }

    // 假設這是從後端獲取的搜索結果
    List<Map<String, dynamic>> searchResults = [
      // ... 搜索結果數據
    ];

    setState(() {
      _markers.clear();
      for (var result in searchResults) {
        final marker = Marker(
          markerId: MarkerId(result['title']),
          position: LatLng(result['lat'], result['lng']),
          infoWindow: InfoWindow(
            title: result['title'],
            snippet: '點擊查看詳情',
          ),
        );
        _markers.add(marker);
      }
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
  /// Shows a date range picker dialog and updates the _selectedDateRange and _selectedTimeRange variables.
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _selectedTimeRange = '自訂時間範圍';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('交通違規報告系統')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('菜單'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // 導航到 Home 頁面
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Create Report'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/create');
              },
            ),
            ListTile(
              title: const Text('Edit Report'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/reports');
              },
            ),
            ListTile(
              title: const Text('Chatbot'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/chat');
              },
            ),
            ListTile(
              title: const Text('Accounts'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/accounts');
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
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
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedTimeRange,
                  onChanged: (String? newValue) {
                    setState(() {
                      if (newValue == '自訂時間範圍') {
                        _selectDateRange(context);
                      } else if (newValue == '今日') {
                        _selectedTimeRange = newValue ?? '今日'; // 使用空合併運算符
                        _selectedDateRange = DateTimeRange(
                          start: DateTime.now(),
                          end: DateTime.now(),
                        );
                      } else {
                        _selectedTimeRange = newValue ?? _selectedTimeRange; // 使用空合併運算符
                        _selectedDateRange = null;
                      }
                    });
                  },
                  items: _timeRangeOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
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