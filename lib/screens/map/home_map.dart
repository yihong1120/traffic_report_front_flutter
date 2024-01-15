import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;

var logger = Logger();

class HomeMapPage extends StatefulWidget {
  const HomeMapPage({super.key});

  @override
  State<HomeMapPage> createState() => _HomeMapPageState();
}

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

  void _loadMarkers() async {
    try {
      // 指定 API URL
      var url = Uri.parse('http://127.0.0.1:8000/api/traffic-violation-markers/');
      // 发送请求并等待响应
      var response = await http.get(url);

      if (response.statusCode == 200) {
        // 解析响应数据
        List<dynamic> data = json.decode(response.body);

        setState(() {
          _markers.clear();
          for (var markerData in data) {
            // 安全地获取数据，并为缺失的字段提供默认值
            String licensePlate = markerData['license_plate']?.toString() ?? '未知';
            String violation = markerData['violation']?.toString() ?? '未知';
            String date = markerData['date']?.toString() ?? '未知';
            double lat = markerData['lat'] != null ? markerData['lat'].toDouble() : 0.0;
            double lng = markerData['lng'] != null ? markerData['lng'].toDouble() : 0.0;

            // 创建标记
            final marker = Marker(
              markerId: MarkerId(markerData['traffic_violation_id'].toString()),
              position: LatLng(lat, lng),
              infoWindow: InfoWindow(
                title: '$licensePlate - $violation',
                snippet: '车牌号: $licensePlate\n违章: $violation\n日期: $date',
              ),
              onTap: () => _onMarkerTapped(markerData['traffic_violation_id'].toString()),
            );
            // 将标记添加到地图上
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

  void _onMarkerTapped(String trafficViolationId) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/traffic-violation-details/$trafficViolationId/');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // 确保解析为 UTF-8 编码
        var decodedData = utf8.decode(response.bodyBytes);
        var data = json.decode(decodedData);
        // print(data);
        setState(() {
          var newMarkers = <Marker>{};
          for (var marker in _markers) {
            if (marker.markerId.value == trafficViolationId) {
              String title = '${data['license_plate']?.toString() ?? '未知'} - ${data['violation']?.toString() ?? '未知'}';
              String snippet = '车牌号: ${data['license_plate']?.toString() ?? '未知'}\n'
                                '违章: ${data['violation']?.toString() ?? '未知'}\n'
                                '日期: ${data['date']?.toString() ?? '未知'}\n'
                                '时间: ${data['time']?.toString() ?? '未知'}\n'
                                '地址: ${data['address']?.toString() ?? '未知'}\n'
                                '官员: ${data['officer']?.toString() ?? '未知'}';


              logger.i(snippet);
              newMarkers.add(
                Marker(
                  markerId: marker.markerId,
                  position: marker.position,
                  infoWindow: InfoWindow(
                    title: title,
                    snippet: snippet,
                  ),
                  onTap: () => _onMarkerTapped(marker.markerId.value), // 保持原有的 onTap 行为
                ),
              );
            } else {
              newMarkers.add(marker);
            }
          }

          _markers.clear();
          _markers.addAll(newMarkers);
        });
      } else {
        logger.e('Failed to load traffic violation details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Error loading traffic violation details: $e');
    }
  }

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
    return Column(
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
      );
  }
}