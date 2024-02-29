import 'package:ewaste/component/get_svg_widget.dart';
import 'package:ewaste/extention/to_capitalize.dart';
import 'package:ewaste/main.dart';
import 'package:ewaste/screen/buang/bawa_ke_droppoin/bawa_ke_droppoin.dart';
// import 'package:ewaste/screen/donasi/bawa_ke_droppoin/bawa_ke_drop_poin.dart';
import 'package:ewaste/screen/main_layout.dart';
import 'package:ewaste/utils/hitung_berat.dart';
import 'package:flutter/material.dart';

class KeranjangBuang extends StatefulWidget {
  const KeranjangBuang({super.key});

  @override
  State<KeranjangBuang> createState() => _KeranjangBuangState();
}

class _KeranjangBuangState extends State<KeranjangBuang> {
  var daftarKeranjangBuang = supabase
      .from("keranjang_buang")
      .select()
      .eq("id_user", supabase.auth.currentUser?.id as Object);

  Future<void> _buangSampahDiKeranjang({required num beratKeseluruhan}) async {
    if (beratKeseluruhan < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silahkan masukkan alamat anda"),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BawaKeDropPointBuangScreen(),
        ),
      );
    } else {
      final keranjangBuang = await supabase
          .from("keranjang_buang")
          .select()
          .eq("id_user", supabase.auth.currentUser?.id as Object);

      await supabase.from("sampah_dibuang").insert({
        "id_user": supabase.auth.currentUser?.id as Object,
        "pilihan_antar_jemput": beratKeseluruhan > 100 ? 'dijemput' : 'diantar',
      });
      final idSampahDibuangBaru = await supabase
          .from("sampah_dibuang")
          .select()
          .order("id", ascending: false)
          .limit(1)
          .single();
      for (var item in keranjangBuang) {
        await supabase.from("detail_sampah_dibuang").insert([
          {
            "id_jenis_elektronik": item['id_jenis_elektronik'],
            "jumlah": item['jumlah'],
            "kategorisasi": item['kategorisasi'],
            "id_sampah_dibuang": idSampahDibuangBaru['id'],
          }
        ]);
      }
      await supabase
          .from("keranjang_buang")
          .delete()
          .eq("id_user", supabase.auth.currentUser?.id as Object);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Pengumpul barang akan menghubungi anda"),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const MainLayout(curScreenIndex: 1),
        ),
      );
    }
    setState(() {
      daftarKeranjangBuang = supabase
          .from("keranjang_buang")
          .select()
          .eq("id_user", supabase.auth.currentUser?.id as Object);
    });
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
                                curScreenIndex: 1,
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
                    future: daftarKeranjangBuang,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      num beratKeseluruhan = 0;
                      final keranjangBuang = snapshot.data!;

                      for (var beratItem in keranjangBuang) {
                        beratKeseluruhan += beratItem['berat_total'];
                      }

                      return Column(
                        children: [
                          ...keranjangBuang
                              .map(
                                (item) => Dismissible(
                                  onDismissed: (direction) async {
                                    await supabase
                                        .from("keranjang_buang")
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
                                                  return GetSvgWidget(
                                                    fileName:
                                                        namaJenisElektronik,
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
                                                    builder:
                                                        (context, snapshot) {
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
                                                                FontWeight
                                                                    .w500),
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  : Text(
                                      "Total berat: ${beratKeseluruhan.toString()} Kg, Silahkan bawa ke tempat pengumpulan sampah elektronik terdekat",
                                      style:
                                          const TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ))
                              : const Text('Keranjang kosong'),
                          beratKeseluruhan != 0
                              ? FutureBuilder(
                                  future: _getTotalJumlah(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                    final totalJumlah = snapshot.data!;
                                    return Text(
                                        "Jumlah poin yang akan anda dapatkan: ${totalJumlah.toString()}");
                                  })
                              : Container(),
                          const SizedBox(height: 20),
                          beratKeseluruhan != 0
                              ? ElevatedButton(
                                  onPressed: () {
                                    _buangSampahDiKeranjang(
                                        beratKeseluruhan: beratKeseluruhan);
                                  },
                                  child: const Text("Buang"),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MainLayout(
                                            curScreenIndex: 1,
                                          ),
                                        ));
                                  },
                                  child: const Text("Buang Sampah Elektronik"),
                                )
                        ],
                      );
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
  List<Map<String, dynamic>> keranjangBuang,
) async {
  print(keranjangBuang);
  num beratKeseluruhan = 0;
  for (var item in keranjangBuang) {
    num beratSementara = await beratJenisElektronik(
      idJenisElektronik: item['id_jenis_elektronik'],
    );
    beratKeseluruhan += item['jumlah'] * beratSementara;
  }
  return beratKeseluruhan;
}

Future<num> _getTotalJumlah() async {
  final keranjangBuang = await supabase
      .from("keranjang_buang")
      .select()
      .eq("id_user", supabase.auth.currentUser?.id as Object);
  num jumlahKeseluruhan = 0;
  for (var item in keranjangBuang) {
    jumlahKeseluruhan += item['jumlah'];
  }
  return jumlahKeseluruhan;
}
