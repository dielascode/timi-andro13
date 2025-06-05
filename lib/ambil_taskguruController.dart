import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Task {
  final String className;
  final String taskName;

  Task({required this.className, required this.taskName});

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      className: json['class_name'],
      taskName: json['task_name'],
    );
  }
}


class TaskController extends GetxController {
  var tasks = <Task>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    try {
      isLoading(true);
      final response = await http.get(Uri.parse('YOUR_API_ENDPOINT'));

      if (response.statusCode == 200) {
        var taskList = json.decode(response.body) as List;
        tasks.value = taskList.map((task) => Task.fromJson(task)).toList();
      } else {
        // Handle error
      }
    } finally {
      isLoading(false);
    }
  }
}
