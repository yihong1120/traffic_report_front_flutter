import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // 导入 intl 包
import '../../models/traffic_violation.dart';
import '../../services/report_service.dart';

class CreateReportScreen extends StatefulWidget {
  @override
  _CreateReportScreenState createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  List<XFile> _mediaFiles = [];
  TrafficViolation _violation = TrafficViolation(
    date: DateTime.now(), // 初始化日期
    time: TimeOfDay.now(), // 初始化时间
    violation: '紅線停車', // 初始化违规类型
    status: 'Pending', // 初始化状态
  );

  // 违规类型选项
  final List<String> _violations = [
    '紅線停車',
    '黃線臨車',
    '行駛人行道',
    '未停讓行人',
    '切換車道未打方向燈',
    '人行道停車',
    '騎樓停車',
    '闖紅燈',
    '逼車',
    '未禮讓直行車',
    '未依標線行駛',
    '其他',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Report'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildLicensePlateField(),
                  decoration: InputDecoration(labelText: 'License Plate'),
                  onSaved: (value) => _violation.licensePlate = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a license plate';
                    }
                    return null;
                  },
                ),
                // Date Picker
                _buildDatePicker(),
                        lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                        setState(() {
                        _violation.date = pickedDate;
                        });
                    }
                    },
                ),
                // Time Picker
                _buildTimePicker(),
                    if (pickedTime != null) {
                        setState(() {
                        _violation.time = pickedTime;
                        });
                    }
                    },
                ),
                // Violation Dropdown
                _buildViolationDropdown(),
                decoration: InputDecoration(labelText: 'Violation'),
                items: _violations.map((String violation) {
                    return DropdownMenuItem<String>(
                    value: violation,
                    child: Text(violation),
                    );
                }).toList(),
                onChanged: (String? newValue) {
                    setState(() {
                    _violation.violation = newValue;
                    });
                },
                onSaved: (String? newValue) {
                    _violation.violation = newValue;
                },
                );
                // Status Dropdown
                DropdownButtonFormField<String>(
                    value: _violation.status,
                    decoration: InputDecoration(labelText: 'Status'),
                    items: TrafficViolation.STATUS.map((status) {
                    return DropdownMenuItem(
                        value: status,
                        child: Text(status),
                    );
                    }).toList(),
                    onChanged: (value) {
                    setState(() {
                        _violation.status = value;
                    });
                    },
                ),
                // Location Field
                TextFormField(
                    decoration: InputDecoration(labelText: 'Location'),
                    onSaved: (value) => _violation.location = value,
                _buildStatusDropdown(),
                // Officer Field
                _buildOfficerField(),
                    decoration: InputDecoration(labelText: 'Officer'),
                    onSaved: (value) => _violation.officer = value,
                ),
                // Media Upload
                _buildAddMediaButton(),
                    onPressed: () => _pickMedia(),
                    child: Text('Add Media'),
                ),
                SizedBox(height: 10),
                _buildMediaPreview(),
                // Submit Button
                _buildSubmitButton(),
                    onPressed: () {
                    if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _submitReport();
                    }
                    },
                    child: Text('Submit Report'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickMedia() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _mediaFiles.addAll(pickedFiles);
      });
    }
  }

  Widget _buildMediaPreview() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _mediaFiles.map((file) {
        return Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            Image.file(File(file.path), width: 100, height: 100),
            IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () => _removeMedia(file),
            ),
          ],
        );
      }).toList(),
    );
  }

  void _removeMedia(XFile file) {
    setState(() {
      _mediaFiles.remove(file);
    });
  }

  void _submitReport() async {
    // Call the ReportService to submit the report and media files
    final reportService = Provider.of<ReportService>(context, listen: false);
    bool success = await reportService.createReport(_violation, _mediaFiles);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Report submitted successfully')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to submit report')));
    }
  }
}