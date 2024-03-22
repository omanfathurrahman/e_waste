import 'package:ewaste/main.dart';

Future<String> getAlamatLengkap() async {
  final userId = supabase.auth.currentUser!.id;
  final alamatRes = await supabase
      .from('profile')
      .select('alamat_id, detail_alamat')
      .eq('id', userId)
      .single()
      .limit(1);

  final alamatDropdownRes = await supabase
      .from('daftar_alamat')
      .select('kabupaten_kota, kecamatan, kelurahan_desa')
      .eq('id', alamatRes['alamat_id'])
      .single()
      .limit(1);
  return "${alamatRes['detail_alamat']}, ${alamatDropdownRes['kelurahan_desa']}, ${alamatDropdownRes['kecamatan']}, ${alamatDropdownRes['kabupaten_kota']}";
}
