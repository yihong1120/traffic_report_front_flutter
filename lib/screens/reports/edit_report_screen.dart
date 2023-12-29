import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/traffic_violation.dart';
import '../../services/report_service.dart';
import '../../components/media_preview.dart';

class EditReportScreen extends StatefulWidget {
  final int recordId;

  EditReportScreen({Key? key, required this.recordId}) : super(key: key);

  @override
  _EditReportScreenState createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  late TrafficViolation _violation;
  final ImagePicker _picker = ImagePicker();
  List<XFile> _mediaFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadViolation();
  }

  void _loadViolation() async {
    // TODO: Load the violation data from the backend using the recordId
    // For example:
    // _violation = await Provider.of<ReportService>(context, listen: false).getViolation(widget.recordId);
    // setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Edit Report')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Edit Report')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // TODO: Add form fields and media upload logic
              // For example:
              // TextFormField(
              //   initialValue: _violation.licensePlate,
              //   decoration: InputDecoration(labelText: 'License Plate'),
              //   onChanged: (value) => _violation.licensePlate = value,
              // ),
              // ...
              MediaPreview(mediaFiles: _mediaFiles, onRemove: _removeMedia),
              ElevatedButton(
                onPressed: _pickMedia,
                child: Text('Add Media'),
              ),
              ElevatedButton(
                onPressed: _submitReport,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _pickMedia() async {
    // TODO: Implement media picking logic
  }

  void _removeMedia(XFile file) {
    // TODO: Implement media removal logic
  }

  void _submitReport() async {
    // TODO: Implement report submission logic
  }
}