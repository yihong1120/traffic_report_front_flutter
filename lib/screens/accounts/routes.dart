import 'package:flutter/material.dart';
import 'account_page.dart';
import 'login.dart';
import 'verify_page.dart';
import 'register.dart';
import 'account_delete_confirm_page.dart';
import 'password_change_done_page.dart';
import 'password_change_page.dart';
import 'social_connections_page.dart';

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