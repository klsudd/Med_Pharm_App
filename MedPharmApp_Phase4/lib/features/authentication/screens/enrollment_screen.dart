// ============================================================================
// ENROLLMENT SCREEN - SCAFFOLDED FOR STUDENTS
// ============================================================================
// Students: This is the first screen users see.
// The UI layout is provided, but you need to connect it to the Provider.
//
// Your tasks:
// 1. Connect TextField to Provider (update enrollment code as user types)
// 2. Handle "Enroll" button press (call provider method)
// 3. Show loading indicator while enrolling
// 4. Show error messages if enrollment fails
// 5. Navigate to consent screen on success
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

/// EnrollmentScreen - First screen for user enrollment
///
/// This screen allows users to enter their enrollment code
/// and begin the onboarding process.
class EnrollmentScreen extends StatefulWidget {
  const EnrollmentScreen({Key? key}) : super(key: key);

  @override
  State<EnrollmentScreen> createState() => _EnrollmentScreenState();
}

class _EnrollmentScreenState extends State<EnrollmentScreen> {
  // ========================================================================
  // STATE
  // ========================================================================
  // Controller for the text field (manages what user types)
  final TextEditingController _codeController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Always dispose controllers to prevent memory leaks!
    _codeController.dispose();
    super.dispose();
  }

  // ========================================================================
  // TODO 1: HANDLE ENROLLMENT
  // ========================================================================
  /// Handle the "Enroll" button press
  ///
  /// TODO: Implement this method
  /// Steps:
  /// 1. Validate the form using _formKey.currentState!.validate()
  /// 2. If invalid, return early (don't proceed)
  /// 3. Get the AuthProvider using context.read<AuthProvider>()
  /// 4. Call provider.enrollUser() with the enrollment code
  /// 5. After enrollment, check if there's an error
  /// 6. If no error, navigate to consent screen:
  ///    ```dart
  ///    Navigator.pushReplacementNamed(context, '/consent');
  ///    ```
  /// 7. If there's an error, show a SnackBar with the error message
  ///
  /// Example SnackBar:
  /// ```dart
  /// ScaffoldMessenger.of(context).showSnackBar(
  ///   SnackBar(content: Text(errorMessage)),
  /// );
  /// ```
  Future<void> _handleEnrollment() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Get AuthProvider
    final authProvider = context.read<AuthProvider>();

    // Call enrollUser method
    await authProvider.enrollUser(_codeController.text);

    // Check for errors
    if (authProvider.errorMessage != null) {
      // Show error in SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
      return;
    }

    // Navigate to consent screen
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/consent');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ======================================================================
      // APP BAR
      // ======================================================================
      appBar: AppBar(
        title: const Text('Welcome to MedPharm'),
        centerTitle: true,
      ),

      // ======================================================================
      // BODY
      // ======================================================================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==============================================================
                // TITLE & DESCRIPTION
                // ==============================================================
                const Icon(
                  Icons.medical_services,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),

                Text(
                  'Pain Assessment Study',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),

                Text(
                  'Please enter your enrollment code provided by your doctor',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // ==============================================================
                // ENROLLMENT CODE INPUT
                // ==============================================================
                // TODO 2: Connect this TextField to the Provider
                // Hint: Use onChanged callback to update provider
                // Example:
                // onChanged: (value) {
                //   context.read<AuthProvider>().updateEnrollmentCode(value);
                // },
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Enrollment Code',
                    hintText: 'e.g., ABC12345',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.vpn_key),
                  ),
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) {
                    context.read<AuthProvider>().updateEnrollmentCode(value);
                  },

                  // Validation
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an enrollment code';
                    }
                    if (value.length < 8 || value.length > 12) {
                      return 'Code must be 8-12 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // ==============================================================
                // ENROLL BUTTON
                // ==============================================================
                // TODO 3: Show loading indicator when enrolling
                // Hint: Use Consumer<AuthProvider> to watch loading state
                // If provider.isLoading, show CircularProgressIndicator
                // Otherwise show the button
                Consumer<AuthProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ElevatedButton(
                      onPressed: _handleEnrollment,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Text(
                        'Enroll in Study',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // ==============================================================
                // ERROR MESSAGE
                // ==============================================================
                // TODO 4: Show error message if enrollment fails
                // Hint: Use Consumer to watch provider.errorMessage
                // If errorMessage is not null, show it in red text
                Consumer<AuthProvider>(
                  builder: (context, provider, child) {
                    if (provider.errorMessage != null) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          provider.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LEARNING NOTES FOR STUDENTS:
// ============================================================================
//
// 1. What is a StatefulWidget vs StatelessWidget?
//    - StatefulWidget: Has mutable state (can change)
//    - StatelessWidget: Immutable (never changes)
//    - Use StatefulWidget when you need TextControllers or local state
//
// 2. What is a TextEditingController?
//    - Manages the text in a TextField
//    - Allows you to get/set the current text
//    - Must be disposed in dispose() to prevent memory leaks!
//
// 3. What is Form and FormKey?
//    - Form: Widget that contains TextFormFields
//    - GlobalKey<FormState>: Allows you to validate all fields at once
//    - validator: Function that checks if input is valid
//
// 4. What is Consumer<AuthProvider>?
//    - Widget that listens to AuthProvider changes
//    - Rebuilds when provider calls notifyListeners()
//    - Use it when you need to show provider data in UI
//
// 5. What's the difference between context.read() and context.watch()?
//    - context.read(): Get provider without listening (for calling methods)
//    - context.watch(): Get provider and listen for changes (rebuilds widget)
//    - Use read() for buttons, watch() for displaying data
//
// 6. What is Navigator.pushReplacementNamed()?
//    - Navigates to a new screen and removes current screen from stack
//    - User can't go back to enrollment screen after enrolling
//    - Different from Navigator.push() which keeps current screen in stack
//
// 7. What is SafeArea?
//    - Ensures content isn't hidden by system UI (notch, status bar, etc.)
//    - Always wrap your scaffold body in SafeArea for better UX
//
// 8. Why use const?
//    - const widgets are created once and reused
//    - Improves performance
//    - Use const whenever the widget doesn't change
//
// ============================================================================
