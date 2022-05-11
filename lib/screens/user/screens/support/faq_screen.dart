import 'package:aim_cab/screens/common/custom_appbar.dart';
import 'package:aim_cab/screens/user/screens/support/left_item_tell_more_screen.dart';
import 'package:aim_cab/utils/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({Key key}) : super(key: key);

  final List<String> accountFaqOptions = [
    'Unblock account',
    'Change phone number',
    'Privacy information'
  ];
  final List<String> paymentPricingOptions = [
    'Accepted payment methods',
    'Price estimation',
    'Ride cancellation fee',
    'Damage or cleaning fee',
    'Price higher than expected'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppbar(title: 'FAQ\'s'),
      body: Container(
        padding: EdgeInsets.only(top: 40, left: 30, right: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: HexColor('#3E4958'),
                ),
              ),
              SizedBox(height: 20),
              ...List.generate(
                accountFaqOptions.length,
                (index) => supportItem(
                  text: '${accountFaqOptions[index]}',
                  onTap: () {
                    if (index == 0) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LeftItemTellMoreScreen()),
                      );
                    } else if (index == 1) {}
                  },
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Payment and pricing',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: HexColor('#3E4958'),
                ),
              ),
              SizedBox(height: 20),
              ...List.generate(
                paymentPricingOptions.length,
                (index) => supportItem(text: '${paymentPricingOptions[index]}'),
              ),
            ],
          ),
        ),
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
