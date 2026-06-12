import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../data/task_repository.dart';
import '../domain/task.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return TaskRepository(dioClient);
});

class TasksController extends StateNotifier<AsyncValue<List<Task>>> {
  final TaskRepository _repository;

  TasksController(this._repository) : super(const AsyncValue.loading()) {
    loadTasks();
  }

  Future<void> loadTasks() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repository.getTasks());
  }

  Future<void> createTask(String title, {String? description}) async {
    await _repository.createTasks(title, description: description);
    await loadTasks();
  }

  Future<void> toggleCompleted(int id, bool isCompleted) async {
    await _repository.updateCompleted(id, isCompleted);
    await loadTasks();
  }

  Future<void> editTask(int id, String title, {String? description}) async {
    await _repository.updateTask(id, title, description: description);
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    await _repository.deleteTask(id);
    await loadTasks();
  }

  void removeTaskLocal(int id) {
    final tareas = state.value;
    if (tareas == null) return;
    state = AsyncData(tareas.where((t) => t.id != id).toList());
  }
}

final tasksControllerProvider =
    StateNotifierProvider<TasksController, AsyncValue<List<Task>>>((ref) {
      final repository = ref.watch(taskRepositoryProvider);
      return TasksController(repository);
    });
