import 'package:ewaste/main.dart';

Future<String> getUsername() async {
  final userId = supabase.auth.currentUser!.id;
  final response = await supabase.from('profile').select("nama_lengkap").eq('id', userId).single().limit(1);
  return response['nama_lengkap'];
}