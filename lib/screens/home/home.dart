// import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../../constants.dart';
import 'emergency.dart';
import 'history.dart';
import 'logout.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final Future<LocationData?> _currentLocation;
  // final _bottombarController = NotchBottomBarController(index: 0);
  late int _selectedIndex = 0;
  List<Widget> screens = const [
    EmergencyScreen(),
    Placeholder(),
    HistoryScreen(),
  ];

  List titles = ["Emergency", "", "Trip History"];

  Future<LocationData?> requestLocation() async {
    // Request service
    var serviceEnabled = await Location().serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Location().requestService();
      if (!serviceEnabled) {
        return null;
      }
    }

    //Request permission
    var permissionGranted = await Location().hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await Location().requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    final currentLocation = await Location().getLocation();
    print(currentLocation);
    return currentLocation;
  }

  @override
  void initState() {
    _currentLocation = requestLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titles[_selectedIndex]),
      body: SingleChildScrollView(child: screens[_selectedIndex]),
      extendBody: true,
      // bottomNavigationBar: AnimatedNotchBottomBar(
      //   showShadow: false,
      //   color: const Color.fromRGBO(83, 83, 83, 1),
      //   notchColor: const Color.fromRGBO(115, 141, 214, 1),
      //   bottomBarItems: const [
      //     BottomBarItem(
      //       inActiveItem: Icon(Icons.error_outline, color: Colors.white),
      //       activeItem: Icon(Icons.error, color: Colors.white),
      //     ),
      //     BottomBarItem(
      //       inActiveItem: Icon(Icons.close, color: Colors.white),
      //       activeItem: Icon(Icons.close, color: Colors.white),
      //     ),
      //     BottomBarItem(
      //       inActiveItem: Icon(Icons.my_location_outlined, color: Colors.white),
      //       activeItem: Icon(Icons.my_location_outlined, color: Colors.white),
      //     ),
      //     BottomBarItem(
      //       inActiveItem: Icon(Icons.logout, color: Colors.white),
      //       activeItem: Icon(Icons.logout_outlined, color: Colors.white),
      //     ),
      //   ],
      //   notchBottomBarController: _bottombarController,
      //   onTap: (index) {
      //     if (index == 3) {
      //       logout(context);
      //       _bottombarController.index = _bottombarController.oldIndex!;
      //     } else {
      //       setState(() {
      //         _selectedIndex = index;
      //       });
      //     }
      //   },
      // ),
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorColor: const Color.fromRGBO(115, 141, 214, 1),
        shadowColor: null,
        height: 60,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            selectedIcon: Icon(
              Icons.error,
              color: Colors.white,
            ),
            label: 'Hospital',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            selectedIcon: Icon(
              Icons.close,
              color: Colors.white,
            ),
            label: 'Patient',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.my_location_outlined,
              color: Colors.white,
            ),
            selectedIcon: Icon(
              Icons.my_location,
              color: Colors.white,
            ),
            label: 'History',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
            selectedIcon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            label: 'Logout',
          )
        ],
        onDestinationSelected: (index) {
          if (index == 3) {
            logout(context);
            return;
          }
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
        // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        surfaceTintColor: const Color.fromRGBO(83, 83, 83, 1),
        backgroundColor: const Color.fromRGBO(83, 83, 83, 1),
        animationDuration: const Duration(milliseconds: 1000),
      ),
    );
  }
}
