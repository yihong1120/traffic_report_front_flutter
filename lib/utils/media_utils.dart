class MediaUtils {
  static bool isVideoFile(String path) {
    return path.toLowerCase().endsWith('.mp4') || path.toLowerCase().endsWith('.mov');
  }
}
