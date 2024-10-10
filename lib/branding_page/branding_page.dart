import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BrandingPage extends StatefulWidget {
  final String streamUrl;
  final VoidCallback onContinue;

  const BrandingPage(
      {super.key,
      required this.streamUrl,
      required this.onContinue,
      required String matchDate,
      required String videoUrl,
      required String team1Name,
      required String team2Name,
      Uri? url});

  @override
  _BrandingPageState createState() => _BrandingPageState();
}

class _BrandingPageState extends State<BrandingPage> {
  Timer? _timer;
  int _remainingSeconds = 3; // Duration before auto-navigation in seconds

  void _launchUrl(Uri uri, bool inApp) async {
    try {
      if (await canLaunchUrl(uri)) {
        if (inApp) {
          await launchUrl(uri, mode: LaunchMode.inAppWebView);
        } else {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialize the timer to countdown and navigate automatically
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        _timer?.cancel();
        widget.onContinue();
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _launchUrl(
                        Uri.parse(
                            'https://msng.link/o?Goart555mix=tg&09422081701=vi'),
                        false);
                  },
                  child: Image.asset(
                    'assets/branding_image.png',
                    width: 500,
                    height: 500,
                  ),
                ), // Replace with your branding image
                const SizedBox(height: 20),
                // const Text(
                //   'Welcome to Our Channel!',
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 24,
                //       fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(height: 20),
                const CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
                const SizedBox(height: 20),
                Text(
                  'Redirecting in $_remainingSeconds seconds...',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ],
            ),
          ),
          // Positioned(
          //   top: 16,
          //   right: 16,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       _timer?.cancel(); // Stop the timer if the button is pressed
          //       widget.onContinue(); // Navigate to the TV Channel Player
          //     },
          //     child: Text('Skip'),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.deepPurple,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(8)),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
