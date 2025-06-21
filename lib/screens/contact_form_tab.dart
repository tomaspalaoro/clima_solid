import 'package:clima_solid/models/contact_model.dart';
import 'package:clima_solid/services/contact_service.dart';
import 'package:clima_solid/validators/contact_validator.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class ContactFormTab extends StatefulWidget {
  final ContactService contactService;

  const ContactFormTab({super.key, required this.contactService});

  @override
  State<ContactFormTab> createState() => _ContactFormTabState();
}

class _ContactFormTabState extends State<ContactFormTab> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  DateTime? _selectedDate;

  bool _isFormFilled = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl.addListener(_onFieldChanged);
    _dateCtrl.addListener(_onFieldChanged);
    _cityCtrl.addListener(_onFieldChanged);
    _emailCtrl.addListener(_onFieldChanged);
    _phoneCtrl.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final filled =
        _nameCtrl.text.isNotEmpty &&
        _selectedDate != null &&
        _cityCtrl.text.isNotEmpty &&
        _emailCtrl.text.isNotEmpty &&
        _phoneCtrl.text.isNotEmpty;
    if (filled != _isFormFilled) {
      setState(() => _isFormFilled = filled);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _dateCtrl.dispose();
    _cityCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      _selectedDate = picked;
      _dateCtrl.text = DateFormat.yMMMd(
        context.locale.toString(),
      ).format(picked);
      //
      _onFieldChanged();
    }
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final contact = Contact(
        name: _nameCtrl.text.trim(),
        birthDate: _selectedDate!,
        city: _cityCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        phone: _phoneCtrl.text.trim(),
      );
      await widget.contactService.send(contact);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(tr('sent_success'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(labelText: tr('contact_name')),
                  validator: ContactValidator.validateName,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dateCtrl,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: tr('contact_birthdate'),
                  ),
                  onTap: _pickDate,
                  validator:
                      (_) => ContactValidator.validateBirthDate(_selectedDate),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _cityCtrl,
                  decoration: InputDecoration(labelText: tr('contact_city')),
                  validator: ContactValidator.validateCity,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: tr('contact_email')),
                  validator: ContactValidator.validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: tr('contact_phone')),
                  validator: ContactValidator.validatePhone,
                ),
              ],
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _isFormFilled ? _submit : null,
              child: Text(tr('send')),
            ),
          ],
        ),
      ),
    );
  }
}
