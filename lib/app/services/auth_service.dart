import 'package:cidade_singular/app/services/dio_service.dart';
import 'package:cidade_singular/app/stores/user_store.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthService {
  DioService dioService;
  UserStore userStore = Modular.get();

  AuthService(this.dioService);

  Future<bool> login({required String email, required String password}) async {
    try {
      var response = await dioService.dio.post(
        "/user/auth",
        data: {
          "email": email,
          "password": password,
        },
      );

      if (response.data["token"] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", response.data["token"]);
        dioService.addToken(response.data["token"]);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (e is DioError) {
        print(e);
      }
      return false;
    }
  }

  Future logout() async {
    userStore.user = null;
    dioService.removeToken();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('cityId');
  }
}
