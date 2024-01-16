import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // 引入這個來檢查是否在Web平台
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../../models/traffic_violation.dart';
import '../../services/report_service.dart';
import '../../components/media_picker.dart';
import '../../components/media_preview.dart';
import '../../components/report_form.dart';
import '../../utils/media_utils.dart';

final Logger logger = Logger();

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  CreateReportPageState createState() => CreateReportPageState();
}

class CreateReportPageState extends State<CreateReportPage> {
  final _formKey = GlobalKey<FormState>();
  final List<XFile> _mediaFiles = [];
  final TrafficViolation _violation = TrafficViolation(
    date: DateTime.now(),
    time: TimeOfDay.now(),
    violation: '紅線停車',
    status: 'Pending',
  );

  // 违规类型选项
  final List<String> _violations = TrafficViolation.violations; // 假设这是从 TrafficViolation 类获取的

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
    // 一次释放 TextEditingControllers
    _dateController.dispose();
    _timeController.dispose();

    // 释放 VideoPlayerControllers
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    _videoControllers.clear();
    
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

    if (!mounted) return; // 檢查異步操作之後是否仍掛載

    if (pickedFiles == null || pickedFiles.isEmpty) return;

    if (pickedFiles.length > 5) {
      if (!mounted) return; // 再次檢查
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only select up to 5 media files.')),
      );
      return;
    }

    List<XFile> validFiles = [];
    for (var file in pickedFiles) {
      // 在 Web 上使用 file.length 而不是 File(file.path).length()
      final fileLength = await file.length();
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

    if (mounted) {
      setState(() {
        _mediaFiles.addAll(validFiles);
        for (var file in validFiles) {
          if (MediaUtils.isVideoFile(file.path)) {
            _initVideoController(file);
          }
        }
      });
    }
  }

  void _initVideoController(XFile file) {
    // 僅在非Web平台上初始化 VideoPlayerController
    if (!kIsWeb) {
      VideoPlayerController controller = VideoPlayerController.file(File(file.path))
        ..initialize().then((_) {
          logger.i('Video initialized successfully.');
          setState(() {});
        }).catchError((error) {
          logger.e('Video initialization error: $error');
        });
      _videoControllers[file.path] = controller;
    } else {
      // 對於Web平台，你可以選擇不做任何事，或者實現一個替代的預覽機制
      logger.i('Skipping video initialization on web platform.');
    }
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
    bool hasVideo = _mediaFiles.any((file) => MediaUtils.isVideoFile(file.path));
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