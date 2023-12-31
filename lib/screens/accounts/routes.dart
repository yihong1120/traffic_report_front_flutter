// This file defines the routes for the accounts screens in the Traffic Report System app.
import 'package:flutter/material.dart';
import 'account_page.dart';
import 'login.dart';
import 'verify_page.dart';
import 'register.dart';
import 'account_delete_confirm_page.dart';
import 'password_change_done_page.dart';
import 'password_change_page.dart';
import 'social_connections_page.dart';

// This is a map of routes for the accounts screens. Each key is a string representing a route,
// and each value is a function that takes a BuildContext and returns a Widget representing
// the screen for that route.
Map<String, WidgetBuilder> accountsRoutes = {
    '/login': (context) => const LoginPage(),
    '/accounts': (context) => const AccountPage(),
    '/register': (context) => const RegisterPage(),
    '/verify': (context) => const VerifyPage(),
    '/account-delete-confirm': (context) => const AccountDeleteConfirmPage(),
    '/password-change': (context) => const PasswordChangePage(),
    '/password-change-done': (context) => const PasswordChangeDonePage(),
    '/social-connections': (context) => const SocialConnectionsPage(),
};