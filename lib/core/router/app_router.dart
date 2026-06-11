import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/core_providers.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/tasks',
    redirect: (context, state) {
      final loggedIn = ref.read(sessionTokenProvider) != null;
      final enLogin = state.matchedLocation == '/login';

      if (!loggedIn && !enLogin) return '/login';
      if (loggedIn && enLogin) return '/tasks';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/tasks',
        builder: (context, state) => const TasksScreen(),
      ),
    ],
  );
});