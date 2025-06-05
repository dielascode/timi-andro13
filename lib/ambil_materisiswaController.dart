import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:timiprjct/materiGuru.dart';

class MateriSiswa extends GetxController{
   var idKelas = 0.obs;
  var materiList = [].obs;

  void setIdSiswa(int idsiswa) {
    idKelas.value = idsiswa;
    fetchData();
  }

  fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1:8000/api/materi?id_kelas=$idKelas"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        materiList.value = json.decode(response.body) as List;
      } else {
        throw Exception('Failed to load teacher with status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching teacher: $e");
      // Anda dapat menangani kesalahan di sini, misalnya dengan mengatur dataList menjadi null
      materiList.value = [];
    }
  }

}