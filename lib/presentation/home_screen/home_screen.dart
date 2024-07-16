import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/home_screen/bloc/home_bloc.dart';
import 'package:osama_hasan_progress_soft/presentation/home_screen/tabs/home_tab.dart';
import 'package:osama_hasan_progress_soft/presentation/home_screen/tabs/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home_screen'.tr()),
        backgroundColor: Colors.indigo.shade700,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          HomeTab(),
          ProfileTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home, size: 40),
            label: 'home'.tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person, size: 40),
            label: 'profile'.tr(),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo.shade700,
        onTap: _onItemTapped,
      ),
    );
  }
}
