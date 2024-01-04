import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconWidget extends StatelessWidget {
  const IconWidget( this.assetName ,{super.key});
  final String assetName;

  String setAssetUrl(String assetName) {
    return 'assets/icons/$assetName.svg';
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      setAssetUrl(assetName),
    );
  }
}
