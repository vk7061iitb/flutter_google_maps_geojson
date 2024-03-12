import 'package:flutter/material.dart';

class SampleModalBottomSheet extends StatelessWidget {
  const SampleModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.add_road_outlined),
            title: const Text('Road ID'),
            onTap: () {
              // Handle the tap on "Photos"
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.speed_outlined),
            title: const Text('Avg. Speed'),
            onTap: () {
              // Handle the tap on "Music"
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on),
            title: const Text('Total Lenght'),
            onTap: () {
              // Handle the tap on "Videos"
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
