import 'package:clima_solid/services/contact_service.dart';
import 'package:clima_solid/utils/date_formatter.dart';
import 'package:clima_solid/widgets/language_button.dart';
import 'package:clima_solid/views/city_weather_tab.dart';
import 'package:clima_solid/views/contact_form_tab.dart';
import 'package:clima_solid/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clima_solid/models/city_model.dart';
import 'package:clima_solid/repositories/city_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  List<City> _cities = [];

  Locale? _lastLocale;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale;
    if (_lastLocale != locale) {
      _lastLocale = locale;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // Arrancamos vacío y luego cargamos
    context.read<CityRepository>().getSupportedCities().then((cities) {
      setState(() {
        _cities = cities;
        _tabController = TabController(
          length: _cities.length + 1, // +1 para el Contact tab
          vsync: this,
        );
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Mientras no esté cargado, mostramos un loader
    if (_cities.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        // fecha de hoy
        title: Text(
          EasyDateFormatter().format(DateTime.now(), context.locale),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        centerTitle: true,
        actions: [LanguageButton(), LogoutButton()],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            // genera las tabs dinámicamente
            ..._cities.map(
              (c) => Tab(
                text: c.displayName,
                icon: Icon(Icons.location_pin, size: 20),
              ),
            ),
            Tab(text: tr('contact')),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ..._cities.map((c) => CityWeatherTab(city: c.name)),
          ContactFormTab(
            contactService: FakeContactService(),
            dateFormatter: EasyDateFormatter(),
          ),
        ],
      ),
    );
  }
}
