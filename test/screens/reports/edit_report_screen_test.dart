import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:traffic_report_front_flutter/screens/reports/edit_report_screen.dart';

class MockReportService extends Mock implements ReportService {}

void main() {
  group('EditReportPageState', () {
    late EditReportPageState editReportPageState;
    late MockReportService mockReportService;

    setUp(() {
      mockReportService = MockReportService();
      editReportPageState = EditReportPageState();
      editReportPageState.reportService = mockReportService;
    });

    test('_loadViolation should retrieve the violation record and update the state', () async {
      // Mock violation record
      final violation = TrafficViolation(
        id: 1,
        date: DateTime.now(),
        time: TimeOfDay.now(),
        licensePlate: 'ABC123',
        location: 'Location',
        officer: 'Officer',
        status: 'Status',
        mediaFiles: [],
      );

      // Mock violation ID
      final recordId = 1;

      // Mock ReportService
      when(mockReportService.getViolation(recordId)).thenAnswer((_) async => violation);

      // Call _loadViolation method
      await editReportPageState._loadViolation();

      // Verify that the violation record is retrieved
      verify(mockReportService.getViolation(recordId)).called(1);

      // Verify that the state is updated correctly
      expect(editReportPageState._violation, equals(violation));
      expect(editReportPageState._dateController.text, equals(DateFormat('yyyy-MM-dd').format(violation.date!)));
      expect(editReportPageState._timeController.text, equals(violation.time!.format(editReportPageState.context)));
      expect(editReportPageState._licensePlateController.text, equals(violation.licensePlate));
      expect(editReportPageState._locationController.text, equals(violation.location));
      expect(editReportPageState._officerController.text, equals(violation.officer));
      expect(editReportPageState._selectedStatus, equals(violation.status));
      expect(editReportPageState._remoteMediaFiles, equals(violation.mediaFiles));
    });

    test('_loadViolation should show a snackbar with an error message if an exception is thrown', () async {
      // Mock violation ID
      final recordId = 1;

      // Mock ReportService
      when(mockReportService.getViolation(recordId)).thenThrow(Exception('Failed to load report'));

      // Call _loadViolation method
      await editReportPageState._loadViolation();

      // Verify that a snackbar with an error message is shown
      verify(editReportPageState._showSnackBar('Failed to load report: Exception: Failed to load report')).called(1);
    });

    test('_submitReport should update the violation record and show a snackbar with a success message', () async {
      // Mock violation record
      final violation = TrafficViolation(
        id: 1,
        date: DateTime.now(),
        time: TimeOfDay.now(),
        licensePlate: 'ABC123',
        location: 'Location',
        officer: 'Officer',
        status: 'Status',
        mediaFiles: [],
      );

      // Mock ReportService
      when(mockReportService.updateReport(
        violation,
        localMediaFiles: anyNamed('localMediaFiles'),
        remoteMediaFiles: anyNamed('remoteMediaFiles'),
      )).thenAnswer((_) async => true);

      // Call _submitReport method
      await editReportPageState._submitReport();

      // Verify that the violation record is updated
      verify(mockReportService.updateReport(
        violation,
        localMediaFiles: anyNamed('localMediaFiles'),
        remoteMediaFiles: anyNamed('remoteMediaFiles'),
      )).called(1);

      // Verify that a snackbar with a success message is shown
      verify(editReportPageState._scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Report updated successfully')),
      )).called(1);

      // Verify that the navigator pops the page
      verify(editReportPageState._navigator.pop()).called(1);
    });

    test('_submitReport should show a snackbar with an error message if the report fails to update', () async {
      // Mock violation record
      final violation = TrafficViolation(
        id: 1,
        date: DateTime.now(),
        time: TimeOfDay.now(),
        licensePlate: 'ABC123',
        location: 'Location',
        officer: 'Officer',
        status: 'Status',
        mediaFiles: [],
      );

      // Mock ReportService
      when(mockReportService.updateReport(
        violation,
        localMediaFiles: anyNamed('localMediaFiles'),
        remoteMediaFiles: anyNamed('remoteMediaFiles'),
      )).thenAnswer((_) async => false);

      // Call _submitReport method
      await editReportPageState._submitReport();

      // Verify that the violation record is updated
      verify(mockReportService.updateReport(
        violation,
        localMediaFiles: anyNamed('localMediaFiles'),
        remoteMediaFiles: anyNamed('remoteMediaFiles'),
      )).called(1);

      // Verify that a snackbar with an error message is shown
      verify(editReportPageState._scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('Failed to update report')),
      )).called(1);
    });

    test('_submitReport should show a snackbar with an error message if an exception is thrown', () async {
      // Mock violation record
      final violation = TrafficViolation(
        id: 1,
        date: DateTime.now(),
        time: TimeOfDay.now(),
        licensePlate: 'ABC123',
        location: 'Location',
        officer: 'Officer',
        status: 'Status',
        mediaFiles: [],
      );

      // Mock ReportService
      when(mockReportService.updateReport(
        violation,
        localMediaFiles: anyNamed('localMediaFiles'),
        remoteMediaFiles: anyNamed('remoteMediaFiles'),
      )).thenThrow(Exception('An error occurred'));

      // Call _submitReport method
      await editReportPageState._submitReport();

      // Verify that the violation record is updated
      verify(mockReportService.updateReport(
        violation,
        localMediaFiles: anyNamed('localMediaFiles'),
        remoteMediaFiles: anyNamed('remoteMediaFiles'),
      )).called(1);

      // Verify that a snackbar with an error message is shown
      verify(editReportPageState._scaffoldMessenger.showSnackBar(
        SnackBar(content: Text('An error occurred: Exception: An error occurred')),
      )).called(1);
    });
  });
}
