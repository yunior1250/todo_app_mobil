import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/tasks_controller.dart';
import '../domain/task.dart';
import '../../auth/application/auth_controller.dart';

class TasksScreen extends ConsumerWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksState = ref.watch(tasksControllerProvider);
    final userNameAsync = ref.watch(userNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          userNameAsync.maybeWhen(
            data: (name) => 'Tareas de $name',
            orElse: () => 'Tareas',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _logout(context, ref),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoCrear(context, ref),
        child: const Icon(Icons.add),
      ),
      body: tasksState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(error.toString().replaceFirst('Exception', '')),
        ),
        data: (tasks) {
          if (tasks.isEmpty) {
            return const Center(child: Text('No hay tareas disponibles'));
          }
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Dismissible(
                key: ValueKey(task.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _borrarTarea(context, ref, task),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: ListTile(
                  onTap: () => _alternarCompletada(context, ref, task),
                  leading: Icon(
                    task.isCompleted
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: task.isCompleted ? Colors.green : null,
                  ),
                  title: Text(task.title),
                  subtitle: task.description != null
                      ? Text(task.description!)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(authControllerProvider.notifier).logout();
    } catch (_) {}
    if (!context.mounted) return;
    context.go('/login');
  }

  Future<void> _alternarCompletada(
      BuildContext context,
      WidgetRef ref,
      Task task,
      ) async {
    try {
      await ref
          .read(tasksControllerProvider.notifier)
          .toggleCompleted(task.id, !task.isCompleted);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception', ''))),
      );
    }
  }

  Future<void> _borrarTarea(
      BuildContext context,
      WidgetRef ref,
      Task task,
      ) async {
    try {
      await ref.read(tasksControllerProvider.notifier).deleteTask(task.id);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception', ''))),
      );
    }
  }

  Future<void> _mostrarDialogoCrear(BuildContext context, WidgetRef ref) async
  {
    final tituloController = TextEditingController();
    final descController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogoContext) {
        return AlertDialog(
          title: const Text('Nueva tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: const InputDecoration(labelText: 'Titulo'),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(
                  labelText: 'Descripcion (opcional)',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogoContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final titulo = tituloController.text.trim();
                if (titulo.isEmpty) return;
                try {
                  await ref
                      .read(tasksControllerProvider.notifier)
                      .createTask(
                    titulo,
                    description: descController.text.trim(),
                  );
                  if (!dialogoContext.mounted) return;
                  Navigator.pop(dialogoContext);
                } catch (e) {
                  if (!dialogoContext.mounted) return;
                  ScaffoldMessenger.of(dialogoContext).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceFirst('Exception', ' '),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}