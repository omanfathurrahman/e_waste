import 'package:e_waste/main.dart';
import 'package:e_waste/screen/service/daftar_lokasi_service/lokasi_service_terdekat_screen.dart';
import 'package:flutter/material.dart';

class DetailProfileScreen extends StatefulWidget {
  const DetailProfileScreen({
    super.key,
  });

  @override
  State<DetailProfileScreen> createState() => _DetailProfileScreenState();
}

class _DetailProfileScreenState extends State<DetailProfileScreen> {
  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: ListView(
                children: [
                  const KomponenHeader(),
                  const SizedBox(
                    height: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "John Doe",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500),
                            ),
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Image.network(
                                'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            )
                          ]),
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
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black, width: 1))),
                                  child: const Text(
                                    "John Doe",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
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
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black, width: 1))),
                                  child: const Text(
                                    "jhon@gmail.com",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
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
                              SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.black, width: 1))),
                                  child: const Text(
                                    "",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
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
