import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesFunctions {
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  //saving user data
  static Future<void> saveUserLogInState(bool isLoggedIn) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(userLoggedInKey, isLoggedIn);
  }

  //retrieving user data from SP
  static Future<bool> getUserLogInState() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.getBool(userLoggedInKey);
  }
}
