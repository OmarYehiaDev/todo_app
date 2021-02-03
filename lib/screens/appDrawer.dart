import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_share/social_share.dart';
import 'package:todo_app/utils/appLang.dart';
import 'package:todo_app/utils/appLocals.dart';
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
    var appLanguage = Provider.of<AppLanguage>(context);
    var appLocale = AppLocalizations.of(context);
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
                  ListTile(
                    title: Text(
                      appLocale.translateMore("settings", "lang"),
                    ),
                    leading: Icon(Icons.language),
                    onTap: () {
                      appLanguage.changeLanguage();
                    },
                  ),
                  ListTile(
                    title: Text(
                      appLocale.translate("about"),
                    ),
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
                            appLocale.translate("rights"),
                          ),
                        ],
                      );
                    },
                  ),
                  ListTile(
                    title: Text(
                      appLocale.translate("share"),
                    ),
                    leading: Icon(Icons.share),
                    onTap: () {
                      SocialShare.shareOptions(
                        appLocale.translate("shareText"),
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
