import 'package:ewaste/main.dart';
import 'package:ewaste/screen/profile/detail_profile/detail_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditPekerjaanScreen extends StatefulWidget {
  const EditPekerjaanScreen({super.key});

  @override
  State<EditPekerjaanScreen> createState() => _EditPekerjaanScreenState();
}

class _EditPekerjaanScreenState extends State<EditPekerjaanScreen> {
  final daftarPekerjaan = supabase.from('daftar_pekerjaan').select('nama');
  final TextEditingController _pekerjaanController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    _getCurPekerjaan();
    super.initState();
  }

  Future<void> _getCurPekerjaan() async {
    final pekerjaanId = await supabase
        .from('profile')
        .select('pekerjaan_id')
        .eq('id', supabase.auth.currentUser!.id)
        .single()
        .limit(1);

    if (pekerjaanId['pekerjaanId'] ?? false) {
      _pekerjaanController.text = '';
    } else {
      final namaPekerjaan = await supabase
          .from('daftar_pekerjaan')
          .select('nama')
          .eq('id', pekerjaanId['pekerjaan_id'])
          .single()
          .limit(1);
      _pekerjaanController.text = namaPekerjaan['nama'];
    }
  }

  Future<void> _updatePekerjaan() async {
    setState(() {
      isLoading = true;
    });
    final pekerjaanId = (await supabase
        .from('daftar_pekerjaan')
        .select('id')
        .eq('nama', _pekerjaanController.text)
        .single()
        .limit(1))['id'];

    await supabase.from('profile').update({'pekerjaan_id': pekerjaanId}).eq(
        'id', supabase.auth.currentUser!.id);

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(children: [
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: ListView(
                  children: [
                    const KomponenHeader(),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Edit Pekerjaan",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            FutureBuilder(
                              future: daftarPekerjaan,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }
                                final pekerjaanList = snapshot.data!;
                                return DropdownMenu(
                                    controller: _pekerjaanController,
                                    expandedInsets: EdgeInsets.zero,
                                    dropdownMenuEntries: pekerjaanList
                                        .map((e) => DropdownMenuEntry(
                                            value: e['nama'], label: e['nama']))
                                        .toList());
                              },
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: _updatePekerjaan,
                                  child: (isLoading)
                                      ? const CircularProgressIndicator()
                                      : const Text("Simpan"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )))
      ]),
    );
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
            context.go('/profile/detail');
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
