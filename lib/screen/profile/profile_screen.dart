import 'package:ewaste/main.dart';
import 'package:ewaste/screen/auth/login_screen.dart';
import 'package:ewaste/screen/profile/detail_profile/detail_profile_screen.dart';
import 'package:ewaste/screen/profile/faq/faq.dart';
import 'package:ewaste/screen/profile/kritik_saran/kritik_saran.dart';
import 'package:ewaste/screen/profile/privasi_keamanan/privasi_keamanan.dart';
import 'package:ewaste/screen/profile/riwayat_buang_donasi/riwayat_buang_donasi.dart';
import 'package:ewaste/utils/get_alamat_lengkap.dart';
import 'package:ewaste/utils/get_pekerjaan.dart';
import 'package:ewaste/utils/get_user.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userId;
  @override
  void initState() {
    userId = supabase.auth.currentUser!.id;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          children: [
            const Text(
              "Profile",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            const SizedBox(height: 16),
            KomponenProfile(userId: userId),
            const SizedBox(height: 16),
            KomponenPoin(userId: userId),
            const SizedBox(height: 16),
            const KomponenMenu(),
            const SizedBox(height: 16),
            const KomponenLogout(),
          ],
        ),
      Positioned(
          top: 0,
          left: 0,
          child: Image.asset("assets/images/logo-b.png", width: 60, height: 60),
        ),
      ],
    );
  }
}

class KomponenProfile extends StatelessWidget {
  const KomponenProfile({super.key, required this.userId});
  final String? userId;

  Future<Map<String, dynamic>> getUser(id) async {
    final response =
        await supabase.from('profile').select().eq('id', id).single().limit(1);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data as Map<String, dynamic>;

          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 1)),
                clipBehavior: Clip.hardEdge,
                child: Image.network(
                  (data['img_url'] is String)
                      ? data['img_url']
                      : 'https://oexltokstwraweaozqav.supabase.co/storage/v1/object/public/avatars/default.webp?t=2024-02-09T13%3A54%3A15.630Z',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                data['nama_lengkap'],
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 6),
              FutureBuilder(
                future: getPekerjaan(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("Pekerjaan belum diatur"),
                    );
                  }
                  final data = snapshot.data;
                  return Text(
                    data!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  );
                },
              ),
              const SizedBox(height: 2),
              FutureBuilder(
                future: getAlamatLengkap(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Text("Alamat belum diatur", style: TextStyle(color: Colors.white),),
                    );
                  }
                  final data = snapshot.data;
                  return Text(
                    data!,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  );
                },
              )
            ],
          );
        });
  }
}

class KomponenPoin extends StatelessWidget {
  const KomponenPoin({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data as Map<String, dynamic>;
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF3E87E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Jumlah Poin",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        data['jumlah_poin'].toString(),
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(width: 32),
                  Column(
                    children: [
                      const Text(
                        "Status",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        data['status'],
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

class KomponenMenu extends StatelessWidget {
  const KomponenMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DetailProfileScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Edit Profile",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Divider(height: 1.0),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RiwayatBuangDonasi()));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Riwayat Buang dan Donasi",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Divider(height: 1.0),
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const FaqScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "FAQ",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Divider(height: 1.0),
            InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => const KritikSaranScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Kritik dan saran",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const Divider(height: 1.0),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivasiKeamananScreen()));
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Privasi dan Keamanan",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KomponenLogout extends StatelessWidget {
  const KomponenLogout({super.key});

  Future<void> _logout() async {
    await supabase.auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          _logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
        child: const Text("Logout"));
  }
}
