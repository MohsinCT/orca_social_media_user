import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final IconButton? leading;
  final dynamic title;
  final String? text;
  final List<Widget>? actions;
  final bool? centerTitle;
  final bool automaticallyImplyleading;
  final Color? backgroundColor;
  const CustomAppbar({
    super.key,
    required this.title,

    this.leading,
    this.actions,
    this.centerTitle,
    this.automaticallyImplyleading = false,
    this.text,
     this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyleading,
      elevation: 20,
      centerTitle: centerTitle,
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
