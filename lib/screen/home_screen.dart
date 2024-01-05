import 'package:e_waste/component/icon_widget.dart';
import 'package:e_waste/component/navbar_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          // width: 319,
          // height: 537,
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
              children: const [
                Komponen1(),
                SizedBox(height: 20),
                Komponen2(),
                SizedBox(height: 20),
                Komponen3(),
                SizedBox(height: 20),
                Komponen4(),
                SizedBox(height: 20),
                Komponen5(),
              ],
            ),
          ),
          bottomNavigationBar: const Navbar(),
        ),
      ],
    );
  }
}

class Komponen1 extends StatelessWidget {
  const Komponen1({super.key});

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
            const Text("John Mayer",
                style: TextStyle(fontSize: 20, color: Colors.white))
          ],
        ),
        ClipOval(
          child: Material(
            color: Colors.white, // Button color
            child: InkWell(
              splashColor: Colors.deepPurple[400], // Splash color
              onTap: () {},
              child: const SizedBox(
                  width: 40, height: 40, child: Icon(Icons.menu)),
            ),
          ),
        )
      ],
    );
  }
}

class Komponen2 extends StatelessWidget {
  const Komponen2({super.key});

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

class Komponen3 extends StatelessWidget {
  const Komponen3({super.key});

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

class Komponen4 extends StatelessWidget {
  const Komponen4({super.key});

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
