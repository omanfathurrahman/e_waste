import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        Text(
          "Profile",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        SizedBox(height: 16),
        KomponenProfile(),
        SizedBox(height: 16),
        KomponenPoin(),
        SizedBox(height: 16),
        KomponenMenu(),
      ],
    );
  }
}

class KomponenProfile extends StatelessWidget {
  const KomponenProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          "assets/images/143035475_1029718927553677_5869815052519506947_n1.png",
        ),
        const Text(
          "Lorem Ipsum",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        const SizedBox(height: 6),
        const Text(
          "Wiraswasta",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 2),
        const Text(
          "Bojongsoang, Kab. Bandung",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
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
        color: const Color(0xFF3E87E6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Jumlah Poin",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "120",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ],
            ),
            SizedBox(width: 32),
            Column(
              children: [
                Text(
                  "Status",
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  "Sultan",
                  style: TextStyle(
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
        padding: EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                print("fdaf");
              },
              child: Padding(
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
            Divider(height: 1.0),
            InkWell(
              onTap: () {
                print("fdaf");
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Aktifitas Saya",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Divider(height: 1.0),
            InkWell(
              onTap: () {
                print("fdaf");
              },
              child: Padding(
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
            Divider(height: 1.0),
            InkWell(
              onTap: () {
                print("fdaf");
              },
              child: Padding(
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
            Divider(height: 1.0),
            InkWell(
              onTap: () {
                print("fdaf");
              },
              child: Padding(
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
