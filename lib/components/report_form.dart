import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/traffic_violation.dart';

'''
  A class for building a form for reporting traffic violations.

  Properties:
    - formKey: GlobalKey\<FormState>, the key for the form
    - violation: TrafficViolation, the traffic violation
    - dateController: TextEditingController, the text editing controller for the date
    - timeController: TextEditingController, the text editing controller for the time
    - violations: List\<String>, the list of violations
    - onDateSaved: Function(DateTime?), function for saving the date
    - onTimeSaved: Function(TimeOfDay?), function for saving the time
    - onLicensePlateSaved: Function(String?), function for saving the license plate
    - onLocationSaved: Function(String?), function for saving the location
    - onOfficerSaved: Function(String?), function for saving the officer
    - onStatusChanged: Function(String?), function for changing the status
'''
class ReportForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TrafficViolation violation;
  final TextEditingController dateController;
  final TextEditingController timeController;
  final List<String> violations;
  final Function(DateTime?) onDateSaved;
  final Function(TimeOfDay?) onTimeSaved;
  final Function(String?) onLicensePlateSaved;
  final Function(String?) onLocationSaved;
  final Function(String?) onOfficerSaved;
  final Function(String?) onStatusChanged;

  const ReportForm({
    Key? key,
    required this.formKey,
    required this.violation,
    required this.dateController,
    required this.timeController,
    required this.violations,
    required this.onDateSaved,
    required this.onTimeSaved,
    required this.onLicensePlateSaved,
    required this.onLocationSaved,
    required this.onOfficerSaved,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'License Plate'),
              onSaved: onLicensePlateSaved,
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
              controller: dateController,
              onTap: () => _selectDate(context),
            ),
            // Time Picker
            TextFormField(
              decoration: const InputDecoration(labelText: 'Time'),
              readOnly: true,
              controller: timeController,
              onTap: () => _selectTime(context),
            ),
            // Violation Dropdown
            DropdownButtonFormField<String>(
              value: violation.violation,
              decoration: const InputDecoration(labelText: 'Violation'),
              items: violations.map((String violation) {
                return DropdownMenuItem<String>(
                  value: violation,
                  child: Text(violation),
                );
              }).toList(),
              onChanged: (String? newValue) {
                violation.violation = newValue;
              },
              onSaved: (String? newValue) {
                violation.violation = newValue;
              },
            ),
            // Status Dropdown
            DropdownButtonFormField<String>(
              value: violation.status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: TrafficViolation.statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: onStatusChanged,
            ),
            // Location Field
            TextFormField(
              decoration: const InputDecoration(labelText: 'Location'),
              onSaved: onLocationSaved,
            ),
            // Officer Field
            TextFormField(
              decoration: const InputDecoration(labelText: 'Officer'),
              onSaved: onOfficerSaved,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: violation.date!,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    onDateSaved(pickedDate);
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: violation.time!,
    );
    onTimeSaved(pickedTime);
  }
}