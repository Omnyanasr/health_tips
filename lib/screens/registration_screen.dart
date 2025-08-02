import 'package:flutter/material.dart';
import '../controller/registration_controller.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _ageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _selectedGoal = 'Weight Loss';
  bool _isLoading = false;

  final RegistrationController _controller = RegistrationController();

  @override
  void dispose() {
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String uid = 'user123'; // Replace with real UID in your app auth
      int age = int.parse(_ageController.text);

      String message = await _controller.registerUser(age, _selectedGoal, uid);

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Registration failed: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("Get Health Tips"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(minHeight: 500),
                  padding: const EdgeInsets.all(32.0),
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Personalize Tips",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 40),
                          TextFormField(
                            controller: _ageController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Age',
                              border: OutlineInputBorder(),
                              filled: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your age';
                              }
                              final age = int.tryParse(value);
                              if (age == null || age <= 0) {
                                return 'Enter a valid age';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 32),
                          DropdownButtonFormField<String>(
                            value: _selectedGoal,
                            decoration: const InputDecoration(
                              labelText: 'Fitness Goal',
                              border: OutlineInputBorder(),
                              filled: true,
                            ),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() => _selectedGoal = newValue);
                              }
                            },
                            items:
                                <String>[
                                      'Weight Loss',
                                      'Muscle Gain',
                                      'Maintain Health',
                                    ]
                                    .map(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          ),
                                    )
                                    .toList(),
                          ),
                          const SizedBox(height: 48),
                          SizedBox(
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                              onPressed: _isLoading ? null : _registerUser,
                              child:
                                  _isLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text("Get My Health Tip"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black.withAlpha(128),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
