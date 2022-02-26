import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;
  Future<void> _getUserCurrentLocation() async {
    final locData = await Location().getLocation();
    print(locData.latitude);
    print(locData.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 170,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
        ),
        child: _previewImageUrl == null
            ? const Text(
                'No Location Chosen',
                textAlign: TextAlign.center,
              )
            : Image.network(
                _previewImageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton.icon(
            icon: const Icon(Icons.location_on),
            onPressed: _getUserCurrentLocation,
            label: const Text('Current Location'),
            textColor: Theme.of(context).primaryColor,
          ),
          FlatButton.icon(
            icon: const Icon(Icons.map),
            onPressed: () {},
            label: const Text('Select on Map'),
            textColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
    ]);
  }
}
