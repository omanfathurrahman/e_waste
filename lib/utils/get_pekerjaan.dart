import 'package:ewaste/main.dart';

Future<String> getPekerjaan() async {
  final userId = supabase.auth.currentUser!.id;
  final pekerjaanId = (await supabase
      .from('profile')
      .select('pekerjaan_id')
      .eq('id', userId)
      .single()
      .limit(1))['pekerjaan_id'];
  final namaPekerjaan = (await supabase
      .from('daftar_pekerjaan')
      .select('nama')
      .eq('id', pekerjaanId)
      .single()
      .limit(1))['nama'];
  return namaPekerjaan as String;
}


Future<List<Map<String, dynamic>>> getPekerjaanList() async {
  final response = await supabase.from('daftar_pekerjaan').select();
  return response;
}
