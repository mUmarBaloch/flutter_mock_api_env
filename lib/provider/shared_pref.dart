import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
   late SharedPreferences pref;
  final String _authTokenKey = "auth_token";
 void initPref() async{
    pref = await SharedPreferences.getInstance();
  
  }
  String? get token => pref.getString(_authTokenKey);

  Future<bool> setAuthtoken(token) async => await pref.setString(_authTokenKey, token);
  Future<bool> removeTokenFromPref()async  => await pref.remove(_authTokenKey); 

  
  Future<bool> isAuthenticated() async {
    return pref.containsKey(_authTokenKey);
  } 

  
}