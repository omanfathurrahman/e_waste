import 'package:e_waste/component/get_svg_widget.dart';
import 'package:e_waste/extention/to_capitalize.dart';
import 'package:e_waste/main.dart';
import 'package:e_waste/screen/donasi/bawa_ke_droppoint/bawa_ke_drop_point.dart';
import 'package:e_waste/utils/hitung_berat.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KeranjangBuang extends StatefulWidget {
  const KeranjangBuang({super.key});

  @override
  State<KeranjangBuang> createState() => _KeranjangBuangState();
}

class _KeranjangBuangState extends State<KeranjangBuang> {
  var daftarKeranjangBuang = Supabase.instance.client
      .from("keranjang_buang")
      .select()
      .eq("id_user", Supabase.instance.client.auth.currentUser?.id as Object);

  void buangSampahDiKeranjang({required num beratKeseluruhan}) async {
    final keranjangBuang = await Supabase.instance.client
        .from("keranjang_buang")
        .select()
        .eq("id_user", Supabase.instance.client.auth.currentUser?.id as Object);

    await Supabase.instance.client.from("sampah_dibuang").insert(
        {"id_user": Supabase.instance.client.auth.currentUser?.id as Object});
    final idSampahDibuangBaru = await Supabase.instance.client
        .from("sampah_dibuang")
        .select()
        .order("id", ascending: false)
        .limit(1)
        .single();
    for (var item in keranjangBuang) {
      await Supabase.instance.client.from("detail_sampah_dibuang").insert([
        {
          "id_jenis_elektronik": item['id_jenis_elektronik'],
          "jumlah": item['jumlah'],
          "kategorisasi": item['kategorisasi'],
          "id_sampah_dibuang": idSampahDibuangBaru['id'],
        }
      ]);
    }
    await Supabase.instance.client
        .from("keranjang_buang")
        .delete()
        .eq("id_user", Supabase.instance.client.auth.currentUser?.id as Object);

    setState(() {
      daftarKeranjangBuang = Supabase.instance.client
          .from("keranjang_buang")
          .select()
          .eq("id_user",
              Supabase.instance.client.auth.currentUser?.id as Object);
    });
    if (beratKeseluruhan < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silahkan masukkan alamat anda"),
        ),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const BawaKeDropPointScreen(),
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
          builder: (context) => const MainLayout(curScreenIndex: 1),
        ),
      );
    }
  }

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
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: ListView(
                children: [
                  Row(
                    children: [
                      BackButton(
                        onPressed: () {
                          Navigator.pop(context);
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
                                    await Supabase.instance.client
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
                              : Text('Keranjang kosong'),
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
                                    buangSampahDiKeranjang(
                                        beratKeseluruhan: beratKeseluruhan);
                                  },
                                  child: const Text("Buang"),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MainLayout(
                                            curScreenIndex: 1,
                                          ),
                                        ));
                                  },
                                  child: Text("Buang Sampah Elektronik"),
                                )
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> namaJenisElektronik(int idJenisElektronik) async {
  final jenisElektronik = await Supabase.instance.client
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
  final keranjangBuang = await Supabase.instance.client
      .from("keranjang_buang")
      .select()
      .eq("id_user", Supabase.instance.client.auth.currentUser?.id as Object);
  num beratKeseluruhan = 0;
  for (var item in keranjangBuang) {
    beratKeseluruhan += item['jumlah'];
  }
  return beratKeseluruhan;
}
