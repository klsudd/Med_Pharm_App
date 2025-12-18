// ============================================================================
// VAS ASSESSMENT SCREEN - SCAFFOLDED FOR PHASE 2
// ============================================================================
// Students: This screen collects the VAS (Visual Analog Scale) pain score.
//
// Phase 2 Learning Goals:
// - Receive navigation arguments from previous screen
// - Submit data using Provider
// - Handle loading/error states
// - Navigate based on operation result
//
// Scaffolding Level: 60% (UI provided, logic TODOs)
// ============================================================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/assessment_provider.dart';
import '../../authentication/providers/auth_provider.dart';

/// VAS Assessment Screen - Visual Analog Scale (0-100)
///
/// This screen lets users rate their pain on a scale of 0-100
/// using a continuous slider (more precise than NRS)
class VasAssessmentScreen extends StatefulWidget {
  const VasAssessmentScreen({Key? key}) : super(key: key);

  @override
  State<VasAssessmentScreen> createState() => _VasAssessmentScreenState();
}

class _VasAssessmentScreenState extends State<VasAssessmentScreen> {
  // ========================================================================
  // STATE
  // ========================================================================

  // Current selected VAS score (0-100)
  double _vasScore = 50.0; // Default to middle value

  // NRS score from previous screen (received via navigation)
  int? _nrsScore;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Get NRS score from navigation arguments (only once)
    if (_nrsScore == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map?;
      _nrsScore = args?['nrsScore'] as int?;
    }
  }

  // ========================================================================
  // TODO 1: HANDLE SUBMIT BUTTON
  // ========================================================================

  /// Submit the assessment to the database
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Get the current user's study ID from AuthProvider
  /// 2. Get the AssessmentProvider
  /// 3. Call provider.submitAssessment() with studyId, nrsScore, vasScore
  /// 4. Check if there's an error after submission
  /// 5. If error, show SnackBar with error message
  /// 6. If success, show success SnackBar and navigate to history screen
  ///
  /// Pattern:
  /// ```dart
  /// Future<void> _handleSubmit() async {
  ///   final authProvider = context.read<AuthProvider>();
  ///   final assessmentProvider = context.read<AssessmentProvider>();
  ///
  ///   final studyId = authProvider.currentUser?.studyId;
  ///   if (studyId == null) return;
  ///
  ///   await assessmentProvider.submitAssessment(
  ///     studyId: studyId,
  ///     nrsScore: _nrsScore!,
  ///     vasScore: _vasScore.round(),
  ///   );
  ///
  ///   if (assessmentProvider.errorMessage != null) {
  ///     // Show error
  ///   } else {
  ///     // Show success and navigate
  ///   }
  /// }
  /// ```
  Future<void> _handleSubmit() async {
    final authProvider = context.read<AuthProvider>();
    final assessmentProvider = context.read<AssessmentProvider>();

    final studyId = authProvider.currentUser?.studyId;
    if (studyId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: No user session found'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_nrsScore == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: NRS score not provided'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await assessmentProvider.submitAssessment(
      studyId: studyId,
      nrsScore: _nrsScore!,
      vasScore: _vasScore.round(),
    );

    if (assessmentProvider.errorMessage != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(assessmentProvider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assessment submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacementNamed(context, '/assessment/history');
      }
    }
  }

  // ========================================================================
  // HELPER METHODS (Already implemented)
  // ========================================================================

  /// Get color for the current pain level
  Color _getPainColor() {
    final percentage = _vasScore / 100;
    if (percentage == 0) return Colors.green;
    if (percentage <= 0.3) return Colors.lightGreen;
    if (percentage <= 0.6) return Colors.orange;
    if (percentage <= 0.9) return Colors.deepOrange;
    return Colors.red;
  }

  /// Get description for the current pain level
  String _getPainDescription() {
    final percentage = _vasScore / 100;
    if (percentage == 0) return 'No Pain';
    if (percentage <= 0.3) return 'Mild Pain';
    if (percentage <= 0.6) return 'Moderate Pain';
    if (percentage <= 0.9) return 'Severe Pain';
    return 'Worst Possible Pain';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ======================================================================
      // APP BAR
      // ======================================================================
      appBar: AppBar(
        title: const Text('Pain Assessment - VAS'),
        centerTitle: true,
      ),

      // ======================================================================
      // BODY
      // ======================================================================
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ==============================================================
              // INSTRUCTION
              // ==============================================================
              const Text(
                'Visual Analog Scale',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              const Text(
                'Move the slider to indicate your current pain level.\nThis scale provides more precision than the 0-10 rating.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Show NRS score from previous screen
              if (_nrsScore != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Your NRS score: $_nrsScore/10',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const SizedBox(height: 32),

              // ==============================================================
              // PAIN LEVEL INDICATOR
              // ==============================================================
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _getPainColor().withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _getPainColor(),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _vasScore.round().toString(),
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: _getPainColor(),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getPainDescription(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: _getPainColor(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // ==============================================================
              // SLIDER
              // ==============================================================
              Slider(
                value: _vasScore,
                min: 0,
                max: 100,
                divisions: 100,
                label: _vasScore.round().toString(),
                activeColor: _getPainColor(),
                onChanged: (value) {
                  setState(() {
                    _vasScore = value;
                  });
                },
              ),

              // Scale labels
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0\nNo Pain', textAlign: TextAlign.center),
                  Text('100\nWorst Pain', textAlign: TextAlign.center),
                ],
              ),
              const SizedBox(height: 48),

              // ==============================================================
              // SUBMIT BUTTON
              // ==============================================================
              // TODO 2: Show loading indicator when submitting
              // Hint: Use Consumer<AssessmentProvider> to watch isLoading
              // If provider.isLoading, show CircularProgressIndicator
              // Otherwise show the button
              Consumer<AssessmentProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: _getPainColor(),
                    ),
                    child: const Text(
                      'Submit Assessment',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // Progress indicator
              const Text(
                'Step 2 of 2',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
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
// 1. Receiving Navigation Arguments:
//    - didChangeDependencies() is called after navigation
//    - ModalRoute.of(context)!.settings.arguments gets data
//    - Cast to expected type: as Map? or as int?
//    - Check for null before using
//
// 2. Why didChangeDependencies() not initState()?
//    - initState() happens before context is available
//    - didChangeDependencies() has access to BuildContext
//    - Safe to call ModalRoute.of(context) here
//
// 3. Multi-Step Flow Pattern:
//    - NRS Screen → VAS Screen → History Screen
//    - Data flows forward: NRS → VAS
//    - Each screen responsible for one task
//    - Final screen submits all data
//
// 4. Working with Multiple Providers:
//    - AuthProvider: Get current user (for studyId)
//    - AssessmentProvider: Submit assessment
//    - Use context.read<Provider>() for each
//
// 5. VAS vs NRS:
//    - NRS: 0-10 (discrete steps)
//    - VAS: 0-100 (continuous scale)
//    - VAS provides more precision
//    - Both used together for better pain measurement
//
// 6. Error Handling Pattern:
//    - Submit data
//    - Check provider.errorMessage
//    - If error: Show SnackBar, stay on screen
//    - If success: Show success message, navigate away
//    - User gets feedback either way!
//
// 7. Loading States:
//    - Consumer<AssessmentProvider> watches isLoading
//    - While loading: Show CircularProgressIndicator
//    - While not loading: Show button
//    - Prevents double-submission
//
// 8. Navigation After Success:
//    - Navigator.pushReplacementNamed('/assessment/history')
//    - "Replacement" removes current screen from stack
//    - User can't go back to VAS screen after submitting
//    - Goes straight to viewing their assessment history
//
// ============================================================================
