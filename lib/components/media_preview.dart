import 'dart:io';

/// This file contains the MediaPreview class, which is responsible for previewing and managing media files such as images and videos in the app.
///

/// This file contains the MediaPreview class, which is responsible for previewing and managing media files such as images and videos in the app.
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:logger/logger.dart';

final Logger logger = Logger();

class MediaPreview extends StatefulWidget {
  /// Widget for previewing and managing media files such as images and videos.
  ///
  /// The [mediaFiles] parameter is a list of XFile objects representing the media files to be previewed.
  /// The [onRemove] parameter is a function that specifies the action to be taken when a media file is removed.
  final List<XFile> mediaFiles;
  final Function(XFile file) onRemove;

  const MediaPreview({
    Key? key,
    required this.mediaFiles,
    required this.onRemove,
  }) : super(key: key);

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
  /// Builds the widget for displaying the media files.
  ///
  /// Returns a Wrap widget containing the preview of the media files.
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: widget.mediaFiles.map((file) {
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

  /// Checks if the specified path is a video file.
  ///
  /// Returns true if the path ends with '.mp4' or '.mov'; otherwise, returns false.
    return path.toLowerCase().endsWith('.mp4') || path.toLowerCase().endsWith('.mov');
  }

  /// Builds the widget for previewing a video file.
  ///
  /// The [file] parameter is the XFile object representing the video file to be previewed.
  /// Returns a Stack widget with a video player and a remove button.
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