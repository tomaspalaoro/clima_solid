import 'package:clima_solid/language_button.dart';
import 'package:clima_solid/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  final List<String> _cities = ['Londres', 'Toronto', 'Singapur'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _cities.length + 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [LanguageButton(), LogoutButton()],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            ..._cities.map((city) => Tab(text: city)),
            Tab(text: tr('contact')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ..._cities.map((city) => CityWeatherTab(city: city, language: 'en')),
          const ContactFormTab(),
        ],
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
      iconSize: 20,
      onPressed:
          () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false,
          ),
    );
  }
}

class CityWeatherTab extends StatelessWidget {
  final String city;
  final String language;

  const CityWeatherTab({required this.city, required this.language, super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

class ContactFormTab extends StatelessWidget {
  const ContactFormTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}
