import 'package:ewaste/component/icon_widget.dart';
import 'package:ewaste/main.dart';
import 'package:ewaste/screen/profile/riwayat_buang_donasi/riwayat_buang_donasi.dart';
import 'package:ewaste/screen/tukar_poin/tukar_poin.dart';
import 'package:ewaste/utils/format_date.dart';
import 'package:ewaste/utils/get_user.dart';
import 'package:ewaste/utils/get_username.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.gantiScreen});
  final Function(int) gantiScreen;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
            const KomponenHeader(),
            const SizedBox(height: 20),
            KomponenPoin(userId: userId),
            const SizedBox(height: 20),
            KomponenNavigasi(gantiScreen: widget.gantiScreen),
            const SizedBox(height: 20),
            // const KomponenIklan(),
            const SizedBox(height: 20),
            const Komponen5(),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Image.asset("assets/images/logo-b.png", width: 60, height: 60),
        ),
      ],
    );
  }
}

class KomponenHeader extends StatelessWidget {
  const KomponenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            FutureBuilder(
              future: getImgUrl(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final data = snapshot.data;
                return CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage((data is String)
                      ? data
                      : "https://oexltokstwraweaozqav.supabase.co/storage/v1/object/public/avatars/default.webp?t=2024-02-09T13%3A54%3A15.630Z"),
                );
              },
            ),
            const SizedBox(width: 10),
            FutureBuilder(
              future: getUsername(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final data = snapshot.data as String;
                return Text(
                  data,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                );
              },
            ),
          ],
        ),
        // ClipOval(
        //   child: Material(
        //     color: Colors.white, // Button color
        //     child: InkWell(
        //       splashColor: Colors.deepPurple[400], // Splash color
        //       onTap: () {},
        //       child: const SizedBox(
        //           width: 40,
        //           height: 40,
        //           child: Padding(
        //             padding: EdgeInsets.all(8.0),
        //             child: IconWidget("notification"),
        //           )),
        //     ),
        //   ),
        // )
      ],
    );
  }
}

class KomponenPoin extends StatelessWidget {
  const KomponenPoin({super.key, required this.userId});
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Jumlah Poin",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const IconWidget(
                      "star",
                      panjang: 24,
                      color: Color.fromARGB(255, 62, 135, 230),
                    ),
                    const SizedBox(width: 10),
                    FutureBuilder(
                      future: getUser(userId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        final data = snapshot.data as Map<String, dynamic>;
                        return Text(
                          data['jumlah_poin'].toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
            ElevatedButton(
                onPressed: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const TukarPoinScreen(),
                        ),
                      )
                    },
                child: const Text(
                  "Tukar",
                ))
          ],
        ),
      ),
    );
  }
}

class KomponenNavigasi extends StatelessWidget {
  const KomponenNavigasi({super.key, required this.gantiScreen});
  final Function(int) gantiScreen;

  Widget container({
    required String icon,
    required String judul,
    required Color iconColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconWidget(
                      icon,
                      panjang: 24,
                      color: iconColor,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          judul,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Lihat selengkapnya",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            ClipOval(
              child: Material(
                color: const Color(0xFFF2F2F2), // Button color
                child: InkWell(
                  onTapUp: (details) {
                    switch (icon) {
                      case "buang":
                        gantiScreen(1);
                      // Navigator.pushNamed(context, '/buang');
                      case "donasi":
                        gantiScreen(2);
                      case "service":
                        gantiScreen(3);
                    }
                  },
                  splashColor: Colors.deepPurple[400], // Splash color
                  onTap: () {},
                  child: const SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(Icons.arrow_right_alt),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        container(
            icon: "buang",
            judul: "Buang Sampah Elektronik",
            iconColor: const Color(0xFFF7A340)),
        const SizedBox(height: 10),
        container(
            icon: "donasi",
            judul: "Donasi Sampah Elektronik",
            iconColor: const Color(0xFFD11F1F)),
        const SizedBox(height: 10),
        container(
          icon: "service",
          judul: "Service Barang Elektronik",
          iconColor: const Color(0xFF2F80ED),
        ),
      ],
    );
  }
}

class KomponenIklan extends StatelessWidget {
  const KomponenIklan({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(
        "assets/images/iklan.png",
        width: double.infinity,
        scale: 0.1,
      ),
    );
  }
}

class Komponen5 extends StatefulWidget {
  const Komponen5({super.key});

  @override
  State<Komponen5> createState() => _Komponen5State();
}

class _Komponen5State extends State<Komponen5> {
  @override
  initState() {
    super.initState();
    _getAllRiwayat();
  }

  Future<List<Map<String, dynamic>>> _getAllRiwayat() async {
    final dataBuang = await supabase
        .from("sampah_dibuang")
        .select()
        .eq("id_user", supabase.auth.currentUser!.id);

    final dataDonasi = await supabase
        .from("sampah_didonasikan")
        .select()
        .eq("id_user", supabase.auth.currentUser!.id);
    dataDonasi.addAll(dataBuang);
    final semuaData = dataDonasi;
    semuaData.sort((a, b) => b["created_at"].compareTo(a["created_at"]));
    if (semuaData.isEmpty) {
      return [];
    }
    final top5DataTerbaru = semuaData.sublist(0, 5);

    return top5DataTerbaru;
  }

  Widget container({
    required String icon,
    required String judul,
    required String tanggal,
    Color iconColor = Colors.grey,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color.fromARGB(231, 249, 249, 249),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconWidget(
                  icon,
                  panjang: 24,
                  color: iconColor,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      judul,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tanggal,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Semua Aktivitas",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            TextButton(
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RiwayatBuangDonasi(),
                  ),
                )
              },
              child: Text(
                "Lihat Semua",
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        FutureBuilder(
          future: _getAllRiwayat(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Text("Riwayat masih kosong");
            }
            final semuaData = snapshot.data as List<Map<String, dynamic>>;
            if (semuaData.isEmpty) {
              return const Text("Riwayat masih kosong");
            }
            return Column(
              children: semuaData
                  .map(
                    (e) => Column(
                      children: [
                        const SizedBox(height: 10),
                        container(
                          icon: e.containsKey("status_didonasikan")
                              ? "donasi"
                              : "buang",
                          judul: e.containsKey("status_didonasikan")
                              ? "Donasi Sampah Elektronik"
                              : "Buang Sampah Elektronik",
                          tanggal: formatDate(e["created_at"].toString()),
                          iconColor: e.containsKey("status_didonasikan")
                              ? const Color(0xFFD11F1F)
                              : const Color(0xFFF7A340),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
