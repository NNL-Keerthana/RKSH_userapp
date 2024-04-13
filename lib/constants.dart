import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  static const baseUrl =
      "http://user-hospital-app-dev.ap-south-1.elasticbeanstalk.com/user";

  static const img = Padding(
    padding: EdgeInsets.only(left: 8),
    child: Image(
      image: AssetImage("assets/RKSH_logo_transparent.png"),
      fit: BoxFit.contain,
    ),
  );
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? titleText;
  const CustomAppBar(this.titleText, {super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(
          widget.titleText!,
          textScaleFactor: 1.2,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Constants.img,
        leadingWidth: 80,
        toolbarHeight: kToolbarHeight + 20,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color.fromRGBO(0, 0, 0, 0.3),
          // systemNavigationBarColor: Colors.transparent,
          systemNavigationBarColor: Color.fromRGBO(83, 83, 83, 1),
        ));
  }
}
