import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../models/traffic_violation.dart';

var logger = Logger();

class ReportService {
  final String apiUrl = 'http://127.0.0.1:8000/reports/';

  Future<bool> createReport(TrafficViolation violation, List<XFile> mediaFiles) async {
    try {
      var reportJson = violation.toJson();

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      reportJson.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      for (var file in mediaFiles) {
        var multipartFile = await http.MultipartFile.fromPath('media', file.path);
        request.files.add(multipartFile);
      }

      var response = await request.send();

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

  Future<List<TrafficViolation>> getReports({int page = 1}) async {
    var response = await http.get(Uri.parse('$apiUrl?page=$page'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => TrafficViolation.fromJson(json)).toList();
    } else {
      logger.d('Failed to fetch reports: ${response.statusCode}');
      return [];
    }
  }

  // 獲取特定違規報告的方法
  Future<TrafficViolation> getViolation(int recordId) async {
    var response = await http.get(Uri.parse('$apiUrl$recordId/'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return TrafficViolation.fromJson(data);
    } else {
      logger.d('Failed to fetch violation: ${response.statusCode}');
      throw Exception('Failed to fetch violation');
    }
  }

  // 更新報告的方法
  Future<bool> updateReport(TrafficViolation violation, List<XFile> mediaFiles) async {
    try {
      var reportJson = violation.toJson();

      // 假設後端 API 需要 PUT 請求來更新報告
      var request = http.MultipartRequest('PUT', Uri.parse('$apiUrl${violation.id}/'));
      reportJson.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      for (var file in mediaFiles) {
        var multipartFile = await http.MultipartFile.fromPath('media', file.path);
        request.files.add(multipartFile);
      }

      var response = await request.send();

      if (response.statusCode == 200) {
        return true;
      } else {
        logger.d('Failed to update report: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      logger.d('Caught error: $e');
      return false;
    }
  }
}