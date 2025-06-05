import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProgresTugasGuruController extends GetxController {
  var dataList = <dynamic>[].obs;
  var isLoading = true.obs;

  Future<void> fetchPengumpulan(int idKelas, int idTugas, int idGuru) async {
    isLoading.value = true;
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/pengumpulan?id_kelas=$idKelas&id_tugas=$idTugas&id_guru=$idGuru'),
    );

    if (response.statusCode == 200) {
      dataList.value = json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }

    isLoading.value = false;
  }


   void updateNilai(int id, int idKelas, int idTugas, int idGuru, String nilai) async {
  try {
    var response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/pengumpulan/$id'), // Gunakan path parameter
      body: jsonEncode({
        'id_kelas': idKelas,
        'id_tugas': idTugas,
        'id_guru': idGuru,
        'nilai': nilai,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var updatedItem = dataList.firstWhere((element) => element['id'] == id);
      updatedItem['nilai'] = nilai;
      dataList.refresh();
    } else {
      Get.snackbar('Error', 'Gagal memperbarui nilai: ${response.body}');
    }
  } catch (e) {
    Get.snackbar('Error', 'Terjadi kesalahan saat memperbarui nilai: $e');
  }
}
}

