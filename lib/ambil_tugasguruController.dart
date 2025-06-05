import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TugasGuru extends GetxController {
  var dataList = <Map<String, dynamic>>[].obs;
  var dataMapel = <Map<String, dynamic>>[].obs;
  var groupedDataList = {}.obs; // New map to group tasks by subjects
  late int IDGURU;
  var kelasId = 0.obs;

  void setKelasId(int id) {
    kelasId.value = id;
    fetchData();
    fetchMapel();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://127.0.0.1:8000/api/tugas?id_guru=$IDGURU&id_kelas=${kelasId.value}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        dataList.value =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        _groupTasksByMapel(); // Call the method to group tasks after fetching
      } else {
        throw Exception(
            'Failed to load tasks with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching tasks: $e");
      dataList.value = [];
    }
  }

  void _groupTasksByMapel() {
    groupedDataList.clear();
    for (var tugas in dataList) {
      if (!groupedDataList.containsKey(tugas['id_mapel'])) {
        groupedDataList[tugas['id_mapel']] = {
          'nama_mapel': tugas['nama_mapel'],
          'tasks': [],
        };
      }
      groupedDataList[tugas['id_mapel']]['tasks'].add(tugas);
    }
  }

  Future<void> fetchMapel() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://127.0.0.1:8000/api/mapel?id_guru=$IDGURU&id_kelas=${kelasId.value}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        dataMapel.value =
            List<Map<String, dynamic>>.from(json.decode(response.body));
        print('$dataMapel');
      } else {
        throw Exception(
            'Failed to load mapel with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching mapel: $e");
      dataMapel.value = []; // Clear the list in case of error
    }
  }

  Future<void> addTask(int mapelId, String tugas, String tanggal) async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/tugas"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id_kelas': kelasId.value,
          'id_guru': IDGURU,
          'id_mapel': mapelId,
          'tanggal': tanggal,
          'tugas': tugas,
          'tenggat': tanggal,
        }),
      );
      if (response.statusCode == 200) {
        fetchData(); // Refresh the task list after adding new task
      } else {
        throw Exception(
            'Failed to add task with status code: ${response.statusCode}, ${IDGURU}, ${kelasId.value}, ${mapelId}');
      }
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  Future<void> updateTask(
      int taskId, int mapelId, String tugas, String tanggal) async {
    try {
      final response = await http.put(
        Uri.parse("http://127.0.0.1:8000/api/tugas/$taskId"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id_kelas': kelasId.value,
          'id_guru': IDGURU,
          'id_mapel': mapelId,
          'tanggal': tanggal,
          'tugas': tugas,
          'tenggat': tanggal,
        }),
      );
      if (response.statusCode == 200) {
        fetchData(); // Refresh the task list after updating the task
      } else {
        throw Exception(
            'Failed to update task with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error updating task: $e");
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      // Delete related submissions first
      final responsePengumpulan = await http.delete(
        Uri.parse("http://127.0.0.1:8000/api/pengumpulan/byTask/$taskId"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (responsePengumpulan.statusCode != 200) {
        throw Exception('Failed to delete submissions with status code: ${responsePengumpulan.statusCode}');
      }

      // Delete the task itself
      final responseTugas = await http.delete(
        Uri.parse("http://127.0.0.1:8000/api/tugas/$taskId"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (responseTugas.statusCode == 200) {
        fetchData(); // Refresh the task list after deleting the task
      } else {
        throw Exception('Failed to delete task with status code: ${responseTugas.statusCode}');
      }
    } catch (e) {
      print("Error deleting task: $e");
    }
  }
}
