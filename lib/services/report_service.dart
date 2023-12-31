import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../models/traffic_violation.dart';

var logger = Logger();

class ReportService {
  final String apiUrl = 'https://your-api-url.com/reports';

  Future<bool> createReport(TrafficViolation violation, List<XFile> mediaFiles) async {
    try {
      // Convert the TrafficViolation object to JSON
      var reportJson = violation.toJson();

      // Create a multipart request to upload the report and media files
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add fields to the request after converting values to String
      reportJson.forEach((key, value) {
        request.fields[key] = value.toString(); // 转换为字符串
      });

      // Add media files to the request
      for (var file in mediaFiles) {
        var multipartFile = await http.MultipartFile.fromPath(
          'media', // The field name for files in your API
          file.path,
        );
        request.files.add(multipartFile);
      }

      // Send the request
      var response = await request.send();

      // Check the response status
      if (response.statusCode == 200) {
        return true;
      } else {
        logger.d('Failed to create report: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      logger.d('Caught error: $e');
      return false;
    }
  }
}