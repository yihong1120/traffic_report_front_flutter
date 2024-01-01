import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/traffic_violation.dart';
import '../../services/report_service.dart';
import '../../components/media_preview.dart';

class EditReportPage extends StatefulWidget {
  final int recordId;

  const EditReportPage({super.key, required this.recordId});

  @override
  _EditReportPageState createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  late TrafficViolation _violation;
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _mediaFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadViolation();
  }

  void _loadViolation() async {
    // 加載違規報告資料
    _violation = await Provider.of<ReportService>(context, listen: false).getViolation(widget.recordId);
    setState(() => _isLoading = false);
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
              TextFormField(
                initialValue: _violation.licensePlate,
                decoration: const InputDecoration(labelText: 'License Plate'),
                onChanged: (value) => _violation.licensePlate = value,
              ),
              // 其他表單字段
              MediaPreview(mediaFiles: _mediaFiles, onRemove: _removeMedia),
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
    setState(() {
      _mediaFiles.addAll(pickedFiles);
    });
  }

  void _removeMedia(XFile file) {
    setState(() {
      _mediaFiles.remove(file);
    });
  }

  void _submitReport() async {
    // 在異步操作前獲取 ScaffoldMessenger 和 Navigator 的實例
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    setState(() {
      _isLoading = true;
    });

    final reportService = Provider.of<ReportService>(context, listen: false);
    bool success = await reportService.updateReport(_violation, _mediaFiles);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Report updated successfully')),
      );
      navigator.pop();
    } else {
      scaffoldMessenger.showSnackBar(
        const SnackBar(content: Text('Failed to update report')),
      );
    }
  }
}