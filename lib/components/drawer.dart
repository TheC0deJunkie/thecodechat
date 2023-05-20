import 'package:flutter/material.dart';
import 'package:thecodechat/components/list_tile.dart';

class MyDrawer extends StatelessWidget {
  final Function()? onProfile;
  final Function()? onSignOut;
  const MyDrawer({
    super.key,
    required this.onProfile,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              //header
              DrawerHeader(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 64,
                ),
              ),

              // home list tile
              MyListTile(
                text: 'H O M E',
                icon: Icons.home,
                onTap: () => Navigator.pop(context),
              ),

              //profile list tile
              MyListTile(
                text: 'P R O F I L E',
                icon: Icons.person,
                onTap: onProfile,
              ),
            ],
          ),

          //logout list tile
          Padding(
            padding: const EdgeInsets.only(bottom: 25.0),
            child: MyListTile(
              text: "L O G O U T",
              icon: Icons.logout,
              onTap: onSignOut,
            ),
          ),
        ],
      ),
    );
  }
}
