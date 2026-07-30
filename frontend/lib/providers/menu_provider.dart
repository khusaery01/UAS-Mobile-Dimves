import 'package:flutter/material.dart';

import '../models/menu_model.dart';
import '../services/api_service.dart';

class MenuProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<MenuModel> _menus = [];

  List<MenuModel> get menus => _menus;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String? _error;

  String? get error => _error;

  Future<void> loadMenus() async {
    _isLoading = true;
    _error = null;

    notifyListeners();

    try {
      _menus = await _apiService.getMenus();
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;

    notifyListeners();
  }
}
