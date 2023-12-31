import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:logger/logger.dart';
import '../../utils/media_utils.dart';

final Logger logger = Logger();

class MediaPreview extends StatefulWidget {
  final List<XFile> mediaFiles;
  final Function(XFile file) onRemove;

  const MediaPreview({
    super.key,
    required this.mediaFiles,
    required this.onRemove,
  }); 

  @override
  State<MediaPreview> createState() => _MediaPreviewState();
}

class _MediaPreviewState extends State<MediaPreview> {
  final Map<String, VideoPlayerController> _videoControllers = {};

  @override
  void dispose() {
    _videoControllers.forEach((_, controller) => controller.dispose());
    _videoControllers.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.mediaFiles.map((file) {
        if (MediaUtils.isVideoFile(file.path)) {
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
      controller = VideoPlayerController.file(File(file.path))
        ..initialize().then((_) {
          logger.i('Video initialized successfully.');
          if (mounted) setState(() {});
        }).catchError((error) {
          logger.e('Video initialization error: $error');
        });
      _videoControllers[file.path] = controller;
    }
    return Stack(
      alignment: Alignment.topRight,
      children: <Widget>[
        VideoPlayer(controller),
        IconButton(
          icon: const Icon(Icons.remove_circle),
          onPressed: () {
            widget.onRemove(file);
            controller?.dispose();
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
                onPressed: () => widget.onRemove(file),
              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}