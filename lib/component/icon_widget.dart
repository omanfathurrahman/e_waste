import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconWidget extends StatelessWidget {
  const IconWidget(this._assetName,
      {super.key, this.color = Colors.grey, this.panjang = 18});
  final String _assetName;
  final Color color;
  final double panjang;

  String setAssetUrl(String assetName) {
    return 'assets/icons/$assetName.svg';
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      setAssetUrl(_assetName),
      width: panjang,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }
}
