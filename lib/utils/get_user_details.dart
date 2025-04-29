import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserUid() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  String? uid = sp.getString("useruid");
  return uid;
}
