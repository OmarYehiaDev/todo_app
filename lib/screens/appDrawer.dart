import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';
import 'package:todo_app/utils/constants.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Drawer(
      child: SafeArea(
        child: Container(
          height: height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //TODO:- Uncomment these in the right time
                  // ListTile(
                  //   title: Text("Memories"),
                  //   leading: Icon(Icons.restore),
                  // ),
                  // ListTile(
                  //   title: Text("Language"),
                  //   leading: Icon(Icons.language),
                  // ),
                  ListTile(
                    title: Text("About"),
                    leading: Icon(Icons.info),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: appName,
                        applicationVersion: "$version+$buildNumber",
                        applicationIcon: CircleAvatar(
                          backgroundImage:
                              AssetImage("assets/images/to-do-list.png"),
                        ),
                        children: [
                          Text(
                            "All rights reserved to Omar Yehia and © 2021 SpiderDevsTechnologies Inc.",
                          ),
                        ],
                      );
                    },
                  ),
                  ListTile(
                    title: Text("Share with friends"),
                    leading: Icon(Icons.share),
                    onTap: () {
                      SocialShare.shareOptions(
                        "Check out Simple Todo!\n https://play.google.com/store/apps/details?id=com.omar.todo_app",
                      );
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text("Version $version+$buildNumber"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
