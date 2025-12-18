// ============================================================================
// NRS ASSESSMENT SCREEN - SCAFFOLDED FOR PHASE 2
// ============================================================================
// Students: This screen collects the NRS (Numerical Rating Scale) pain score.
//
// Phase 2 Learning Goals:
// - Build interactive UI with sliders
// - Manage local widget state (selected score)
// - Navigate between screens with data
// - Apply UI patterns from Phase 1
//
// Scaffolding Level: 60% (UI provided, logic TODOs)
// ============================================================================

import 'package:flutter/material.dart';

/// NRS Assessment Screen - Numerical Rating Scale (0-10)
///
/// This screen lets users rate their pain on a scale of 0-10
/// where 0 = No Pain and 10 = Worst Possible Pain
class NrsAssessmentScreen extends StatefulWidget {
  const NrsAssessmentScreen({Key? key}) : super(key: key);

  @override
  State<NrsAssessmentScreen> createState() => _NrsAssessmentScreenState();
}

class _NrsAssessmentScreenState extends State<NrsAssessmentScreen> {
  // ========================================================================
  // STATE
  // ========================================================================

  // Current selected NRS score (0-10)
  double _nrsScore = 5.0; // Default to middle value

  // ========================================================================
  // TODO 1: HANDLE NEXT BUTTON
  // ========================================================================

  /// Navigate to VAS screen with the selected NRS score
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Convert _nrsScore (double) to int: _nrsScore.round()
  /// 2. Navigate to VAS screen and pass the score:
  ///    Navigator.pushNamed(
  ///      context,
  ///      '/assessment/vas',
  ///      arguments: {'nrsScore': nrsScore},
  ///    );
  ///
  /// Pattern:
  /// ```dart
  /// void _handleNext() {
  ///   final nrsScore = _nrsScore.round();
  ///   Navigator.pushNamed(
  ///     context,
  ///     '/assessment/vas',
  ///     arguments: {'nrsScore': nrsScore},
  ///   );
  /// }
  /// ```
  void _handleNext() {
    final nrsScore = _nrsScore.round();
    Navigator.pushNamed(
      context,
      '/assessment/vas',
      arguments: {'nrsScore': nrsScore},
    );
  }

  // ========================================================================
  // HELPER METHODS (Already implemented)
  // ========================================================================

  /// Get color for the current pain level
  Color _getPainColor() {
    final score = _nrsScore.round();
    if (score == 0) return Colors.green;
    if (score <= 3) return Colors.lightGreen;
    if (score <= 6) return Colors.orange;
    if (score <= 9) return Colors.deepOrange;
    return Colors.red;
  }

  /// Get description for the current pain level
  String _getPainDescription() {
    final score = _nrsScore.round();
    if (score == 0) return 'No Pain';
    if (score <= 3) return 'Mild Pain';
    if (score <= 6) return 'Moderate Pain';
    if (score <= 9) return 'Severe Pain';
    return 'Worst Possible Pain';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ======================================================================
      // APP BAR
      // ======================================================================
      appBar: AppBar(
        title: const Text('Pain Assessment - NRS'),
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
                'Numerical Rating Scale',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              const Text(
                'On a scale from 0 to 10, how much pain are you experiencing right now?',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

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
                      _nrsScore.round().toString(),
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
              // TODO 2: Update slider onChanged callback
              // Hint: Update _nrsScore and call setState()
              // Pattern:
              // onChanged: (value) {
              //   setState(() {
              //     _nrsScore = value;
              //   });
              // },
              Slider(
                value: _nrsScore,
                min: 0,
                max: 10,
                divisions: 10,
                label: _nrsScore.round().toString(),
                activeColor: _getPainColor(),
                onChanged: (value) {
                  setState(() {
                    _nrsScore = value;
                  });
                },
              ),

              // Scale labels
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0\nNo Pain', textAlign: TextAlign.center),
                  Text('10\nWorst Pain', textAlign: TextAlign.center),
                ],
              ),
              const SizedBox(height: 48),

              // ==============================================================
              // NEXT BUTTON
              // ==============================================================
              ElevatedButton(
                onPressed: _handleNext,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  backgroundColor: _getPainColor(),
                ),
                child: const Text(
                  'Next: Visual Analog Scale',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              const SizedBox(height: 16),

              // Progress indicator
              const Text(
                'Step 1 of 2',
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
// 1. What is StatefulWidget?
//    - Has mutable state that can change over time
//    - setState() triggers rebuild when state changes
//    - Used here because slider value changes
//
// 2. Understanding the Slider Widget:
//    - value: Current slider position (0.0 to 10.0)
//    - min/max: Range of slider
//    - divisions: Number of discrete steps (10 steps = 0,1,2...10)
//    - label: Shows value when dragging
//    - onChanged: Called when user moves slider
//
// 3. What is setState()?
//    - Tells Flutter to rebuild this widget
//    - Always wrap state changes in setState()
//    - Example: setState(() { _nrsScore = value; });
//    - Without setState(), UI won't update!
//
// 4. Navigation with Arguments:
//    - Navigator.pushNamed() can pass data between screens
//    - arguments: Map of data to pass
//    - Next screen receives data via ModalRoute.of(context)!.settings.arguments
//
// 5. Color Coding for UX:
//    - Green (0) → Light Green (1-3) → Orange (4-6) → Deep Orange (7-9) → Red (10)
//    - Visual feedback helps users understand pain scale
//    - Color changes as slider moves (reactive UI)
//
// 6. Container Styling:
//    - decoration: BoxDecoration for custom styling
//    - borderRadius: Rounded corners
//    - border: Colored border
//    - color.withOpacity(0.2): Semi-transparent background
//
// 7. round() vs floor() vs ceil():
//    - round(): Nearest integer (5.4 → 5, 5.6 → 6)
//    - floor(): Always round down (5.9 → 5)
//    - ceil(): Always round up (5.1 → 6)
//    - Use round() for slider to get closest value
//
// ============================================================================
