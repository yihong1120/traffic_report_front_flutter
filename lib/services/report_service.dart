import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/traffic_violation.dart';

class ReportService {
  final String apiUrl = 'https://your-api-url.com/reports';

  /// Creates a report with the given [violation] and [mediaFiles].
  ///
  /// The [violation] parameter is a TrafficViolation object that represents the details of the violation.
  /// The [mediaFiles] parameter is a list of XFile objects that represent the media files associated with the report.
  ///
  /// Returns true if the report was created successfully, false otherwise.
  Future<bool> createReport(TrafficViolation violation, List<XFile> mediaFiles) async {
    try {
      // Convert the TrafficViolation object to JSON
      var reportJson = violation.toJson();

      // Create a multipart request to upload the report and media files
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
        ..fields.addAll(reportJson);

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
        print('Failed to create report: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Caught error: $e');
      return false;
    }
  }
}