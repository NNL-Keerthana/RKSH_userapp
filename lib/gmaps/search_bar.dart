import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_for_flutter/google_places_for_flutter.dart';

class PlaceSearchBar extends StatelessWidget {
  const PlaceSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SearchGooglePlacesWidget(
      placeType: PlaceType.establishment,
      placeholder: 'Enter the hospital',
      apiKey: dotenv.get('GOOGLE_MAPS_API_KEY'),
      onSearch: (Place place) {},
      onSelected: (Place? place) async {
        if (place != null) {
          await Future.delayed(const Duration(milliseconds: 100));
          // Navigator.of(context).pop();
        }
      },

      // location: currLocation,
      // radius: pow(2,18) as int,
    );
  }
}
