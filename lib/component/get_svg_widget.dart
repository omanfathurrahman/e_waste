import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetSvgWidget extends StatelessWidget {
  const GetSvgWidget({super.key, required this.fileName});
  final String fileName;

  Future<Widget> getSvg() async {
    final response = await Supabase.instance.client.storage
        .from('jenis_elektronik')
        .download('$fileName.svg');

    final String svgString = String.fromCharCodes(response);
    return SvgPicture.string(
      svgString,
      height: 30,
      width: 30,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSvg(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return snapshot.data as Widget;
      },
    );
  }
}
