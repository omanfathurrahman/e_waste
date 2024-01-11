import 'package:e_waste/component/icon_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        KomponenHeader(),
        SizedBox(height: 20),
        KomponenPoin(),
        SizedBox(height: 20),
        KomponenNavigasi(),
        SizedBox(height: 20),
        KomponenIklan(),
        SizedBox(height: 20),
        Komponen5(),
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
            Image.asset(
              "assets/images/143035475_1029718927553677_5869815052519506947_n 1.png",
            ),
            const SizedBox(width: 10),
            const Text(
              "John Mayer",
              style: TextStyle(fontSize: 20, color: Colors.white),
            )
          ],
        ),
        ClipOval(
          child: Material(
            color: Colors.white, // Button color
            child: InkWell(
              splashColor: Colors.deepPurple[400], // Splash color
              onTap: () {},
              child: const SizedBox(
                  width: 40, height: 40, child: IconWidget("notification")),
            ),
          ),
        )
      ],
    );
  }
}

class KomponenPoin extends StatelessWidget {
  const KomponenPoin({super.key});

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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Jumlah Poin",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    IconWidget(
                      "star",
                      panjang: 24,
                      color: Color.fromARGB(255, 62, 135, 230),
                    ),
                    SizedBox(width: 10),
                    Text("1024"),
                  ],
                )
              ],
            ),
            ElevatedButton(
                onPressed: () => {},
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
  const KomponenNavigasi({super.key});

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
                    switch (icon){
                      case "buang":
                        // Navigator.pushNamed(context, '/buang');
                        break;
                      case "donasi":
                        // Navigator.pushNamed(context, '/donasi');
                        break;
                      case "service":
                        // Navigator.pushNamed(context, '/service');
                        break;
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
    return Container(
      width: double.infinity,
      child: Image.asset(
        "assets/images/iklan.png",
        width: double.infinity,
        scale: 0.1,
      ),
    );
  }
}

class Komponen5 extends StatelessWidget {
  const Komponen5({super.key});

  Widget container({
    required String icon,
    required String judul,
    required String tanggal,
    Color iconColor = Colors.grey,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromARGB(231, 249, 249, 249),
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
              onPressed: () => {},
              child: Text(
                "Lihat Semua",
                style: TextStyle(
                  color: Colors.grey[700],
                ),
              ),
            ),
          ],
        ),
        container(
          icon: "buang",
          judul: "Buang Sampah Elektronik",
          iconColor: const Color(0xFFF7A340),
          tanggal: "Hari ini, 2 Januari 2021",
        ),
        SizedBox(height: 10),
        container(
          icon: "service",
          judul: "Service Barang Elektronik",
          iconColor: const Color(0xFF2F80ED),
          tanggal: "01 Januari 2024",
        ),
        SizedBox(height: 10),
        container(
          icon: "buang",
          judul: "Buang Sampah Elektronik",
          iconColor: const Color(0xFFF7A340),
          tanggal: "25 Desember 2023",
        ),
      ],
    );
  }
}
