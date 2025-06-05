import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TugasSebelumnyaController extends GetxController {
  var dataList = [].obs;
  var idKelas = 0.obs;
  var idSiswa = 0.obs;
  var isLoading = true.obs;

  void setId(int idKelasValue, int idsiswa) {
    idKelas.value = idKelasValue;
    idSiswa.value = idsiswa;
    fetchData();
  }

  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
            "http://127.0.0.1:8000/api/pengumpulan?id_kelas=${idKelas.value}&id_siswa=${idSiswa.value}"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        dataList.value = json.decode(response.body) as List;
      } else {
        throw Exception(
            'Failed to load data with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching data: $e");
      dataList.value = [];
    }
  }

  editJawaban({required int id, required String jawabanBaru}) async {
    try {
      final response = await http.put(
        Uri.parse("http://127.0.0.1:8000/api/pengumpulan/$id"),
        headers: {  
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'jawaban': jawabanBaru,
        }),
      );
      if (response.statusCode == 200) {
        fetchData();
      } else {
        throw Exception(
            'Failed to update jawaban with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error updating jawaban: $e");
    }
  }
}
