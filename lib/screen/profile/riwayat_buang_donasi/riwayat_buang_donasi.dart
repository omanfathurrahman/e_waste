import 'dart:ffi';

import 'package:ewaste/main.dart';
import 'package:ewaste/screen/default.dart';
import 'package:ewaste/screen/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:ewaste/utils/format_date.dart';

class RiwayatBuangDonasi extends StatefulWidget {
  const RiwayatBuangDonasi({super.key});

  @override
  State<RiwayatBuangDonasi> createState() => _RiwayatBuangDonasiState();
}

class _RiwayatBuangDonasiState extends State<RiwayatBuangDonasi> {
  // Data
  String _curScreen = "buang";
  bool _isLoading = false;

  // Function
  Future<List<Map<String, dynamic>>> _getAllBuang() async {
    final dataBuang = await supabase
        .from("sampah_dibuang")
        .select()
        .eq("id_user", supabase.auth.currentUser!.id);
    return dataBuang;
  }

  Future<List<Map<String, dynamic>>> _getAllDonasi() async {
    final dataBuang = await supabase
        .from("sampah_didonasikan")
        .select()
        .eq("id_user", supabase.auth.currentUser!.id);
    return dataBuang;
  }

  @override
  Widget build(BuildContext context) {
    return Default(
      child: ListView(
        children: [
          const KomponenHeader(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLoading = true;
                    });
                    setState(() => _curScreen = "buang");
                    Future.delayed(const Duration(milliseconds: 200), () {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Buang",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: (_curScreen == "buang"
                                ? FontWeight.w600
                                : FontWeight.w400),
                            color: (_curScreen == "buang"
                                ? Colors.deepPurple
                                : Colors.black)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isLoading = true;
                    });
                    setState(() => _curScreen = "donasi");
                    Future.delayed(const Duration(milliseconds: 200), () {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Donasi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: (_curScreen == "donasi"
                                ? FontWeight.w600
                                : FontWeight.w400),
                            color: (_curScreen == "donasi"
                                ? Colors.deepPurple
                                : Colors.black)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: (_isLoading)
                ? const Text(
                    "Loading...",
                    textAlign: TextAlign.center,
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _curScreen == "buang"
                        ? FutureBuilder(
                            future: _getAllBuang(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }
                              final listBuang =
                                  snapshot.data as List<Map<String, dynamic>>;
                              return Column(
                                  children: listBuang
                                      .map(
                                        (buangItem) => Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Buang",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(formatDate(buangItem[
                                                        'created_at'])),
                                                  ],
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    print('tes');
                                                  },
                                                  child: const Text(
                                                      "Lihat Detail"),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList());
                            },
                          )
                        : FutureBuilder(
                            future: _getAllDonasi(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }
                              final listBuang =
                                  snapshot.data as List<Map<String, dynamic>>;
                              return Column(
                                  children: listBuang
                                      .map(
                                        (buangItem) => Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Donasi",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    Text(formatDate(buangItem[
                                                        'created_at'])),
                                                  ],
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      print('tes');
                                                    },
                                                    child: const Text(
                                                        "Lihat Detail"))
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList());
                            },
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
                builder: (context) => const MainLayout(curScreenIndex: 4),
              ),
            );
          },
        ),
        const Text(
          "Riwayat Buang dan Donasi",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
