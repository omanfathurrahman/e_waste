// import 'dart:ffi';

import 'package:ewaste/component/get_svg_widget.dart';
import 'package:ewaste/extention/to_capitalize.dart';
import 'package:ewaste/main.dart';
import 'package:ewaste/screen/donasi/bawa_ke_droppoin/bawa_ke_drop_poin.dart';
import 'package:ewaste/screen/main_layout.dart';
import 'package:ewaste/utils/hitung_berat.dart';
import 'package:flutter/material.dart';

class KeranjangDonasi extends StatefulWidget {
  const KeranjangDonasi({super.key});

  @override
  State<KeranjangDonasi> createState() => _KeranjangDonasiState();
}

class _KeranjangDonasiState extends State<KeranjangDonasi> {
  var daftarKeranjangDonasi = supabase
      .from("keranjang_donasi")
      .select()
      .eq("id_user", supabase.auth.currentUser?.id as Object);

  void donasiSampahDiKeranjang({required num beratKeseluruhan}) async {
    final keranjangDonasi = await supabase
        .from("keranjang_donasi")
        .select()
        .eq("id_user", supabase.auth.currentUser?.id as Object);

    await supabase
        .from("sampah_didonasikan")
        .insert({"id_user": supabase.auth.currentUser?.id as Object});
    final idSampahDiDonasikanBaru = await supabase
        .from("sampah_didonasikan")
        .select()
        .order("id", ascending: false)
        .limit(1)
        .single();
    for (var item in keranjangDonasi) {
      await supabase.from("detail_sampah_didonasikan").insert([
        {
          "id_jenis_elektronik": item['id_jenis_elektronik'],
          "jumlah": item['jumlah'],
          "kategorisasi": item['kategorisasi'],
          "id_sampah_didonasikan": idSampahDiDonasikanBaru['id'],
        }
      ]);
    }
    await supabase
        .from("keranjang_donasi")
        .delete()
        .eq("id_user", supabase.auth.currentUser?.id as Object);

    setState(() {
      daftarKeranjangDonasi = supabase
          .from("keranjang_donasi")
          .select()
          .eq("id_user", supabase.auth.currentUser?.id as Object);
    });
    if (beratKeseluruhan < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silahkan masukkan alamat anda"),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BawaKeDropPointDonasiScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pengumpul barang akan menghubungi anda"),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MainLayout(curScreenIndex: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: ListView(
                children: [
                  Row(
                    children: [
                      BackButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const MainLayout(
                                curScreenIndex: 2,
                              ),
                            ),
                          );
                        },
                        color: Colors.white,
                      ),
                      const Text(
                        "Keranjang",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                  FutureBuilder(
                    future: daftarKeranjangDonasi,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      num beratKeseluruhan = 0;
                      final keranjangDonasi = snapshot.data!;

                      for (var beratItem in keranjangDonasi) {
                        beratKeseluruhan += beratItem['berat_total'];
                      }

                      return Column(children: [
                        ...keranjangDonasi
                            .map(
                              (item) => Dismissible(
                                onDismissed: (direction) async {
                                  await supabase
                                      .from("keranjang_donasi")
                                      .delete()
                                      .eq("id", item['id']);
                                },
                                confirmDismiss: (direction) {
                                  return showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Konfirmasi"),
                                      content: const Text(
                                          "Apakah anda yakin ingin menghapus item ini?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: const Text("Tidak"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text("Ya"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                key: UniqueKey(),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            FutureBuilder(
                                              future: namaJenisElektronik(
                                                  item['id_jenis_elektronik']),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
                                                }
                                                final namaJenisElektronik =
                                                    snapshot.data!;
                                                return GetSvgWidget(
                                                  fileName: namaJenisElektronik,
                                                );
                                              },
                                            ),
                                            const SizedBox(width: 10),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FutureBuilder(
                                                  future: namaJenisElektronik(
                                                      item[
                                                          'id_jenis_elektronik']),
                                                  builder: (context, snapshot) {
                                                    if (!snapshot.hasData) {
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }
                                                    final namaJenisElektronik =
                                                        snapshot.data!;
                                                    return Text(
                                                      namaJenisElektronik,
                                                      style: const TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    );
                                                  },
                                                ),
                                                Text(item['kategorisasi'] !=
                                                        null
                                                    ? "Jenis: ${item['kategorisasi'].toString().capitalize()}"
                                                    : ""),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                "Jumlah: ${item['jumlah'].toString()}"),
                                            Text(
                                                "${item['berat_total'].toString()} Kg"),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        beratKeseluruhan != 0
                            ? (beratKeseluruhan >= 100
                                ? Text(
                                    "Total berat: ${beratKeseluruhan.toString()} Kg, Berat keseluruhan melebihi batas, sampah anda akan dijemput oleh pengumpul sampah",
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )
                                : Text(
                                    "Total berat: ${beratKeseluruhan.toString()} Kg, Silahkan bawa ke tempat pengumpulan sampah elektronik terdekat",
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ))
                            : const Text('Keranjang kosong'),
                        beratKeseluruhan != 0
                            ? FutureBuilder(
                                future: getTotalBerat(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final totalBerat = snapshot.data!;
                                  return Text(
                                      "Jumlah poin yang akan anda dapatkan: ${totalBerat.toString()}");
                                })
                            : Container(),
                        const SizedBox(height: 20),
                        beratKeseluruhan != 0
                            ? ElevatedButton(
                                onPressed: () {
                                  donasiSampahDiKeranjang(
                                      beratKeseluruhan: beratKeseluruhan);
                                },
                                child: const Text("Buang"),
                              )
                            : ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const MainLayout(
                                          curScreenIndex: 2,
                                        ),
                                      ));
                                },
                                child: const Text("Donasi Sampah Elektronik"),
                              )
                      ]);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            child: SizedBox(
              width: width,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Untuk memastikan poin reward tercatat, anda diminta untuk melengkapi data alamat dengan melakukkan edit profile",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Future<String> namaJenisElektronik(int idJenisElektronik) async {
  final jenisElektronik = await supabase
      .from("jenis_elektronik")
      .select("jenis")
      .eq("id", idJenisElektronik)
      .single();
  return jenisElektronik['jenis'];
}

Future<num> hitungBeratKeseluruhan(
  List<Map<String, dynamic>> keranjangDonasi,
) async {
  print(keranjangDonasi);
  num beratKeseluruhan = 0;
  for (var item in keranjangDonasi) {
    print(item);
    num beratSementara = await beratJenisElektronik(
      idJenisElektronik: item['id_jenis_elektronik'],
    );
    print(beratSementara);
    beratKeseluruhan += item['jumlah'] * beratSementara;
  }
  return beratKeseluruhan;
}

Future<num> getTotalBerat() async {
  final keranjangBuang = await supabase
      .from("keranjang_donasi")
      .select()
      .eq("id_user", supabase.auth.currentUser?.id as Object);
  num beratKeseluruhan = 0;
  for (var item in keranjangBuang) {
    beratKeseluruhan += item['jumlah'];
  }
  return beratKeseluruhan;
}
