import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/ai_insights/presentation/screens/ai_chat_screen.dart';
import '../../features/journal/presentation/screens/journal_screen.dart';
import '../../features/vitals/presentation/screens/vitals_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/reminders/presentation/screens/reminders_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../widgets/main_shell.dart';

/// Route names
class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main routes
  static const String dashboard = '/dashboard';
  static const String vitals = '/vitals';
  static const String aiChat = '/ai-chat';
  static const String journal = '/journal';
  static const String reminders = '/reminders';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

/// Navigation shell key
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.onboarding,
    debugLogDiagnostics: true,
    routes: [
      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // Auth routes
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app shell with bottom navigation
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            name: 'dashboard',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: DashboardScreen()),
          ),
          GoRoute(
            path: AppRoutes.vitals,
            name: 'vitals',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: VitalsScreen()),
          ),
          GoRoute(
            path: AppRoutes.aiChat,
            name: 'ai-chat',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: AiChatScreen()),
          ),
          GoRoute(
            path: AppRoutes.journal,
            name: 'journal',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: JournalScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            name: 'profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),

      // Standalone routes
      GoRoute(
        path: AppRoutes.reminders,
        name: 'reminders',
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.uri.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.dashboard),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
