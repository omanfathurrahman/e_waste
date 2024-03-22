
import 'package:ewaste/main.dart';
import 'package:ewaste/screen/main_layout.dart';
import 'package:ewaste/screen/profile/detail_profile/edit_alamat/edit_alamat.dart';
import 'package:ewaste/screen/profile/detail_profile/edit_email/edit_email.dart';
import 'package:ewaste/screen/profile/detail_profile/edit_nama/edit_nama.dart';
import 'package:ewaste/utils/get_alamat_lengkap.dart';
import 'package:ewaste/utils/get_pekerjaan.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'edit_pekerjaan/edit_pekerjaan.dart';

class DetailProfileScreen extends StatefulWidget {
  const DetailProfileScreen({
    super.key,
  });

  @override
  State<DetailProfileScreen> createState() => _DetailProfileScreenState();
}

class _DetailProfileScreenState extends State<DetailProfileScreen> {
  late String userId;
  bool _isLoading = false;

  @override
  void initState() {
    userId = supabase.auth.currentUser!.id;
    super.initState();
  }


  Future<Map<String, dynamic>> _getUser(id) async {
    final response =
        await supabase.from('profile').select().eq('id', id).single().limit(1);

    return response;
  }

  Future<void> _uploadProfilePic() async {
    final picker = ImagePicker();
    final imageFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 300,
      maxHeight: 300,
    );

    if (imageFile == null) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      final bytes = await imageFile.readAsBytes();
      final fileExt = imageFile.path.split('.').last;
      final fileName = '${DateTime.now().toIso8601String()}.$fileExt';
      final filePath = fileName;
      await supabase.storage.from('avatars').uploadBinary(
            filePath,
            bytes,
            fileOptions: FileOptions(
              contentType: imageFile.mimeType,
            ),
          );
      final imageUrlResponse = await supabase.storage
          .from('avatars')
          .createSignedUrl(filePath, 60 * 60 * 24 * 365 * 10);
      await supabase
          .from('profile')
          .update({'img_url': imageUrlResponse}).eq('id', userId);
    } on StorageException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unexpected error occurred'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data as Map<String, dynamic>;
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['nama_lengkap'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w500),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _uploadProfilePic();
                                },
                                child: Container(
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 80,
                                          height: 80,
                                          child: CircularProgressIndicator(
                                            color: Colors.blue,
                                          ),
                                        )
                                      : ((data['img_url'] is String)
                                          ? Image.network(
                                              data['img_url'],
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              'https://oexltokstwraweaozqav.supabase.co/storage/v1/object/public/avatars/default.webp?t=2024-02-09T13%3A54%3A15.630Z',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            )),
                                ),
                              )
                            ],
                          ),
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
                                      "Nama lengkap",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EditNamaScreen(),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.black,
                                                      width: 1))),
                                          child: Text(
                                            data['nama_lengkap'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Email",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EditEmailScreen(),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.black,
                                                      width: 1))),
                                          child: Text(
                                            data['email'],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Alamat",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EditAlamatScreen(),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.black,
                                                      width: 1))),
                                          child: FutureBuilder(
                                              future: getAlamatLengkap(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Text(
                                                    "Alamat belum diatur",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                  );
                                                }
                                                final alamatLengkap =
                                                    snapshot.data as String;
                                                return Text(
                                                  alamatLengkap,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Pekerjaan",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const EditPekerjaanScreen(),
                                          ),
                                        );
                                      },
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.black,
                                                      width: 1))),
                                          child: FutureBuilder(
                                              future: getPekerjaan(),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Text(
                                                    "Loading...",
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    ),
                                                  );
                                                }
                                                final pekerjaan =
                                                    snapshot.data as String;
                                                return Text(
                                                  pekerjaan,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                  ),
                                                );
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
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
                builder: (context) => const MainLayout(
                  curScreenIndex: 4,
                ),
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
