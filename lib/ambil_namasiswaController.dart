// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// class NamaSiswa extends GetxController {
//   var dataList = [].obs;
//   late int idSiswa;

//   fetchData() async {
//     try {
//       print("Fetching data  for Siswa ID: $idSiswa"); // Debugging ID Siswa
//       final response = await http.get(
//         Uri.parse("http://127.0.0.1:8000/api/siswa?id=$idSiswa"),
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//       );
//       if (response.statusCode == 200) {
//         dataList.value = json.decode(response.body) as List<dynamic>;
//       } else {
//         throw Exception('Failed to load student with status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print("Error fetching student: $e");
//       throw Exception('Error fetching student: $e');
//     }
//   }
// }

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class NamaSiswa extends GetxController {
  var dataList = [].obs;
  late int idSiswa;

  fetchData() async {
    try {
      print("Fetching data  for Siswa ID: $idSiswa"); // Debugging ID Siswa
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/siswa?id=$idSiswa"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        dataList.value = json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load student with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching student: $e");
      throw Exception('Error fetching student: $e');
    }
  }

  editData({
  required String nama,
  required String email,
  required String nisn,
  required String alamat,
  required String nomorTelepon,
  required String kelas,
  required String absen,
  required String password,
}) async {
  try {
    print("Editing data for Siswa ID: $idSiswa"); // Debugging ID Siswa
    final response = await http.put(
      Uri.parse("http://127.0.0.1:8000/api/siswa/$idSiswa"),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'nama': nama,
        'email': email, 
        'nisn': nisn, 
        'alamat': alamat,
        'notlp': nomorTelepon,
        'id_kelas': kelas,
        'absen': absen,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      print('Student data updated successfully');
      // Optionally, you can refetch data after editing
      fetchData();
    } else {
      throw Exception('Failed to update student data with status code: ${response.statusCode}');
    }
  } catch (e) {
    print("Error editing student data: $e");
    throw Exception('Error editing student data: $e');
  }
}

}
