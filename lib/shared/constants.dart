import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_schedule/auth/auth.dart';
import 'package:my_schedule/auth/change_password.dart';
import 'package:my_schedule/box/boxes.dart';
import 'package:my_schedule/main.dart';
import 'package:my_schedule/screens/FAQ_screen.dart';
import 'package:my_schedule/screens/about_dev_screen.dart';

const MAROON = Color(0xFF862349);
const WHITE = Color(0xFFFFFFFF);
const LIGHTGRAY = Color(0xFFECECEC);
const GRAY = Color(0xFF8F8E8E);
Widget vSpacerWidth(double width) {
  return SizedBox(
    height: width,
  );
}

class SpacerClass extends StatelessWidget {
  const SpacerClass({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}

class LoadingDialog {
  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismissing by tapping outside
      builder: (context) {
        return Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            color: MAROON,
            size: 60,
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop(); // Dismiss the dialog
  }
}

class DrawerClass extends StatelessWidget {


  const DrawerClass({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/play_store_512.png')
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> const ChangePasswordScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About Developers'),
            onTap: () {
             Navigator.push(context, MaterialPageRoute(builder: (context)=> const AboutDev()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_center_rounded),
            title: const Text('FAQ'),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const FAQScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Sign Out'),
            onTap: () async {
              LoadingDialog.showLoading(context);
              await Future.delayed(const Duration(seconds: 2));
              LoadingDialog.hideLoading(context);
              await boxUserCredentials.clear();
              await supabase.auth.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PasswordGuide extends StatelessWidget {
  const PasswordGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric( horizontal: 25.0 ),
      child: Text.rich(
        TextSpan(
          text: 'For new users, ',
          children: <TextSpan>[
            TextSpan(
              text: 'your initial password ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: 'is your birthdate in this format ',
            ),
            TextSpan(
              text: 'YYYY-MM-DD.',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }
}