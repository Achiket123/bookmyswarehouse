import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GooogleSignInButton extends StatelessWidget {
  const GooogleSignInButton(
      {super.key,
      required this.btnText,
      required this.colors,
      required this.borderColors});
  final String btnText;
  final Color colors, borderColors;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;
    return InkWell(
      onTap: () {
        print('login button pressed');
      },
      child: Container(
        height: height * 0.07,
        width: width * 0.9,
        decoration: BoxDecoration(
            color: colors,
            borderRadius: BorderRadius.circular(81),
            border: Border.all(
              width: 1,
              color: borderColors,
            )),
        child: Row(
          children: [
            Container(
                width: width * 0.1,
                padding: const EdgeInsets.only(left: 15),
                child: Image.asset(
                  'assets/images/Icon.png',
                  height: 24,
                  width: 24,
                  fit: BoxFit.cover,
                )),
            SizedBox(
              width: width * 0.75,
              child: Center(
                child: Text(
                  btnText,
                  style: GoogleFonts.inter(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF475569),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
