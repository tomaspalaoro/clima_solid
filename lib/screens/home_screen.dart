import 'package:clima_solid/widgets/language_button.dart';
import 'package:clima_solid/screens/city_weather_tab.dart';
import 'package:clima_solid/screens/contact_form_tab.dart';
import 'package:clima_solid/widgets/logout_button.dart';
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
          ..._cities.map((city) => CityWeatherTab(city: city)),
          const ContactFormTab(),
        ],
      ),
    );
  }
}
