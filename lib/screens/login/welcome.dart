import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:userapp/widgets/sign_in_with_google.dart';

import '../../constants.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(''),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.061),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              "assets/welcome.svg",
              fit: BoxFit.cover,
              width: MediaQuery.sizeOf(context).width * 0.87,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Get started",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Let's save lives together",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            ),
            const SignInWithGoogle(),
          ],
        ),
      ),
    );
  }
}
