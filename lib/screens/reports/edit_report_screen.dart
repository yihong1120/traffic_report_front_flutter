import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/traffic_violation.dart';
import '../../models/media_file.dart';
import '../../services/report_service.dart';
import '../../components/media_preview.dart';
import '../../components/report_form.dart';

class EditReportPage extends StatefulWidget {
  final int recordId;

  const EditReportPage({super.key, required this.recordId});

  @override
  EditReportPageState createState() => EditReportPageState();
}

class EditReportPageState extends State<EditReportPage> {
  late TrafficViolation _violation;
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _localMediaFiles = []; // 用于存储本地媒体文件
  final List<MediaFile> _remoteMediaFiles = []; // 用于存储远程媒体文件
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _officerController = TextEditingController();
  String _selectedStatus = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadViolation();
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  void _loadViolation() async {
    try {
      _violation = await Provider.of<ReportService>(context, listen: false)
          .getViolation(widget.recordId);
      _dateController.text = DateFormat('yyyy-MM-dd').format(_violation.date!);
      // Save TimeOfDay in a variable before using it with context
      TimeOfDay? violationTime = _violation.time;

      _licensePlateController.text = _violation.license_plate ?? '';
      _locationController.text = _violation.address ?? '';
      _officerController.text = _violation.officer ?? '';
      _selectedStatus = _violation.status ?? '';
      // Load remote media files
      _remoteMediaFiles.addAll(_violation.mediaFiles);

      // Check if the widget is still mounted before using context
      if (mounted && violationTime != null) {
        _timeController.text = violationTime.format(context);
      }
    } catch (e) {
      _showSnackBar('Failed to load report: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _licensePlateController.dispose();
    _locationController.dispose();
    _officerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Report')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Report')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ReportForm(
                formKey: _formKey,
                violation: _violation,
                dateController: _dateController,
                timeController: _timeController,
                violations: TrafficViolation.violations, // 这里传递违规类型列表
                onDateSaved: (pickedDate) {
                  // 保存选择的日期
                },
                onTimeSaved: (pickedTime) {
                  // 保存选择的时间
                },
                onLicensePlateSaved: (value) {
                  _violation.license_plate = value;
                },
                onLocationSaved: (value) {
                  _violation.address = value;
                },
                onOfficerSaved: (value) {
                  _violation.officer = value;
                },
                onStatusChanged: (value) {
                  setState(() {
                    _violation.status = value;
                  });
                },
              ),
              MediaPreview(
                  mediaFiles: _localMediaFiles, onRemove: _removeLocalMedia),
              ElevatedButton(
                onPressed: _pickMedia,
                child: const Text('Add Media'),
              ),
              ElevatedButton(
                onPressed: _submitReport,
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickMedia() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    // 这里添加了对文件大小的检查
    for (var file in pickedFiles) {
      final fileSize = await File(file.path).length();
      if (fileSize <= 100 * 1024 * 1024) {
        // 限制文件大小为100MB
        setState(() {
          _localMediaFiles.add(file);
        });
      }
    }
  }

  void _removeLocalMedia(XFile file) {
    setState(() {
      _localMediaFiles.remove(file);
    });
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      // 更新违规实例的属性
      _violation.license_plate = _licensePlateController.text;
      _violation.address = _locationController.text;
      _violation.officer = _officerController.text;
      _violation.status = _selectedStatus;

      setState(() => _isLoading = true);

      try {
        final reportService =
            Provider.of<ReportService>(context, listen: false);

        // 将远程和本地媒体文件传递给更新方法
        bool success = await reportService.updateReport(
          _violation,
          localMediaFiles: _localMediaFiles,
          remoteMediaFiles: _remoteMediaFiles.map((e) => e.url).toList(),
        );

        if (success) {
          scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('Report updated successfully')));
          navigator.pop();
        } else {
          scaffoldMessenger.showSnackBar(
              const SnackBar(content: Text('Failed to update report')));
        }
      } catch (e) {
        scaffoldMessenger
            .showSnackBar(SnackBar(content: Text('An error occurred: $e')));
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
