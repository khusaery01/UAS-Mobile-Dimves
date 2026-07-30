import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/menu_model.dart';
import 'api_service.dart';

class MenuService {
  Future<List<MenuModel>> getMenus() async {
    final response = await http.get(Uri.parse('${ApiService.baseUrl}/menus'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      List menus = data['menus'];

      return menus.map((e) => MenuModel.fromJson(e)).toList();
    } else {
      throw Exception("Gagal mengambil menu");
    }
  }
}
