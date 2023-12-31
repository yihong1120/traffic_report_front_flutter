import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


import '../../models/traffic_violation.dart';

import '../../components/media_preview.dart';

class EditReportPage extends StatefulWidget {
  final int recordId;

  const EditReportPage({super.key, required this.recordId});

  @override
  _EditReportPageState createState() => _EditReportPageState();
}

class _EditReportPageState extends State<EditReportPage> {
  // Removed unused fields _violation and _picker
  final List<XFile> _mediaFiles = [];
  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadViolation();
  }

  void _loadViolation() async {
    // TODO: Load the violation data from the backend using the recordId
    // For example:
    // Code related to _violation removed
    // setState(() => _isLoading = false);
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
              // TODO: Add form fields and media upload logic
              // For example:
              // TextFormField(
              // Code related to _violation removed
              // ),
              // ...
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
    // TODO: Implement media picking logic
  }

  void _removeMedia(XFile file) {
    // TODO: Implement media removal logic
  }

  void _submitReport() async {
    // TODO: Implement report submission logic
  }
}