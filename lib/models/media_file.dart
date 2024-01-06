class MediaFile {
  String id;
  String url; // 假设每个媒体文件都有一个可访问的 URL

  MediaFile({required this.id, required this.url});

  factory MediaFile.fromJson(Map<String, dynamic> json) {
    return MediaFile(
      id: json['id'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}
