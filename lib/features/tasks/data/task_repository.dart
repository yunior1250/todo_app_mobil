import '../../../core/network/dio_client.dart';
import '../domain/task.dart';

class TaskRepository {
  final DioClient _dioClient;

  TaskRepository(this._dioClient);

  Future<List<Task>> getTasks() async {
    final response = await _dioClient.dio.get('/tasks');
    final data = response.data as Map<String, dynamic>;
    final lista = data['data'] as List<dynamic>;

    return lista
        .map((json) => Task.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> createTasks(String title, {String? description}) async {
    await _dioClient.dio.post(
      '/tasks',
      data: {
        'title': title,
        if (description != null && description.isNotEmpty)
          'description': description,
      },
    );
  }

  Future<void> updateCompleted(int id, bool isCompleted) async {
    await _dioClient.dio.put('/tasks/$id', data: {'is_completed': isCompleted});
  }

  Future<void> updateTask(int id, String title, {String? description}) async {
    await _dioClient.dio.put(
      '/tasks/$id',
      data: {
        'title': title,
        'description': (description != null && description.isNotEmpty)
            ? description
            : null,
      },
    );
  }

  Future<void> deleteTask(int id) async {
    await _dioClient.dio.delete('/tasks/$id');
  }
}
