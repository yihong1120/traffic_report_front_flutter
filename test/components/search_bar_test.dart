import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:traffic_report_front_flutter/components/search_bar.dart';

void main() {
  testWidgets('onChanged callback is called when text changes', (WidgetTester tester) async {
    String searchText = '';
    void handleSearch(String keyword) {
      searchText = keyword;
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchBar(
            onSearch: handleSearch,
          ),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'example text');
    expect(searchText, 'example text');
  });

  testWidgets('onPressed callback is called when IconButton is pressed', (WidgetTester tester) async {
    bool onPressedCalled = false;
    void handleSearch(String keyword) {
      onPressedCalled = true;
    }

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SearchBar(
            onSearch: handleSearch,
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.search));
    expect(onPressedCalled, true);
  });
}
