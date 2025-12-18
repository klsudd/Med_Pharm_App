// ============================================================================
// CONSENT SCREEN - TEMPLATE FOR STUDENTS
// ============================================================================
// Students: This screen shows the consent form.
// Much of the UI is provided, but you need to complete the button logic.
//
// Your task:
// 1. Handle "Accept" button press
// 2. Call provider to save consent
// 3. Navigate to tutorial screen
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

/// ConsentScreen - Display and accept informed consent
class ConsentScreen extends StatefulWidget {
  const ConsentScreen({Key? key}) : super(key: key);

  @override
  State<ConsentScreen> createState() => _ConsentScreenState();
}

class _ConsentScreenState extends State<ConsentScreen> {
  // Has user checked the consent checkbox?
  bool _consentChecked = false;

  // ========================================================================
  // TODO: HANDLE CONSENT ACCEPTANCE
  // ========================================================================
  /// Handle the "I Accept" button press
  ///
  /// TODO: Implement this method
  /// Steps:
  /// 1. Get the AuthProvider
  /// 2. Call provider.acceptConsent()
  /// 3. Navigate to tutorial screen (or home if no tutorial):
  ///    Navigator.pushReplacementNamed(context, '/home');
  Future<void> _handleAcceptConsent() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.acceptConsent();

    if (authProvider.errorMessage != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Consent accepted! Welcome to the study.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informed Consent'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Consent text (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Clinical Trial Informed Consent',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Welcome to the MedPharm Pain Assessment Study.\n\n'
                        'This app will collect daily pain assessments to help evaluate '
                        'the effectiveness of Painkiller Forte medication.\n\n'
                        'Your participation is voluntary and you may withdraw at any time.\n\n'
                        'Data collected:\n'
                        '• Daily pain scores\n'
                        '• Assessment completion times\n'
                        '• App usage patterns\n\n'
                        'Your data will be:\n'
                        '• Encrypted and stored securely\n'
                        '• Used only for this research study\n'
                        '• Anonymized in all reports\n\n'
                        'By accepting, you confirm that:\n'
                        '• You have read and understood this consent form\n'
                        '• You agree to participate in this study\n'
                        '• You understand your data will be collected\n\n'
                        'For questions, contact: study@medpharm.com',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Consent checkbox
              Row(
                children: [
                  Checkbox(
                    value: _consentChecked,
                    onChanged: (value) {
                      setState(() {
                        _consentChecked = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'I have read and accept the consent form',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Accept button
              ElevatedButton(
                onPressed: _consentChecked ? _handleAcceptConsent : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('I Accept'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// LEARNING NOTES:
// ============================================================================
//
// 1. What is SingleChildScrollView?
//    - Makes content scrollable if it's too long
//    - Important for consent forms which can be lengthy
//
// 2. Why is button disabled when checkbox unchecked?
//    - onPressed: _consentChecked ? _handleAcceptConsent : null
//    - null means button is disabled
//    - This ensures user must check the box before accepting
//
// 3. What is Expanded?
//    - Takes up all available space in its parent
//    - Used here to make the consent text take most of the screen
//
// ============================================================================
