import 'package:flutetr_demo/Getx/DatabaseHelper.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class TodoGetX extends GetxController {
  var title = ''.obs;
  var dueDate = Rx<DateTime?>(null);
  var description = ''.obs;
  var addData = true.obs;

  var email = ''.obs;

  var password = ''.obs;

  TodoProvider todoProvider = Get.put(TodoProvider());

  Future<void> addTodo() async {
    if (title.value.isEmpty || description.value.isEmpty) {
      print("Title and Description cannot be empty");
      return; // Exit if values are not valid
    }

    Todo todo = Todo(
      title: title.value,
      createAt: DateTime.now(),
      description: description.value,
      dueDate: dueDate.value,
    );

    final data = await todoProvider.insert(todo);
    if (data != null) {
      print("Todo added: $data");
    } else {
      print("Failed to add Todo");
    }
  }

  Future<void> updateTodo(int id) async {
    Todo todo = Todo(
      title: title.value,
      createAt: DateTime.now(),
      description: description.value,
      dueDate: dueDate.value,
    );
    final data = await todoProvider.updateTuDo(todo, id);
    if (data > 0) {
      print("update ok");
    }
  }

  Future<bool> login() async {
    final data = await todoProvider.login(email.value, password.value);
    if (data) {
      return true;
    } else {
      return false;
    }
  }
}
