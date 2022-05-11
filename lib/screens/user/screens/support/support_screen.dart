import 'package:aim_cab/screens/user/screens/support/faq_screen.dart';
import 'package:aim_cab/utils/ScreenHelper.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: Screen.height(context) * 0.6,
            alignment: Alignment.topCenter,
            child: Container(
              width: Screen.width(context),
              height: Screen.height(context) * 0.4,
              color: HexColor('#1B4670'),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).viewPadding.top + 20),
                  Text(
                    'Support',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 10,
            clipBehavior: Clip.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              width: Screen.width(context) * 0.85,
              // height: Screen.height(context) * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  supportItem(
                    text: 'Frequently asked question',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => FaqScreen()),
                      );
                    },
                  ),
                  supportItem(text: 'Your Support Tickets'),
                  supportItem(
                    text: 'Contact us',
                    showDivider: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget supportItem(
      {String text = '', bool showDivider = true, void Function() onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: HexColor('#4B545A'),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: HexColor('#97ADB6'),
                )
              ],
            ),
            SizedBox(height: 14),
            showDivider
                ? Divider(
                    color: HexColor('#D5DDE0'),
                    thickness: 1.2,
                  )
                : SizedBox(height: 0)
          ],
        ),
      ),
    );
  }
}
