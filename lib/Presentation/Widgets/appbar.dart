import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0, // Remove the shadow
      title: Text(
        'GeoJSON Data Plotter',
        style: GoogleFonts.inter(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontSize: 30.0,
        ),
      ),
    );
  }
}