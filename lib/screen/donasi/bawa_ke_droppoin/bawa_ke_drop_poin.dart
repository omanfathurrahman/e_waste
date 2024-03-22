import 'package:ewaste/main.dart';
import 'package:ewaste/screen/donasi/daftar_droppoin/daftar_droppoin.dart';
import 'package:flutter/material.dart';

class BawaKeDropPointDonasiScreen extends StatefulWidget {
  const BawaKeDropPointDonasiScreen({super.key});

  @override
  State<BawaKeDropPointDonasiScreen> createState() =>
      _BawaKeDropPointDonasiScreenState();
}

class _BawaKeDropPointDonasiScreenState
    extends State<BawaKeDropPointDonasiScreen> {
  final TextEditingController alamat = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.00, 1.00),
            end: Alignment(0, -1),
            colors: [Color(0xFFE9EBFF), Color(0xFF8B97FF)],
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: ListView(
            children: <Widget>[
              const KomponenHeader(),
              const SizedBox(height: 16),
              KomponenAlamat(alamat: alamat),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ]);
  }
}

class KomponenHeader extends StatelessWidget {
  const KomponenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(onPressed: () {
          Navigator.of(context).pop();
        }),
        const Text(
          "Donasi Sampah Elektronik",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
class KomponenAlamat extends StatefulWidget {
  const KomponenAlamat({super.key, required this.alamat});
  final TextEditingController alamat;

  @override
  State<KomponenAlamat> createState() => _KomponenAlamatState();
}
enum PilihanAlamat { alamatSaatIni, aturUlang }
class _KomponenAlamatState extends State<KomponenAlamat> {
  PilihanAlamat? _pilihanAlamat = PilihanAlamat.alamatSaatIni;
  late String userId;
  // bool _isLoading = false;
  final TextEditingController _kabupatenKotaController =
      TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kelurahanDesaController =
      TextEditingController();

  List<dynamic> curListKecamatan = [];
  List<dynamic> curListKelurahanDesa = [];

  @override
  void initState() {
    userId = supabase.auth.currentUser!.id;
    // _inisializeData();
    _getAlamatOption();
    super.initState();
  }

  @override
  void dispose() {
    _kabupatenKotaController.dispose();
    _kecamatanController.dispose();
    _kelurahanDesaController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>> _getUserAlamat(id) async {
    final alamat = await supabase
        .from('profile')
        .select('alamat_id, detail_alamat')
        .eq('id', id)
        .single()
        .limit(1);
    final detailAlamat = await supabase
        .from('daftar_alamat')
        .select()
        .eq('id', alamat['alamat_id'])
        .single()
        .limit(1);
    return detailAlamat;
  }

  Future<List<Map<String, dynamic>>> _getAlamatOption() async {
    final alamat = await supabase.from('daftar_alamat').select();
    return alamat;
  }

  // Future<void> _updateSelectedAlamat() async {
  //   setState(() {
  //     // _isLoading = true;
  //   });
  //   var selectedAlamatId = await supabase
  //       .from('daftar_alamat')
  //       .select('id')
  //       .eq('kabupaten_kota', _kabupatenKotaController.text)
  //       .eq('kecamatan', _kecamatanController.text)
  //       .eq('kelurahan_desa', _kelurahanDesaController.text)
  //       .single()
  //       .limit(1);

  //   await supabase.from('profile').update({
  //     'alamat_id': selectedAlamatId['id'],
  //   }).eq('id', userId);
  //   setState(() {
  //     // _isLoading = false;
  //   });
  // }

  Future<void> _getAllKecamatan() async {
    final kecamatan = await supabase
        .from('daftar_alamat')
        .select('kecamatan')
        .eq('kabupaten_kota', _kabupatenKotaController.text);
    setState(() {
      curListKecamatan =
          kecamatan.map((item) => item['kecamatan']).toSet().toList();
    });
  }

  Future<void> _getAllKelurahanDesa() async {
    final kelurahanDesa = await supabase
        .from('daftar_alamat')
        .select('kelurahan_desa')
        .eq('kecamatan', _kecamatanController.text);
    setState(() {
      curListKelurahanDesa =
          kelurahanDesa.map((item) => item['kelurahan_desa']).toSet().toList();
    });
  }

  Future<void> _onSelectedCurAlamat() async {
    final alamat = await _getUserAlamat(userId);
    _kabupatenKotaController.text = alamat['kabupaten_kota'];
    _kecamatanController.text = alamat['kecamatan'];
    _kelurahanDesaController.text = alamat['kelurahan_desa'];
  }

  Future<void> _onSelectedAturUlangAlamat() async {
    _kabupatenKotaController.clear();
    _kecamatanController.clear();
    _kelurahanDesaController.clear();
  }

  Future<num> _getSelectedAlamatId() async {
    final selectedAlamatId = await supabase
        .from('daftar_alamat')
        .select('id, kabupaten_kota, kecamatan, kelurahan_desa')
        .eq('kabupaten_kota', _kabupatenKotaController.text)
        .eq('kecamatan', _kecamatanController.text)
        .eq('kelurahan_desa', _kelurahanDesaController.text)
        .single()
        .limit(1);

    return selectedAlamatId['id'] as num;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Alamat",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        const SizedBox(
          height: 16,
        ),
        Column(
          children: [
            RadioListTile(
              value: PilihanAlamat.alamatSaatIni,
              groupValue: _pilihanAlamat,
              title: const Text(
                "Alamat Saat Ini",
                style: TextStyle(color: Colors.white),
              ),
              onChanged: (value) {
                setState(() {
                  _pilihanAlamat = value as PilihanAlamat;
                  _onSelectedCurAlamat();
                });
              },
            ),
            RadioListTile(
              value: PilihanAlamat.aturUlang,
              groupValue: _pilihanAlamat,
              title: const Text(
                "Atur Ulang Alamat",
                style: TextStyle(color: Colors.white),
              ),
              onChanged: (value) {
                setState(() {
                  _onSelectedAturUlangAlamat();
                  _pilihanAlamat = value as PilihanAlamat;
                });
              },
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        _pilihanAlamat == PilihanAlamat.aturUlang
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Kabupaten/Kota",
                      style: TextStyle(color: Colors.black)),
                  FutureBuilder(
                    future: _getAllKabupatenKota(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final kabupatenKota = snapshot.data!;
                      return DropdownMenu(
                          onSelected: (value) {
                            _getAllKecamatan();
                          },
                          controller: _kabupatenKotaController,
                          expandedInsets: EdgeInsets.zero,
                          dropdownMenuEntries: kabupatenKota
                              .map((e) => DropdownMenuEntry(value: e, label: e))
                              .toList());
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Kecamatan",
                      style: TextStyle(color: Colors.black)),
                  DropdownMenu(
                    onSelected: (value) {
                      _getAllKelurahanDesa();
                    },
                    enableFilter: true,
                    controller: _kecamatanController,
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: curListKecamatan
                        .map((e) => DropdownMenuEntry(value: e, label: e))
                        .toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Kelurahan/Desa",
                      style: TextStyle(color: Colors.black)),
                  DropdownMenu(
                    onSelected: (value) {
                      _kelurahanDesaController.text = value;
                    },
                    controller: _kelurahanDesaController,
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: curListKelurahanDesa
                        .map((e) => DropdownMenuEntry(value: e, label: e))
                        .toList(),
                  ),
                ],
              )
            : Container(),
        const SizedBox(
          height: 16,
        ),
        ElevatedButton(
            onPressed: () => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FutureBuilder(
                          future: _getSelectedAlamatId(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final alamatId = snapshot.data!;
                            return DaftarDroppoinDonasi(alamatId: alamatId);
                          }),
                    ),
                  ),
                },
            child: const Text("Cari"))
      ],
    );
  }
}

Future<List<dynamic>> _getAllKabupatenKota() async {
  final kabupatenKota =
      await supabase.from('daftar_alamat').select('kabupaten_kota');
  return kabupatenKota.map((item) => item['kabupaten_kota']).toSet().toList();
}
