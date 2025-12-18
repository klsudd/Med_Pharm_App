// ============================================================================
// APP ROUTES - Navigation configuration
// ============================================================================
// Students: Add new routes here as you create more screens
//
// A route is a named path to a screen. Instead of:
//   Navigator.push(context, MaterialPageRoute(builder: (_) => MyScreen()))
//
// You can use:
//   Navigator.pushNamed(context, '/my-screen')
//
// This makes navigation cleaner and easier to manage.
// ============================================================================

import 'package:flutter/material.dart';
import '../features/authentication/screens/enrollment_screen.dart';
import '../features/authentication/screens/consent_screen.dart';

// Assessment screens (Phase 2)
import '../features/assessment/screens/nrs_assessment_screen.dart';
import '../features/assessment/screens/vas_assessment_screen.dart';
import '../features/assessment/screens/assessment_history_screen.dart';

// Gamification screens (Phase 3)
import '../features/gamification/screens/home_screen.dart';
import '../features/gamification/screens/badge_gallery_screen.dart';
import '../features/gamification/screens/progress_screen.dart';

/// App routes configuration
class AppRoutes {
  // ========================================================================
  // ROUTE NAMES (constants)
  // ========================================================================
  // Using constants prevents typos and makes refactoring easier
  static const String enrollment = '/';
  static const String consent = '/consent';
  static const String tutorial = '/tutorial';  // TODO: Create this screen
  static const String home = '/home';

  // Assessment routes (Phase 2)
  static const String assessmentNrs = '/assessment/nrs';
  static const String assessmentVas = '/assessment/vas';
  static const String assessmentHistory = '/assessment/history';

  // Gamification routes (Phase 3)
  static const String badges = '/badges';
  static const String progress = '/progress';

  // ========================================================================
  // ROUTES MAP
  // ========================================================================
  /// Map of route names to screen builders
  ///
  /// TODO: Add more routes as you create more screens
  /// Example:
  /// tutorial: (context) => const TutorialScreen(),
  static Map<String, WidgetBuilder> get routes {
    return {
      enrollment: (context) => const EnrollmentScreen(),
      consent: (context) => const ConsentScreen(),
      // TODO: Add tutorial route
      home: (context) => const HomeScreen(),

      // Assessment routes (Phase 2)
      assessmentNrs: (context) => const NrsAssessmentScreen(),
      assessmentVas: (context) => const VasAssessmentScreen(),
      assessmentHistory: (context) => const AssessmentHistoryScreen(),

      // Gamification routes (Phase 3)
      badges: (context) => const BadgeGalleryScreen(),
      progress: (context) => const ProgressScreen(),
    };
  }

  // ========================================================================
  // ON UNKNOWN ROUTE
  // ========================================================================
  /// Handle unknown routes (404 page)
  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Text('Route ${settings.name} not found'),
        ),
      ),
    );
  }
}

// ============================================================================
// LEARNING NOTES:
// ============================================================================
//
// 1. Why use named routes?
//    - Cleaner code: Navigator.pushNamed(context, '/home')
//    - Centralized navigation logic
//    - Easier to add deep linking later
//    - Better for large apps
//
// 2. What is WidgetBuilder?
//    - A function that takes BuildContext and returns a Widget
//    - Type: Widget Function(BuildContext)
//    - Used for lazy loading (widget not created until navigating to it)
//
// 3. What's the difference between push, pushNamed, pushReplacement?
//    - push: Add new screen on top of stack (can go back)
//    - pushNamed: Same as push but with named route
//    - pushReplacement: Replace current screen (can't go back)
//    - pushReplacementNamed: Same as pushReplacement with named route
//
// 4. When to use pushReplacement?
//    - After login/enrollment (don't let user go back to login)
//    - After splash screen
//    - When current screen is no longer relevant
//
// ============================================================================
