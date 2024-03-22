import 'package:supabase_flutter/supabase_flutter.dart';

Future<num> beratJenisElektronik({
  required int idJenisElektronik,
  var label,
}) async {
  late num berat;

  final jenisElektronik = await Supabase.instance.client
      .from("jenis_elektronik")
      .select("kategorisasi")
      .eq("id", idJenisElektronik)
      .single();

  if (jenisElektronik['kategorisasi'] == "none") {
    var berat2 = await Supabase.instance.client
        .from("kategorisasi_none")
        .select()
        .eq("id_jenis_elektronik", idJenisElektronik);
    berat = berat2[0]['berat'] as num;
  } else if (jenisElektronik['kategorisasi'] == "pilihan") {
    var berat2 = await Supabase.instance.client
        .from("kategorisasi_pilihan")
        .select("berat")
        .eq("id_jenis_elektronik", idJenisElektronik)
        .eq("label", label)
        .limit(1);
    berat = berat2[0]['berat'];
  } else if (jenisElektronik['kategorisasi'] == "kecil_sedang_besar") {

    var berat2 = await Supabase.instance.client
        .from("kategorisasi_kecilsedangbesar")
        .select(label)
        .eq("id_jenis_elektronik", idJenisElektronik)
        .limit(1);
    // print(berat2);
    berat = berat2[0][label];
  }

  return berat;
}
