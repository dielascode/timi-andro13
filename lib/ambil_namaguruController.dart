import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NamaGuru extends GetxController {
  var dataList = [].obs;
  late int idGuru;

  fetchData() async {
    try {
      print("Fetching data for Guru ID: $idGuru"); // Debugging ID Guru
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/guru?id=$idGuru"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        dataList.value = json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception(
            'Failed to load teacher with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching teacher: $e");
      throw Exception('Error fetching teacher: $e');
    }
  }

  editData({
    required String nama,
    required String kodeMengajar,
    required String email,
    required String nomorTelepon,
  }) async {
    try {
      print("Editing data for Guru ID: $idGuru"); // Debugging ID Siswa
      final response = await http.put(
        Uri.parse("http://127.0.0.1:8000/api/guru/$idGuru"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'nama': nama,
          'kode': kodeMengajar,
          'email': email,
          'notlp': nomorTelepon,
        }),
      );
      if (response.statusCode == 200) {
        print('teacher data updated successfully');
        // Optionally, you can refetch data after editing
        fetchData();
      } else {
        throw Exception(
            'Failed to update teacher data with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error editing teacher data: $e");
      throw Exception('Error editing teacher data: $e');
    }
  }
}

// by hifny agar data lebih cepet
// class HomeController extends GetxController {
//   var dataList = <Map<String, dynamic>>[].obs;
//   var isLoading = true.obs;

//   @override
//   void onInit() {
//     fetchData();
//     super.onInit();
//   }

//   void fetchData() async {
//     try {
//       isLoading(true);
//       // Simulasi pengambilan data
//       await Future.delayed(Duration(seconds: 2));
//       // Tambahkan data yang diambil ke dataList
//       dataList.value = [
//         {'class_name': 'Matematika'},
//         {'class_name': 'Bahasa Inggris'},
//         // Data lainnya
//       ];
//     } finally {
//       isLoading(false);
//     }
//   }
// }
