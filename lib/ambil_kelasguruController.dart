import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'ambil_tugasguruController.dart';

class KelasGuru extends GetxController {
  var dataList = <Map<String, dynamic>>[].obs;
  late int teacherId;
  final TugasGuru _TugasGuru = Get.put(TugasGuru());
  
  Future<String> _fetchClassName(int classId) async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/kelas?id=$classId'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);

        if (decodedResponse is List && decodedResponse.isNotEmpty) {
          final classData = decodedResponse.firstWhere((kelas) => kelas['id'] == classId, orElse: () => null);
          if (classData != null) {
            return classData['nama_kelas'];
          } else {
            throw Exception('Class with id $classId not found.');
          }
        } else {
          throw Exception('Unexpected data format.');
        }
      } else {
        throw Exception('Failed to load class name with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching class name: $e');
    }
  }

  fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/ruang?id_guru=$teacherId"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> classrooms = json.decode(response.body);
        final List<Map<String, dynamic>> classList = [];

        for (var classroom in classrooms) {
          final classId = classroom['id_kelas'];

          try {
            final className = await _fetchClassName(classId);
            classList.add({'class_name': className, 'id_kelas': classId});
            // _TugasGuru.setKelasId(classId);
          } catch (e) {
            print("Gagal mengambil nama kelas untuk ID kelas $classId: $e");
          }
        }

        dataList.assignAll(classList);
      } else {
        print("Gagal mengambil data dari API dengan status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Terjadi kesalahan saat mengambil data: $e");
    }
  }
}

// // edited by hifny

// import 'dart:convert';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'ambil_tugasguruController.dart';

// class KelasGuru extends GetxController {
//   var dataList = <Map<String, dynamic>>[].obs;
//   var isLoading = true.obs; // Digunakan untuk menampilkan loading indicator
//   late int teacherId;
//   final TugasGuru _TugasGuru = Get.put(TugasGuru());

//   @override
//   void onInit() {
//     fetchData(); // Panggil fetchData saat controller diinisialisasi
//     super.onInit();
//   }

//   Future<String> _fetchClassName(int classId) async {
//     try {
//       final response = await http.get(
//         Uri.parse('http://127.0.0.1:8000/api/kelas?id=$classId'),
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//       );

//       if (response.statusCode == 200) {
//         final decodedResponse = json.decode(response.body);

//         if (decodedResponse is List && decodedResponse.isNotEmpty) {
//           final classData = decodedResponse.firstWhere((kelas) => kelas['id'] == classId, orElse: () => null);
//           if (classData != null) {
//             return classData['nama_kelas'];
//           } else {
//             throw Exception('Class with id $classId not found.');
//           }
//         } else {
//           throw Exception('Unexpected data format.');
//         }
//       } else {
//         throw Exception('Failed to load class name with status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Error fetching class name: $e');
//     }
//   }

//   void fetchData() async {
//     try {
//       isLoading(true); // Menampilkan loading indicator

//       final response = await http.get(
//         Uri.parse("http://127.0.0.1:8000/api/ruang?id_guru=$teacherId"),
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//         },
//       );

//       if (response.statusCode == 200) {
//         final List<dynamic> classrooms = json.decode(response.body);
//         final List<Map<String, dynamic>> classList = [];

//         for (var classroom in classrooms) {
//           final classId = classroom['id_kelas'];

//           try {
//             final className = await _fetchClassName(classId);
//             classList.add({'class_name': className, 'id_kelas': classId});
//           } catch (e) {
//             print("Gagal mengambil nama kelas untuk ID kelas $classId: $e");
//           }
//         }

//         dataList.assignAll(classList);
//       } else {
//         print("Gagal mengambil data dari API dengan status code: ${response.statusCode}");
//         print("Response body: ${response.body}");
//       }
//     } catch (e) {
//       print("Terjadi kesalahan saat mengambil data: $e");
//     } finally {
//       isLoading(false); // Sembunyikan loading indicator setelah selesai
//     }
//   }
// }
