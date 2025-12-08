import 'package:flutter/material.dart';
import 'package:business_card_scanner/core/theme/app_colors.dart';
import 'package:business_card_scanner/features/network/presentation/views/network_screen.dart';
import 'package:business_card_scanner/features/myCard/presentation/views/my_card_screen.dart';
import 'package:business_card_scanner/features/scanner/presentation/views/scan_screen.dart';
import 'package:business_card_scanner/features/tools/presentation/views/tools_screen.dart';
import 'package:business_card_scanner/features/menu/presentation/views/menu_screen.dart';

class DashboardScreen extends StatefulWidget {
  final int initialIndex;

  const DashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const NetworkScreen();
      case 1:
        return const MyCardScreen();
      case 2:
        return const ScanScreen();
      case 3:
        return const ToolsScreen();
      case 4:
        return const MenuScreen();
      default:
        return const NetworkScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPage(_currentIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
        ),
        child: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.gray600,
          showUnselectedLabels: true,
          backgroundColor: Colors.transparent,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.contacts_outlined),
              label: 'Network',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.contact_mail_sharp),
              label: 'My Card',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_outlined),
              label: 'Scan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              label: 'Tools',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu),
              label: 'Menu',
            ),
          ],
        ),
      ),
    );
  }
}
