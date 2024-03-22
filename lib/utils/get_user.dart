import 'package:ewaste/main.dart';

Future<Map<String, dynamic>> getUser(id) async {
  final response =
      await supabase.from('profile').select().eq('id', id).single().limit(1);

  return response;
}

Future<String> getUserId() async {
  final user = supabase.auth.currentUser;
  return user!.id;
}

Future<String> getImgUrl() async {
  final id = supabase.auth.currentUser!.id;

  final response =
      await supabase.from('profile').select("img_url").eq('id', id).single().limit(1);

  return response['img_url'] as String;
}