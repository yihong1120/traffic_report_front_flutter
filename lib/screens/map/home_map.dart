import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:traffic_report_front_flutter/utils/date_time_range_util.dart';
import 'package:traffic_report_front_flutter/components/search_bar.dart'
    as custom;
import '../../components/time_range_dropdown.dart';
import '../../components/custom_info_window.dart';
import '../../services/map_service.dart';
import '../../utils/markers_management.dart';
import '../../utils/constants.dart';
import '../../models/traffic_violation.dart';

class HomeMapPage extends StatefulWidget {
  const HomeMapPage({super.key});

  @override
  _HomeMapPageState createState() => _HomeMapPageState();
}

class _HomeMapPageState extends State<HomeMapPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(23.6978, 120.9605);
  String _searchKeyword = '';
  DateTimeRange? _selectedDateRange;
  String _selectedTimeRange = '今日';
  bool _showInfoWindow = false;
  TrafficViolation? _selectedViolation;
  final MapService _mapService = MapService();
  final MarkersManagement _markersManagement = MarkersManagement();

  @override
  void initState() {
    super.initState();
    _loadMarkers();
  }

  void _loadMarkers() async {
    try {
      Set<Marker> markers = await _mapService.loadMarkers(_onMarkerTapped);
      setState(() {
        // 使用 _markersManagement 更新标记
        _markersManagement.updateMarkers(markers);
      });
    } catch (e) {
      debugPrint('Failed to load markers: $e');
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _onMarkerTapped(String trafficViolationId) {
    print('Clicked Marker ID: $trafficViolationId'); // 输出点击的标记的 ID
    // Handle marker tap
    _mapService.getTrafficViolationDetails(trafficViolationId).then((details) {
      if (details != null) {
        setState(() {
          _showInfoWindow = true;
          _selectedViolation = details;
          // Assuming you have a method to update the marker color in your MarkersManagement class
          _markersManagement.updateMarkerColor(
              trafficViolationId, Colors.yellow);
        });
      }
    }).catchError((error) {
      // Handle error
      debugPrint('Error fetching traffic violation details: $error');
    });
  }

  void _searchData() {
    // Handle search
    _mapService.searchData(_searchKeyword, _selectedDateRange, (results) {
      setState(() {
        _markersManagement.updateMarkers(results);
      });
    });
  }

  // This method is called when the time range is changed using the TimeRangeDropdown
  void _onTimeRangeChanged(String? newValue) {
    if (newValue != null && newValue != _selectedTimeRange) {
      setState(() {
        _selectedTimeRange = newValue;
        _selectedDateRange =
            DateTimeRangeUtil.getTimeRangeFromDateRange(newValue);
        _searchData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Format the date to a string or provide a fallback value if null
    String formattedDate = _selectedViolation?.date != null
        ? DateFormat('yyyy-MM-dd').format(_selectedViolation!.date!)
        : 'Unknown Date';

    // Provide fallback values for other nullable properties
    String licensePlate =
        _selectedViolation?.licensePlate ?? 'Unknown License Plate';
    String violation = _selectedViolation?.violation ?? 'Unknown Violation';
    String location = _selectedViolation?.location ?? 'Unknown location';
    // String time = _selectedViolation?.time ?? 'Unknown time';
    String time = _selectedViolation?.time?.toString() ?? 'Unknown time';

    String officer = _selectedViolation?.officer ?? 'Unknown officers';
    String status = _selectedViolation?.status ?? 'Unknown status';

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Home Map'),
      // ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: custom.SearchBar(
                        onSearch: (value) {
                          setState(() {
                            _searchKeyword = value;
                          });
                          _searchData();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    TimeRangeDropdown(
                      selectedTimeRange: _selectedTimeRange,
                      timeRangeOptions:
                          timeRangeOptions, // Now this parameter is defined in the component
                      onTimeRangeChanged: _onTimeRangeChanged,
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
                  // markers: _markersManagement.markers,
                  markers: Set<Marker>.of(_markersManagement.markers), // 确保使用正确的标记集合
                ),
              ),
            ],
          ),
          if (_showInfoWindow && _selectedViolation != null)
            Positioned(
              top: 100, // Adjust as needed
              left: 50, // Adjust as needed
              child: CustomInfoWindow(
                licensePlate: licensePlate,
                violation: violation,
                date: formattedDate,
                time: time,
                location: location,
                officer: officer,
                status: status,
              ),
            ),
        ],
      ),
    );
  }
}
