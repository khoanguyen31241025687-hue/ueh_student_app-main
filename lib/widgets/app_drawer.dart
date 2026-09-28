import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../helpers/DbUtils.dart';

// Ánh xạ icon_code trong DB sang icon FontAwesome.
const _iconsByCode = <String, FaIconData>{
  'newspaper': FontAwesomeIcons.newspaper,
  'calendarCheck': FontAwesomeIcons.calendarCheck,
  'chartLine': FontAwesomeIcons.chartLine,
  'fingerprint': FontAwesomeIcons.fingerprint,
  'calendarDays': FontAwesomeIcons.calendarDays,
  'clipboardList': FontAwesomeIcons.clipboardList,
  'heartPulse': FontAwesomeIcons.heartPulse,
  'leaf': FontAwesomeIcons.leaf,
  'phone': FontAwesomeIcons.phone,
  'coins': FontAwesomeIcons.coins,
  'solidCircleCheck': FontAwesomeIcons.solidCircleCheck,
};

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late final Future<List<DrawerMenu>> _menusFuture = DbUtils.instance
      .loadDrawerMenus();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<List<DrawerMenu>>(
        future: _menusFuture,
        builder: (context, snapshot) {
          return ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF005F69)),
                child: Center(
                  child: Image(
                    image: AssetImage('assets/images/logo-header.png'),
                  ),
                ),
              ),
              if (snapshot.connectionState != ConnectionState.done)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (snapshot.hasError)
                const ListTile(title: Text('Không tải được menu')),
              for (final menu in snapshot.data ?? const <DrawerMenu>[])
                ListTile(
                  leading: FaIcon(
                    _iconsByCode[menu.iconCode] ?? FontAwesomeIcons.circle,
                    size: 20,
                  ),
                  title: Text(menu.menuName),
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
