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

 final Logger logger = Logger();

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  CreateReportPageState createState() => CreateReportPageState();
}

class CreateReportPageState extends State<CreateReportPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final List<XFile> _mediaFiles = [];
  final TrafficViolation _violation = TrafficViolation(
    date: DateTime.now(),
    time: TimeOfDay.now(),
    violation: '紅線停車',
    status: 'Pending',
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
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'License Plate'),
                  onSaved: (value) => _violation.licensePlate = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a license plate';
                    }
                    return null;
                  },
                ),
                // Date Picker
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Date'),
                  readOnly: true,
                  controller: _dateController,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _violation.date!,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
  bool _checkSelectedMediaFiles(List<XFile>? pickedFiles) {
    if (pickedFiles == null || pickedFiles.isEmpty) return false;
    if (pickedFiles.length > 5) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only select up to 5 media files.')),
        );
      }
      return false;
    }
    return true;
  }

  bool _checkMediaFileSize(XFile file) async {
    final fileLength = await File(file.path).length();
    if (fileLength > 100 * 1024 * 1024) { // 100MB
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Each file must be less than 100MB')),
        );
      }
      return false;
    }
    return true;
  }
  bool _checkSelectedMediaFiles(List<XFile>? pickedFiles) {
    if (pickedFiles == null || pickedFiles.isEmpty) return false;
    if (pickedFiles.length > 5) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only select up to 5 media files.')),
        );
      }
      return false;
    }
    return true;
  }

  bool _checkMediaFileSize(XFile file) async {
    final fileLength = await File(file.path).length();
    if (fileLength > 100 * 1024 * 1024) { // 100MB
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Each file must be less than 100MB')),
        );
      }
      return false;
    }
    return true;
  }
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _violation.date = pickedDate;
                        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                ),
                // Time Picker
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Time'),
                  readOnly: true,
                  controller: _timeController,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _violation.time!,
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _violation.time = pickedTime;
                        _timeController.text = pickedTime.format(context);
                      });
                    }
                  },
                ),
                // Violation Dropdown
                DropdownButtonFormField<String>(
                  value: _violation.violation,
                  decoration: const InputDecoration(labelText: 'Violation'),
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
                ), // 添加了这个闭合括号来结束 DropdownButtonFormField
                // Status Dropdown
                DropdownButtonFormField<String>(
                    value: _violation.status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: TrafficViolation.statusOptions.map((status) {
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
                    decoration: const InputDecoration(labelText: 'Location'),
                    onSaved: (value) => _violation.location = value,
                ),
                // Officer Field
                TextFormField(
                    decoration: const InputDecoration(labelText: 'Officer'),
                    onSaved: (value) => _violation.officer = value,
                ),
                // Media Upload
                ElevatedButton(
                    onPressed: () => _pickMedia(),
                    child: const Text('Add Media'),
                ),
                const SizedBox(height: 10),
                _buildMediaPreview(),
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
        ),
      ),
    );
  }

  void _pickMedia() async {
    final List<XFile>? pickedFiles = await MediaPicker.pickMedia(context, enableCamera: true);
    if (!_checkSelectedMediaFiles(pickedFiles)) return;
    List<XFile> validFiles = pickedFiles.where((file) => _checkMediaFileSize(file)).toList();
  bool _checkSelectedMediaFiles(List<XFile>? pickedFiles) {
    if (pickedFiles == null || pickedFiles.isEmpty) return false;
    if (pickedFiles.length > 5) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You can only select up to 5 media files.')),
        );
      }
      return false;
    }
    return true;
  }
    if (!_checkSelectedMediaFiles(pickedFiles)) return;

    List<XFile> validFiles = pickedFiles.where((file) => _checkMediaFileSize(file)).toList();
    
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
  bool _checkMediaFileSize(XFile file) async {
    final fileLength = await File(file.path).length();
    if (fileLength > 100 * 1024 * 1024) { // 100MB
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Each file must be less than 100MB')),
        );
      }
      return false;
    }
    return true;
  }
    _videoControllers[file.path] = controller;
  }

  bool _isVideoFile(String path) {
    return path.toLowerCase().endsWith('.mp4') || path.toLowerCase().endsWith('.mov');
  }

  Widget _buildMediaPreview() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _mediaFiles.map((file) {
        if (_isVideoFile(file.path)) {
          // 处理视频文件
          return _buildVideoPreview(file);
        } else {
          // 处理图像文件
          return _buildImagePreview(file);
        }
      }).toList(),
    );
  }

  Widget _buildVideoPreview(XFile file) {
    var controller = _videoControllers[file.path];
    if (controller == null || !controller.value.isInitialized) {
      return const CircularProgressIndicator();  // 或者其他占位符
    }
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        VideoPlayer(controller),
        IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: () {
            _removeMedia(file);
            controller.dispose();
            _videoControllers.remove(file.path);
          },
        ),
      ],
    );
  }

  Widget _buildImagePreview(XFile file) {
    return FutureBuilder<Uint8List>(
      future: file.readAsBytes(),
      builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          Uint8List fileData = snapshot.data!;
          return Stack(
            alignment: Alignment.topRight,
            children: <Widget>[
              Image.memory(fileData, width: 100, height: 100),
              IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () => _removeMedia(file),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  void _removeMedia(XFile file) {
    setState(() {
      _mediaFiles.remove(file);
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