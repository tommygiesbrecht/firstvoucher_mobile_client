import 'package:firstvoucher_mobile_client/core/env.dart';
import 'package:firstvoucher_mobile_client/voucher_create/vocher_create_widget.dart';
import 'package:firstvoucher_mobile_client/voucher_list/vocher_list_widget.dart';
import 'package:firstvoucher_mobile_client/voucher_search/vocher_search_widget.dart';
import 'package:flutter/material.dart';

import 'core/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await Environment.setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Environment.APP_NAME,
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: HomeWidget(title: Environment.APP_NAME),
    );
  }
}

class HomeWidget extends StatefulWidget {
  HomeWidget({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {

  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    VoucherSearchWidget(),
    VoucherListWidget(),
    VoucherCreateWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body:  Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            label: 'Einlösen',
            icon: Icon(Icons.qr_code_scanner_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Gutscheine',
            icon: Icon(Icons.redeem),
          ),
          BottomNavigationBarItem(
            label: 'Erstellen',
            icon: Icon(Icons.add_circle_outline),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
