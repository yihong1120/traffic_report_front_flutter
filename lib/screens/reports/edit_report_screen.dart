import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/traffic_violation.dart';
import '../../services/report_service.dart';
import '../../components/media_preview.dart';
import '../../components/report_form.dart';

// 创建一个自定义的类来表示远程媒体文件
class RemoteMediaFile {
  final String url;
  RemoteMediaFile(this.url);
}

class EditReportPage extends StatefulWidget {
  final int recordId;

  const EditReportPage({super.key, required this.recordId});

  @override
  EditReportPageState createState() => EditReportPageState();
}

class EditReportPageState extends State<EditReportPage> {
  late TrafficViolation _violation;
  final ImagePicker _picker = ImagePicker();
  final List<RemoteMediaFile> _remoteMediaFiles = []; // 用于存储远程媒体文件
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _licensePlateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _officerController = TextEditingController();
  String _selectedStatus = '';

  @override
  void initState() {
    super.initState();
    _loadViolation();
  }

  void _loadViolation() async {
    try {
      _violation = await Provider.of<ReportService>(context, listen: false).getViolation(widget.recordId);
      _dateController.text = DateFormat('yyyy-MM-dd').format(_violation.date!);
      _timeController.text = _violation.time!.format(context);
      _licensePlateController.text = _violation.licensePlate ?? '';
      _locationController.text = _violation.location ?? '';
      _officerController.text = _violation.officer ?? '';
      _selectedStatus = _violation.status ?? '';
      // 加载远程媒体文件
      _remoteMediaFiles.addAll(_violation.mediaUrls.map((url) => RemoteMediaFile(url)).toList());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load report: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
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
            /**
             * This function builds and returns the main content of the edit report screen.
             * It includes the report form, media preview, and buttons for adding media and submitting the report.
             */
            Widget _buildMainContent() {
              ReportForm(
                formKey: _formKey,
                violation: _violation,
                dateController: _dateController,
                timeController: _timeController,
                licensePlateController: _licensePlateController,
                locationController: _locationController,
                officerController: _officerController,
                selectedStatus: _selectedStatus,
              ),
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
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _mediaFiles.addAll(pickedFiles);
      });
    }
  }

  void _removeMedia(XFile file) {
    setState(() {
      _mediaFiles.remove(file);
    });
  }

  void _submitReport() async {
    if (_formKey.currentState!.validate()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);

      _violation.licensePlate = _licensePlateController.text;
      _violation.location = _locationController.text;
      _violation.officer = _officerController.text;
      _violation.status = _selectedStatus;

      setState(() {
        _isLoading = true;
      });

      try {
        final reportService = Provider.of<ReportService>(context, listen: false);
        // 注意：这里需要传递本地媒体文件列表，如果有的话
        // 如果您还需要处理远程媒体文件，请确保 ReportService 的 updateReport 方法支持它
        bool success = await reportService.updateReport(_violation, /* 本地媒体文件列表 */);

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
      } catch (e) {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}