import '../../../core/network/dio_client.dart';
import '../../../core/storage/token_storage.dart';

class AuthRepository {
  final DioClient _dioClient;
  final TokenStorage _tokenStorage;

  AuthRepository(this._dioClient, this._tokenStorage);

  Future<String> login(String email, String password) async {
    final response = await _dioClient.dio.post(
      '/login',
      data: {'email': email, 'password': password},
    );
    final data = response.data as Map<String, dynamic>;
    final token = data['token'] as String;
    final name = data['user']['name'] as String;

    await _tokenStorage.save(token: token, name: name);
    return name;
  }
  Future<void> logout() async {
    await _dioClient.dio.post('/logout');
    await _tokenStorage.clear();
  }
}
