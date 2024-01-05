/// This file contains the CreateReportPage class, which is responsible for rendering the page for creating a new traffic violation report.
/// It includes the form for entering the report details, the functionality for uploading media files, and the logic for submitting the report.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:logger/logger.dart';
import 'dart:typed_data';
import '../../models/traffic_violation.dart';
import '../../services/report_service.dart';
import '../../components/media_picker.dart';
import '../../components/media_preview.dart';
import '../../components/report_form.dart';

final Logger logger = Logger();
/// The CreateReportPage class is a StatefulWidget that renders the page for creating a new traffic violation report.
class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  /// Creates the mutable state for this widget at a given location in the tree.
  @override
  CreateReportPageState createState() => CreateReportPageState();
}

/// The CreateReportPageState class is the logic and internal state for the CreateReportPage widget.
class CreateReportPageState extends State<CreateReportPage> {
  /// The key to the form widget.
  final _formKey = GlobalKey<FormState>();
  /// The image picker for picking media files.
  final _picker = ImagePicker();
  /// The list of media files to be uploaded.
  final List<XFile> _mediaFiles = [];
  /// The traffic violation to be reported.
  final TrafficViolation _violation = TrafficViolation(
    date: DateTime.now(),
    time: TimeOfDay.now(),
    violation: '紅線停車',
    status: 'Pending',
  );

  /// The list of violation types.
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

  /// The controller for the date text field.
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
      if (_dateController.text.isEmpty) {
        _dateController.text = DateFormat('yyyy-MM-dd').format(_violation.date!);
      }

      if (_timeController.text.isEmpty) {
        _timeController.text = _violation.time!.format(context);
      }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();

    _videoControllers.forEach((_, controller) => controller.dispose());
    _videoControllers.clear();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Report'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ReportForm(
              formKey: _formKey,
              violation: _violation,
              dateController: _dateController,
              timeController: _timeController,
              violations: _violations,
              onDateSaved: (pickedDate) {
                if (pickedDate != null) {
                  setState(() {
                    _violation.date = pickedDate;
                    _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                  });
                }
              },
              onTimeSaved: (pickedTime) {
                if (pickedTime != null) {
                  setState(() {
                    _violation.time = pickedTime;
                    _timeController.text = pickedTime.format(context);
                  });
                }
              },
              onLicensePlateSaved: (value) => _violation.licensePlate = value,
              onLocationSaved: (value) => _violation.location = value,
              onOfficerSaved: (value) => _violation.officer = value,
              onStatusChanged: (value) {
                setState(() {
                  _violation.status = value;
                });
              },
            ),
            // Media Upload
            ElevatedButton(
              onPressed: () => _pickMedia(),
              child: const Text('Add Media'),
            ),
            const SizedBox(height: 10),
            MediaPreview(
              mediaFiles: _mediaFiles,
              onRemove: _removeMedia,
            ),
            // Submit Button
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _submitReport();
                }
              },
              child: const Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }

  void _pickMedia() async {
    final List<XFile>? pickedFiles = await MediaPicker.pickMedia(context, enableCamera: true);

    // 检查是否有文件被选中
    if (pickedFiles == null || pickedFiles.isEmpty) return;

    // 检查选择的媒体数量
    if (pickedFiles.length > 5) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only select up to 5 media files.')),
        );
      }
      return;
    }

    List<XFile> validFiles = [];
    
    // 检查每个媒体文件的大小
    for (var file in pickedFiles) {
      final fileLength = await File(file.path).length();
      if (fileLength > 100 * 1024 * 1024) { // 100MB
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Each file must be less than 100MB')),
          );
        }
      } else {
        validFiles.add(file);
      }
    }

    // 更新状态
    if (mounted) {
      setState(() {
        _mediaFiles.addAll(validFiles);
        for (var file in validFiles) {
          if (_isVideoFile(file.path)) {
            _initVideoController(file);
          }
        }
      });
    }
  }

  void _initVideoController(XFile file) {
    VideoPlayerController controller = VideoPlayerController.file(File(file.path))
      ..initialize().then((_) {
        logger.i('Video initialized successfully.');
        setState(() {});
      }).catchError((error) {
        logger.e('Video initialization error: $error');
      });
    _videoControllers[file.path] = controller;
  }

  void _removeMedia(XFile file) {
    setState(() {
      _mediaFiles.remove(file);
      _videoControllers[file.path]?.dispose();
      _videoControllers.remove(file.path);
    });
  }

  void _submitReport() async {
    // 确保至少有一个视频文件
    bool hasVideo = _mediaFiles.any((file) => _isVideoFile(file.path));
    if (!hasVideo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please include at least one video file.')),
      );
      return;
    }

    // 获取 context 依赖的信息
    final reportService = Provider.of<ReportService>(context, listen: false);

    bool success = await reportService.createReport(_violation, _mediaFiles);
    
    if (!mounted) return; // 检查组件是否仍然挂载

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report submitted successfully')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to submit report')));
    }
  }
}