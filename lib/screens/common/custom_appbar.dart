import 'package:aim_cab/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top + 16),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Container(
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: 12,
                            shadowLightColor: Colors.black54,
                            // shadowDarkColor: Colors.black.withOpacity(0.9),
                            surfaceIntensity: 0.1,
                            intensity: 0.5,
                            lightSource: LightSource.bottom,
                            oppositeShadowLightSource: true,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(15),
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.only(
                                left: 18, right: 10, top: 18, bottom: 18),
                            constraints: BoxConstraints(),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 25,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '$title',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: HexColor('#3E4958'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(80),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}

class PrimaryCustomAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const PrimaryCustomAppbar({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).viewPadding.top + 16),
            Stack(
              alignment: Alignment.center,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Container(
                        child: Neumorphic(
                          style: NeumorphicStyle(
                            depth: 12,
                            shadowLightColor: Colors.black54,
                            // shadowDarkColor: Colors.black.withOpacity(0.9),
                            surfaceIntensity: 0.1,
                            intensity: 0.5,
                            lightSource: LightSource.bottom,
                            oppositeShadowLightSource: true,
                            boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(15),
                            ),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.only(
                                left: 18, right: 10, top: 18, bottom: 18),
                            constraints: BoxConstraints(),
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 25,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  '$title',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: HexColor('#1B4670'),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      preferredSize: Size.fromHeight(80),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(80);
}
