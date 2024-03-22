import 'package:ewaste/main.dart';
import 'package:ewaste/screen/buang/daftar_droppoin/detail_buang_droppoin/detail_buang_droppoin.dart';
import 'package:ewaste/screen/buang/keranjang/keranjang_buang.dart';
import 'package:ewaste/screen/default.dart';
import 'package:flutter/material.dart';

class DaftarDroppoinBuang extends StatefulWidget {
  const DaftarDroppoinBuang({super.key, required this.alamatId});
  final num alamatId;

  @override
  State<DaftarDroppoinBuang> createState() => _DaftarDroppoinStateBuang();
}

class _DaftarDroppoinStateBuang extends State<DaftarDroppoinBuang> {
  Future<void> _buangKeDroppoin({required num droppoinId}) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailBuangDroppoin(droppoinId: droppoinId),
        ));
    // print(droppoinId);
    // final keranjangBuang = await supabase
    //       .from("keranjang_buang")
    //       .select()
    //       .eq("id_user", supabase.auth.currentUser?.id as Object);

    //   await supabase.from("sampah_dibuang").insert({
    //     "id_user": supabase.auth.currentUser?.id as Object,
    //     "droppoin_id": droppoinId,
    //     "pilihan_antar_jemput": 'diantar',
    //   });
    //   final idSampahDibuangBaru = await supabase
    //       .from("sampah_dibuang")
    //       .select()
    //       .order("id", ascending: false)
    //       .limit(1)
    //       .single();
    //   for (var item in keranjangBuang) {
    //     await supabase.from("detail_sampah_dibuang").insert([
    //       {
    //         "id_jenis_elektronik": item['id_jenis_elektronik'],
    //         "jumlah": item['jumlah'],
    //         "kategorisasi": item['kategorisasi'],
    //         "id_sampah_dibuang": idSampahDibuangBaru['id'],
    //       }
    //     ]);
    //   }
    //   await supabase
    //       .from("keranjang_buang")
    //       .delete()
    //       .eq("id_user", supabase.auth.currentUser?.id as Object);

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text("Pengumpul barang akan menghubungi anda"),
    //     ),
    //   );
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (context) => const MainLayout(curScreenIndex: 1),
    //     ),
    //   );
  }

  @override
  Widget build(BuildContext context) {
    return Default(
      child: ListView(
        children: [
          const KomponenHeader(),
          const SizedBox(height: 16),
          const Text(
            'Pilih Drop Poin',
            style: TextStyle(color: Colors.white),
          ),
          FutureBuilder(
            future: _getDroppoinList(id: widget.alamatId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final droppoinList = snapshot.data!;
              return Column(
                children: droppoinList
                    .map((droppoin) => GestureDetector(
                          onTap: () {
                            _buangKeDroppoin(droppoinId: droppoin['id']);
                          },
                          child: SizedBox(
                            width: double.infinity,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(droppoin['nama'],
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    Text(droppoin['alamat']),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          )
        ],
      ),
    );
  }
}

Future<List<Map<String, dynamic>>> _getDroppoinList({required num id}) async {
  final response =
      await supabase.from('daftar_droppoin').select().eq('alamat_id', id);
  return response;
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
                builder: (context) => const KeranjangBuang(),
              ),
            );
          },
        ),
        const Text(
          "Keranjang Buang",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
