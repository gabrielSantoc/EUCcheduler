import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:my_schedule/auth/auth.dart';
import 'package:my_schedule/auth/change_password.dart';
import 'package:my_schedule/box/boxes.dart';
import 'package:my_schedule/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_schedule/screens/FAQ.dart';
import 'package:my_schedule/screens/about_dev_screen.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final String? profileImageUrl;
  final VoidCallback onProfileImageChanged;

  const DrawerClass({
    Key? key,
    required this.profileImageUrl,
    required this.onProfileImageChanged,
  }) : super(key: key);

  Future<void> pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName =
          '${boxUserCredentials.get('userId')}_${path.basename(file.path)}';

      // Delete existing profile picture if there's one
      String? oldFilePath = boxUserCredentials.get("filePath");
      if (oldFilePath != null) {
        await Supabase.instance.client.storage
            .from('profile_pictures')
            .remove([oldFilePath]);
      }

      // Upload new image
      await Supabase.instance.client.storage
          .from('profile_pictures')
          .upload(fileName, file);

      // Update file path in tbl_users
      await Supabase.instance.client.from('tbl_users').update({
        'file_path': fileName,
      }).eq('auth_id', boxUserCredentials.get('userId'));

      // Update local storage
      await boxUserCredentials.put("filePath", fileName);

      // Notify parent to reload profile image
      onProfileImageChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Stack(
              alignment: Alignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/play_store_512.png')
                ),
                // CircleAvatar(
                //   radius: 60,
                //   backgroundImage: profileImageUrl != null
                //       ? NetworkImage(profileImageUrl!)
                //       : const AssetImage('assets/images/placeholder.png')
                //           as ImageProvider,
                // ),
                // Positioned(
                //   right: 80,
                //   bottom: 10,
                //   child: GestureDetector(
                //     onTap: pickAndUploadImage,
                //     child: Container(
                //       padding: const EdgeInsets.all(4),
                //       decoration: const BoxDecoration(
                //         color: MAROON,
                //         shape: BoxShape.circle,
                //       ),
                //       child: const Icon(Icons.add, color: Colors.white, size: 20),
                //     ),
                //   ),
                // ),
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
              await supabase.auth.signOut();
              boxUserCredentials.clear();
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