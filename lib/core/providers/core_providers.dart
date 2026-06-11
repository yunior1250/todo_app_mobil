import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/token_storage.dart';
import '../network/dio_client.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final tokenStorage = ref.watch(tokenStorageProvider);
  return DioClient(tokenStorage);
});

final sessionTokenProvider = StateProvider<String?>((ref) => null);
