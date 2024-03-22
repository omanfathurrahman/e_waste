import 'package:ewaste/main.dart';

Future<List<Map<String, dynamic>>> getDaftarHadiah() async {
  final daftarHadiah = await supabase.from('daftar_hadiah').select().order('id', ascending: true);
  return daftarHadiah;
}
