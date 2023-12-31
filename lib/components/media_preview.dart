import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaPreview extends StatelessWidget {
  final List<XFile> mediaFiles;
  final Function(XFile) onRemove;

  const MediaPreview({Key? key, required this.mediaFiles, required this.onRemove}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: mediaFiles.map((file) {
        return Stack(
          alignment: Alignment.topRight,
          children: <Widget>[
            // TODO: Display image or video preview
            // For example:
            // Image.file(File(file.path), width: 100, height: 100),
            IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: () => onRemove(file),
            ),
          ],
        );
      }).toList(),
    );
  }
}