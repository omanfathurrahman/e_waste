import 'package:ewaste/main.dart';
import 'package:ewaste/screen/profile/detail_profile/detail_profile_screen.dart';
import 'package:flutter/material.dart';

class EditAlamatScreen extends StatefulWidget {
  const EditAlamatScreen({
    super.key,
  });

  @override
  State<EditAlamatScreen> createState() => _EditAlamatScreenState();
}

class _EditAlamatScreenState extends State<EditAlamatScreen> {
  late String userId;
  bool _isLoading = false;
  final TextEditingController _kabupatenKotaController =
      TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kelurahanDesaController =
      TextEditingController();

  final TextEditingController _jalanController = TextEditingController();

  List<dynamic> curListKecamatan = [];
  List<dynamic> curListKelurahanDesa = [];

  @override
  void initState() {
    userId = supabase.auth.currentUser!.id;
    _inisializeData();
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

  Future<void> _inisializeData() async {
    final alamat = await _getUserAlamat(userId);
    _kabupatenKotaController.text = alamat['kabupaten_kota'];
    _kecamatanController.text = alamat['kecamatan'];
    _kelurahanDesaController.text = alamat['kelurahan_desa'];
    _getAllKecamatan();
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
    _jalanController.text = alamat['detail_alamat'];
    return detailAlamat;
  }

  Future<List<Map<String, dynamic>>> _getAlamatOption() async {
    final alamat = await supabase.from('daftar_alamat').select();
    return alamat;
  }

  Future<void> _updateSelectedAlamat() async {
    setState(() {
      _isLoading = true;
    });
    var selectedAlamatId = await supabase
        .from('daftar_alamat')
        .select('id')
        .eq('kabupaten_kota', _kabupatenKotaController.text)
        .eq('kecamatan', _kecamatanController.text)
        .eq('kelurahan_desa', _kelurahanDesaController.text)
        .single()
        .limit(1);

    await supabase.from('profile').update({
      'alamat_id': selectedAlamatId['id'],
      'detail_alamat': _jalanController.text
    }).eq('id', userId);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Alamat berhasil diubah"),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
    if (mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const DetailProfileScreen(),
        ),
      );
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUserAlamat(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final alamat = snapshot.data!;

          return MaterialApp(
            home: Stack(
              children: [
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: ListView(
                      children: [
                        const KomponenHeader(),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Update Alamat",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FutureBuilder(
                                          future: _getAllKabupatenKota(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            final kabupatenKota =
                                                snapshot.data!;
                                            return DropdownMenu(
                                                onSelected: (value) {
                                                  _kelurahanDesaController
                                                      .clear();
                                                  _kecamatanController.clear();
                                                  _getAllKecamatan();
                                                },
                                                controller:
                                                    _kabupatenKotaController,
                                                expandedInsets: EdgeInsets.zero,
                                                initialSelection:
                                                    alamat['kabupaten_kota'],
                                                dropdownMenuEntries:
                                                    kabupatenKota
                                                        .map((e) =>
                                                            DropdownMenuEntry(
                                                                value: e,
                                                                label: e))
                                                        .toList());
                                          },
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DropdownMenu(
                                          onSelected: (value) {
                                            _kelurahanDesaController.clear();
                                            _getAllKelurahanDesa();
                                          },
                                          enableFilter: true,
                                          controller: _kecamatanController,
                                          expandedInsets: EdgeInsets.zero,
                                          initialSelection: alamat['kecamatan'],
                                          dropdownMenuEntries: curListKecamatan
                                              .map((e) => DropdownMenuEntry(
                                                  value: e, label: e))
                                              .toList(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        DropdownMenu(
                                          controller: _kelurahanDesaController,
                                          expandedInsets: EdgeInsets.zero,
                                          initialSelection:
                                              alamat['kelurahan_desa'],
                                          dropdownMenuEntries:
                                              curListKelurahanDesa
                                                  .map((e) => DropdownMenuEntry(
                                                      value: e, label: e))
                                                  .toList(),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    TextField(
                                      controller: _jalanController,
                                      decoration: const InputDecoration(
                                        labelText:
                                            "Detail jalan dan nomor rumah",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 18,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        _isLoading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : ElevatedButton(
                                                onPressed: () {
                                                  // _updateEmail();
                                                  _updateSelectedAlamat();
                                                },
                                                child: const Text("Simpan"),
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

class KomponenHeader extends StatelessWidget {
  const KomponenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const DetailProfileScreen(),
              ),
            );
          },
        ),
        // const Text(
        //   "Profile",
        //   style: TextStyle(
        //       fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        // ),
      ],
    );
  }
}

Future<List<dynamic>> _getAllKabupatenKota() async {
  final kabupatenKota =
      await supabase.from('daftar_alamat').select('kabupaten_kota');
  return kabupatenKota.map((item) => item['kabupaten_kota']).toSet().toList();
}
