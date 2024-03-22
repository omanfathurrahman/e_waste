import 'package:ewaste/main.dart';

Future<num> getJumlahPoin() async {
  final userId = supabase.auth.currentUser!.id;
    final jumlahPoin = (await supabase
        .from('profile')
        .select('jumlah_poin')
        .eq('id', userId)
        .single()
        .limit(1))['jumlah_poin'];
    return jumlahPoin;
  }