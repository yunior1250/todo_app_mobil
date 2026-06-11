
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/core/providers/core_providers.dart';
import 'package:todo_app/core/storage/token_storage.dart';
import 'package:todo_app/core/network/dio_client.dart';

void main() {
  test('tokenStorageProvider entrega un TokenStorage', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final ts = container.read(tokenStorageProvider);
    expect(ts, isA<TokenStorage>());
  });

  test('dioClientProvider arma un DioClient con la baseUrl correcta', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final client = container.read(dioClientProvider);
    expect(client, isA<DioClient>());
    expect(client.dio.options.baseUrl, 'http://192.168.100.7:8000/api');
  });

  test('un Provider cachea: pedirlo dos veces da la MISMA instancia', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final primera = container.read(tokenStorageProvider);
    final segunda = container.read(tokenStorageProvider);
    expect(identical(primera, segunda), true);
  });
}