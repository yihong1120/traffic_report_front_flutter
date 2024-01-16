import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:traffic_report_front_flutter/services/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Create a mock class for FlutterSecureStorage
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('AuthService', () {
    // Create a mock instance of FlutterSecureStorage
    final mockStorage = MockFlutterSecureStorage();

    // Set up dotenv for environment variables
    setUp(() async {
      await dotenv.load(fileName: ".env");

      // Inject the mock FlutterSecureStorage instance into AuthService
      AuthService.storage = mockStorage;
    });

    test('login returns true on valid credentials', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('{"auth_token": "token123"}', 200);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result = await AuthService.login('username', 'password');

      // Assert
      expect(result, true);
    });

    test('login returns false on invalid credentials', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result = await AuthService.login('username', 'wrongpassword');

      // Assert
      expect(result, false);
    });

    test('register returns true on successful registration', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('Created', 201);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result = await AuthService.register(
          'username', 'email@example.com', 'password', 'password');

      // Assert
      expect(result, true);
    });

    test('register returns false on failed registration', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('Bad Request', 400);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result = await AuthService.register(
          'username', 'email@example.com', 'password', 'password');

      // Assert
      expect(result, false);
    });

    test('verifyEmail returns true on successful verification', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('OK', 200);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result = await AuthService.verifyEmail('verification_code');

      // Assert
      expect(result, true);
    });

    test('verifyEmail returns false on failed verification', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('Bad Request', 400);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result = await AuthService.verifyEmail('invalid_code');

      // Assert
      expect(result, false);
    });

    test('changePassword returns true on successful password change', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('OK', 200);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result =
          await AuthService.changePassword('old_password', 'new_password');

      // Assert
      expect(result, true);
    });

    test('changePassword returns false on failed password change', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('Unauthorized', 401);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result = await AuthService.changePassword(
          'old_password', 'wrong_new_password');

      // Assert
      expect(result, false);
    });

    test('changeEmail returns true on successful email change', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('OK', 200);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result = await AuthService.changeEmail('new_email@example.com');

      // Assert
      expect(result, true);
    });

    test('changeEmail returns false on failed email change', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('Bad Request', 400);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result = await AuthService.changeEmail('invalid_email@example.com');

      // Assert
      expect(result, false);
    });

    test('deleteAccount returns true on successful account deletion', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('OK', 200);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result = await AuthService.deleteAccount();

      // Assert
      expect(result, true);
    });

    test('deleteAccount returns false on failed account deletion', () async {
      // Arrange
      final client = MockClient((request) async {
        return http.Response('Not Found', 404);
      });
      AuthService.client = client; // Replace http client with mock client

      // Act
      final result = await AuthService.deleteAccount();

      // Assert
      expect(result, false);
    });

    tearDown(() {
      // Reset the AuthService.client to the default HTTP client
      AuthService.client = http.Client();
      // Clear interactions on the mock object
      reset(mockStorage);
    });
  });

  // The tests for isLoggedIn should be inside the group block
  group('isLoggedIn', () {
    // Create a mock instance of FlutterSecureStorage
    final mockStorage = MockFlutterSecureStorage();

    setUp(() {
      // Inject the mock FlutterSecureStorage instance into AuthService
      AuthService.storage = mockStorage;
    });

    test('isLoggedIn returns true when there is a token', () async {
      // Arrange
      when(mockStorage.read(key: 'token')).thenAnswer((_) async => 'token123');

      // Act
      final result = await AuthService.isLoggedIn();

      // Assert
      expect(result, true);
    });

    test('isLoggedIn returns false when there is no token', () async {
      // Arrange
      when(mockStorage.read(key: 'token')).thenAnswer((_) async => null);

      // Act
      final result = await AuthService.isLoggedIn();

      // Assert
      expect(result, false);
    });

    tearDown(() {
      // Clear interactions on the mock object
      reset(mockStorage);
    });
  });
}
