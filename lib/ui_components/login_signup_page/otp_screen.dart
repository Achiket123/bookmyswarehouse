import 'package:bookmywarehouse/widgets/navigation_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({
    Key? key,
    required this.userName,
    required this.icons,
    required this.emailText,
    required this.colors,
  }) : super(key: key);

  final String emailText, userName;
  final Icon icons;
  final Color colors;

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late TextEditingController _phoneNumberController;
  late OtpFieldController _otpController;
  String btnText = 'Send OTP';
  bool _sendButtonActive = true;
  bool _otpFieldVisible = false; // Track the visibility of the OTP field
  String enteredOtp = ''; // Track the entered OTP
  bool _verifying = false; // Track if verification process is ongoing

  @override
  void initState() {
    super.initState();
    _phoneNumberController = TextEditingController();
    _otpController = OtpFieldController();
  }

  void sendOTP() {
    String phoneNumber = _phoneNumberController.text.trim();
    if (phoneNumber.isEmpty) {
      _showSnackBar('Please enter a phone number');
    } else {
      // Code to send OTP to the provided phone number
      print('OTP sent to: $phoneNumber');
      setState(() {
        btnText = 'Resend OTP';
        _sendButtonActive = false;
        _otpFieldVisible = true; // Show the OTP field after sending OTP
        _showSnackBar('OTP sent. You can resend OTP after 30 seconds.');
      });
      // Start a timer to activate resend button after 30 seconds
      Future.delayed(const Duration(seconds: 30), () {
        setState(() {
          _sendButtonActive = true;
        });
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_arrow_left,
            size: width * 0.1,
            weight: 1.0,
            color: const Color(0xFF1A1E25),
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(
          left: width * 0.05,
          right: width * 0.05,
        ),
        width: width,
        height: height * 0.4,
        child: _verifying
            ? const Center(
                child: SpinKitCircle(
                  color: Colors.blue, // Choose your desired color
                  size: 50.0, // Adjust the size as needed
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    widget.userName,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.02,
                        color: Color(0xFF1A1E25),
                      ),
                    ),
                  ),
                  IntlPhoneField(
                    controller: _phoneNumberController,
                    initialCountryCode: 'IN',
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(16),
                      prefixIcon: widget.icons,
                      hintText: widget.emailText,
                      hintStyle: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.02,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(81),
                      ),
                    ),
                  ),
                  if (_otpFieldVisible) // Display OTP field only if visible
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'OTP',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.02,
                                  color: Color(0xFF1A1E25),
                                ),
                              ),
                            ),
                            OTPTextField(
                              controller: _otpController,
                              length: 5,
                              inputFormatter: [
                                FilteringTextInputFormatter.digitsOnly
                              ], // Ensure numeric input only
                              width: MediaQuery.of(context).size.width,
                              textFieldAlignment: MainAxisAlignment.spaceAround,
                              fieldWidth: 45,
                              fieldStyle: FieldStyle.box,
                              outlineBorderRadius: 15,
                              style: const TextStyle(fontSize: 17),
                              onChanged: (otp) {
                                setState(() {
                                  enteredOtp = otp;
                                });
                              },
                              onCompleted: (otp) {
                                if (kDebugMode) {
                                  print("Completed: $otp");
                                }
                              },
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (enteredOtp.isEmpty) {
                              _showSnackBar('Please enter OTP');
                            } else {
                              setState(() {
                                _verifying = true; // Start verification process
                              });
                              // Simulate verification process with a delay
                              Future.delayed(const Duration(seconds: 2), () {
                                // After verification, navigate to the next page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BottomNavBar(),
                                  ),
                                );
                              });
                            }
                          },
                          child: const Text("Verify"),
                        ),
                      ],
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          print("Floating button was pressed.");
                          btnText = 'Send OTP';
                          _otpController.clear();
                          setState(() {
                            // _sendButtonActive = !_sendButtonActive;
                            _otpFieldVisible = false; // Hide the OTP field
                          });
                        },
                        child: const Text('Clear'),
                      ),
                      ElevatedButton(
                        onPressed: _sendButtonActive ? sendOTP : null,
                        child: Text(btnText),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
