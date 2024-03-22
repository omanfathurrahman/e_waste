import 'package:ewaste/main.dart';
import 'package:ewaste/screen/profile/detail_profile/detail_profile_screen.dart';
import 'package:flutter/material.dart';

class EditNamaScreen extends StatefulWidget {
  const EditNamaScreen({
    super.key,
  });

  @override
  State<EditNamaScreen> createState() => _EditNamaScreenState();
}

class _EditNamaScreenState extends State<EditNamaScreen> {
  late String userId;
  final TextEditingController _namaController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    userId = supabase.auth.currentUser!.id;

    supabase
        .from('profile')
        .select('nama_lengkap')
        .eq('id', userId)
        .single()
        .limit(1)
        .then((value) => _namaController.text = value['nama_lengkap']);

    super.initState();
  }

  Future<void> _updateNama() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await supabase
          .from('profile')
          .update({'nama_lengkap': _namaController.text}).eq(
        'id',
        userId,
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Stack(
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ListView(
                children: [
                  const KomponenHeader(),
                  const SizedBox(
                    height: 8,
                  ),
                  const SizedBox(
                    height: 16,
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
                                "Update Nama Lengkap",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                controller: _namaController,
                                decoration: InputDecoration(
                                  labelText: "Nama Lengkap",
                                  hintText: "Masukkan Nama Lengkap Anda",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _isLoading
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : ElevatedButton(
                                          onPressed: () {
                                            _updateNama();
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
