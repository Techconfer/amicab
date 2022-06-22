import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/util.dart';

class DrawerListTile extends StatelessWidget {
  String _title;
  String _icon;
  Function _function;

  DrawerListTile(this._title, this._icon, this._function);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _function.call(),
      child: Container(
        margin: EdgeInsets.all(10),
        child: Row(
          children: [
            Neumorphic(
                style: NeumorphicStyle(color: HexColor("#E3EDF7")),
                child: Container(
                    padding: EdgeInsets.all(10),
                    child: SvgPicture.asset(
                      _icon,
                      height: 25,
                      width: 25,
                    ))),
            SizedBox(
              width: 20,
            ),
            Text(_title,
                style: GoogleFonts.poppins(
                    fontSize: 13, color: HexColor("#8B9EB0")))
          ],
        ),
      ),
    );
  }
}