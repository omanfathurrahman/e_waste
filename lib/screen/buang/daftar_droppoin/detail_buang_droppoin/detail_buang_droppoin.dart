import 'package:ewaste/main.dart';
import 'package:ewaste/screen/buang/keranjang/keranjang_buang.dart';
import 'package:ewaste/screen/default.dart';
import 'package:ewaste/screen/main_layout.dart';
import 'package:flutter/material.dart';

class DetailBuangDroppoin extends StatefulWidget {
  const DetailBuangDroppoin({super.key, required this.droppoinId});
  final num droppoinId;

  @override
  State<DetailBuangDroppoin> createState() => _DetailBuangDroppoinState();
}

class _DetailBuangDroppoinState extends State<DetailBuangDroppoin> {
  @override
  initState() {
    _getDroppoinData();
    _getDroppoinMap();
    super.initState();
  }

  Future<Map<String, dynamic>> _getDroppoinData() async {
    final droppoin = await supabase
        .from('daftar_droppoin')
        .select()
        .eq('id', widget.droppoinId)
        .single()
        .limit(1);

    return droppoin;
  }

  Future<String> _getDroppoinMap() async {
    final res = supabase.storage
        .from('peta_droppoin')
        .getPublicUrl('${widget.droppoinId}.png');
    return res;
  }

  Future<void> _buangKeDroppoin({required num droppoinId}) async {
    print(droppoinId);
    final keranjangBuang = await supabase
        .from("keranjang_buang")
        .select()
        .eq("id_user", supabase.auth.currentUser?.id as Object);

    await supabase.from("sampah_dibuang").insert({
      "id_user": supabase.auth.currentUser?.id as Object,
      "droppoin_id": droppoinId,
      "pilihan_antar_jemput": 'diantar',
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
        content: Text("Silahkan bawa ke drop poin tersebut"),
      ),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MainLayout(curScreenIndex: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDroppoinData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        final droppoinData = snapshot.data!;
        return Default(
            child: ListView(
          children: [
            const KomponenHeader(),
            Text(droppoinData['nama']),
            FutureBuilder(
              future: _getDroppoinMap(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final mapUrl = snapshot.data!;
                return Image.network(mapUrl);
              },
            ),
            ElevatedButton(
              onPressed: () {
                _buangKeDroppoin(droppoinId: widget.droppoinId);
              },
              child: const Text("Bawa ke drop poin"),
            )
          ],
        ));
      },
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
                builder: (context) => const KeranjangBuang(),
              ),
            );
          },
        ),
        // const Text(
        //   "Keranjang Buang",
        //   style: TextStyle(
        //       fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
        // ),
      ],
    );
  }
}
