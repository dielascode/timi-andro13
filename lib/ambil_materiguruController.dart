import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MateriGuruController extends GetxController {
  var dataList = [].obs;
  var isLoading = true.obs;
  late int IDGURU;
  var kelasId = 0.obs;

  void setKelasId(int idKelas) {
    kelasId.value = idKelas;
    fetchData(); // Panggil fungsi untuk mengambil data tugas untuk kelas
  }

  fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/materi?id_guru=$IDGURU&id_kelas=${kelasId.value}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        print("$kelasId");
        dataList.value = json.decode(response.body) as List;
      } else {
        throw Exception('Failed to load teacher with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching teacher: $e");
      // Anda dapat menangani kesalahan di sini, misalnya dengan mengatur dataList menjadi null
      dataList.value = [];
    }
  }
}
