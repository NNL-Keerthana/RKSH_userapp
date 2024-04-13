import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../widgets/button.dart';
import '../home/home.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  static const routeName = '/additional-details';
  const AdditionalDetailsScreen({super.key});

  @override
  State<AdditionalDetailsScreen> createState() =>
      _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 32);

    return Scaffold(
      appBar: const CustomAppBar('Additional Details'),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.061),
          child: Form(
            child: Column(
              children: [
                gap,
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Vehicle Number",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {},
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                gap,
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Vehicle Model",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                gap,
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "School/College/Company Name",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {},
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                gap,
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Life Insurance No",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {},
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                gap,
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Personal Doctor Contact No",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                gap,
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Mediacal Status",
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                ),
                gap,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomOutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Back",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.indigoAccent,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    CustomFilledButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                      ),
                      onPressed: () => Navigator.of(context)
                          .pushNamedAndRemoveUntil(
                              Home.routeName, (route) => false),
                      child: Text(
                        "Next",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
