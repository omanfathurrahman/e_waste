import 'package:e_waste/component/icon_widget.dart';
import 'package:e_waste/layout/default.dart';
import 'package:flutter/material.dart';

class BuangScreen extends StatelessWidget {
  const BuangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: ListView(
        children: [
          const Komponen1(),
          const SizedBox(height: 16),
          const Komponen2(),
          const SizedBox(height: 16),
          Komponen3(),
        ],
      ),
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
        const Text(
          "Buang Sampah Elektronik",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        ClipOval(
          child: Material(
            color: Colors.white, // Button color
            child: InkWell(
              splashColor: Colors.deepPurple[400], // Splash color
              onTap: () {},
              child: const SizedBox(
                  width: 40,
                  height: 40,
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: IconWidget(
                      "basket",
                      color: Color(0xFF4285F4),
                    ),
                  )),
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
    return const SizedBox(
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          border: OutlineInputBorder(),
          hintText: 'Cari jenis sampah',
        ),
      ),
    );
  }
}

class Komponen3 extends StatelessWidget {
  Komponen3({super.key});
  final List<Map<String, String>> data = [
    {
      "nama": "Laptop",
      "gambar": "laptop",
    },
    {
      "nama": "Smartphone",
      "gambar": "smartphone",
    },
    {
      "nama": "Printer",
      "gambar": "printer",
    },
    {
      "nama": "Kulkas",
      "gambar": "kulkas",
    },
    {
      "nama": "Televisi",
      "gambar": "televisi",
    },
    {
      "nama": "Lainnya",
      "gambar": "lainnya",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Text("Jenis Elektronik"),
      const SizedBox(height: 10),
      ColoredBox(
        color: Colors.white,
        child: SizedBox(
          height: 500,
          child: Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(colors: [
                Color.fromARGB(255, 248, 104, 104),
                Color.fromARGB(255, 217, 24, 24),
              ], radius: 0.85, focal: Alignment.center),
            ),
            child: GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                crossAxisCount: 3,
              ),
              children: <Widget>[
                Container(color: Colors.white54),
                Container(color: Colors.white54),
                Container(color: Colors.white54),
                Container(color: Colors.white54),
                Container(color: Colors.white54),
                Container(color: Colors.white54),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}
