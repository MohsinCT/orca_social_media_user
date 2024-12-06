import 'package:flutter/material.dart';

import '../../../constants/images.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 6,
      centerTitle: true,
      title: Image.asset(
        AppImages.orcaLogoTrans,
        height: 60,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
