import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../data/auth_repository.dart';
import 'auth_state.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final tokenStorage = ref.watch(tokenStorageProvider);
  return AuthRepository(dioClient, tokenStorage);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final Ref _ref;

  AuthController(this._repository , this._ref) : super(const AuthState.initial());

  Future<void> login(String email, String password) async {
    state = const AuthState(isLoading: true);
    try {
      final name = await _repository.login(email, password);
      final token = await _ref.read(tokenStorageProvider).readToken();
      _ref.read(sessionTokenProvider.notifier).state = token;
      state = AuthState(isLoading: false, isLoggedIn: true, userName: name);
    } catch (e) {
      state = AuthState(isLoading: false, errorMessage: _mensajeError(e));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    _ref.read(sessionTokenProvider.notifier).state = null;
    state = const AuthState.initial();
  }

  String _mensajeError(Object e) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'] as String;
      }
    }
    return 'no se pudo iniciar sesion';
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    return AuthController(repository,ref);
  },
);
final userNameProvider = FutureProvider<String>((ref) async {
  final tokenStorage = ref.watch(tokenStorageProvider);
  final name = await tokenStorage.readName();
  return name ?? '';
});