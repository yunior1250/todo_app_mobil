import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/features/tasks/domain/task.dart';

void main() {
  test('fromJson parsea una tarea completa', () {
    final json = {
      'id': 1,
      'title': 'Comprar pan',
      'description': 'integral',
      'is_completed': false,
      'category_id': 2,
      'status': 'pending',
      'priority': 'medium',
      'due_date': '2026-06-10T08:00:00+00:00',
      'created_at': '2026-06-09T12:00:00+00:00',
      'updated_at': '2026-06-09T12:00:00+00:00',
    };

    final task = Task.fromJson(json);

    expect(task.id, 1);
    expect(task.title, 'Comprar pan');
    expect(task.description, 'integral');
    expect(task.isCompleted, false);
    expect(task.categoryId, 2);
    expect(task.status, 'pending');
    expect(task.priority, 'medium');
    expect(task.dueDate, DateTime.parse('2026-06-10T08:00:00+00:00'));
  });

  test('fromJson maneja los campos opcionales en null', () {
    final json = {
      'id': 5,
      'title': 'Tarea sin extras',
      'description': null,
      'is_completed': true,
      'category_id': null,
      'status': 'completed',
      'priority': 'low',
      'due_date': null,
      'created_at': '2026-06-09T12:00:00+00:00',
      'updated_at': '2026-06-09T12:00:00+00:00',
    };

    final task = Task.fromJson(json);

    expect(task.description, isNull);
    expect(task.categoryId, isNull);
    expect(task.dueDate, isNull);
  });

  test('copyWith cambia solo lo indicado y conserva el resto', () {
    final task = Task(
      id: 1,
      title: 'Original',
      isCompleted: false,
      categoryId: 3,
      status: 'pending',
      priority: 'medium',
      createdAt: DateTime.parse('2026-06-09T12:00:00+00:00'),
      updatedAt: DateTime.parse('2026-06-09T12:00:00+00:00'),
    );

    final copia = task.copyWith(isCompleted: true);

    expect(copia.isCompleted, true); // cambió
    expect(copia.title, 'Original'); // se conservó
    expect(copia.categoryId, 3); // se conservó (lo que arreglaste)
  });
}
