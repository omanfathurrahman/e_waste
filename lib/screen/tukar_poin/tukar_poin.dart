import 'package:ewaste/main.dart';
import 'package:ewaste/screen/default.dart';
import 'package:ewaste/utils/get_daftar_hadiah.dart';
import 'package:ewaste/utils/get_jumlah_poin.dart';
import 'package:ewaste/utils/get_user.dart';
import 'package:flutter/material.dart';

class TukarPoinScreen extends StatefulWidget {
  const TukarPoinScreen({super.key});

  @override
  State<TukarPoinScreen> createState() => _TukarPoinScreenState();
}

class _TukarPoinScreenState extends State<TukarPoinScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> _tukarPoin(BuildContext context, num jumlahPoin) async {
    final id = await getUserId();
    final poinUser = await getJumlahPoin();

    if (!mounted) return;

    if (jumlahPoin > poinUser) {
      return showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Tukar Poin"),
            content:
                const Text("Poin anda tidak cukup untuk menukar barang ini."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Tutup"),
              ),
            ],
          );
        },
      );
    }

    Future<void> poinDitukar() async {
      final poinAkhir = poinUser - jumlahPoin;

      // print(poinAkhir);

      await supabase.from('profile').update({
        'jumlah_poin': poinAkhir,
      }).eq('id', id);

      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Poin berhasil ditukar."),
        ),
      );
      Navigator.pop(context);
    }

    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tukar Poin"),
          content: const Text("Apakah anda yakin ingin menukar poin?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                poinDitukar();
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Default(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        backgroundColor: Colors.transparent,
        title: const Text(
          "Tukar Poin",
          style: TextStyle(color: Colors.white),
        ),
      ),
      child: ListView(
        children: [
          Card(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: FutureBuilder(
              future: getJumlahPoin(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                final jumlahPoin = snapshot.data as num;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Jumlah Poin saat ini: $jumlahPoin"),
                );
              },
            ),
          ),
          Card(
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                const Text('Daftar Barang yang bisa ditukar:'),
                FutureBuilder(
                  future: getDaftarHadiah(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    final daftarHadiah =
                        snapshot.data as List<Map<String, dynamic>>;
                    return Column(
                      children: daftarHadiah
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: ListTile(
                                  shape: ContinuousRectangleBorder(
                                    side: const BorderSide(
                                        color: Colors.black12, width: 1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(
                                    e['nama'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                      "${e['jumlah_poin'].toString()} Poin"),
                                  trailing: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        const Color.fromARGB(
                                            255, 209, 194, 252),
                                      ),
                                    ),
                                    onPressed: () {
                                      _tukarPoin(context, e['jumlah_poin']);
                                    },
                                    child: const Text('Tukar'),
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  },
                )
              ]),
            ),
          )
        ],
      ),
    );
  }
}
