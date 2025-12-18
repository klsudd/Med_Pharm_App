// ============================================================================
// AUTHENTICATION PROVIDER - SCAFFOLDED FOR STUDENTS
// ============================================================================
// Students: This is a Provider that manages authentication STATE.
//
// A Provider (ChangeNotifier) is responsible for:
// 1. Holding STATE (variables that can change)
// 2. Providing METHODS to modify state
// 3. Notifying UI when state changes (notifyListeners())
//
// The UI "watches" this provider and rebuilds when state changes.
// ============================================================================

import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

/// AuthProvider manages authentication state
///
/// This provider handles:
/// - Current user session
/// - Enrollment process
/// - Consent acceptance
/// - Tutorial completion
/// - Loading states
/// - Error messages
class AuthProvider extends ChangeNotifier {
  // ========================================================================
  // DEPENDENCIES
  // ========================================================================
  final AuthService _authService;

  // Constructor with dependency injection
  AuthProvider(this._authService);

  // ========================================================================
  // STATE VARIABLES
  // ========================================================================
  // These variables hold the current state of authentication
  // When these change, we call notifyListeners() to update the UI

  /// Current logged-in user (null if not logged in)
  UserModel? _currentUser;

  /// Loading state (true when performing async operations)
  bool _isLoading = false;

  /// Error message (null if no error)
  String? _errorMessage;

  /// Enrollment code being entered
  String _enrollmentCode = '';

  // ========================================================================
  // GETTERS
  // ========================================================================
  // Getters allow other classes to READ the state (but not modify it directly)
  // This is called "encapsulation" - we control how state is accessed

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get enrollmentCode => _enrollmentCode;

  /// Check if user is fully enrolled (consent + tutorial completed)
  bool get isFullyEnrolled {
    return _currentUser != null && _currentUser!.hasCompletedOnboarding;
  }

  /// Check if user has accepted consent
  bool get hasAcceptedConsent {
    return _currentUser?.consentAccepted ?? false;
  }

  /// Check if user has completed tutorial
  bool get hasCompletedTutorial {
    return _currentUser?.tutorialCompleted ?? false;
  }

  // ========================================================================
  // EXAMPLE METHOD (FULLY IMPLEMENTED) - STUDY THIS!
  // ========================================================================
  /// Load current user from database
  ///
  /// This method shows you the PATTERN for provider methods:
  /// 1. Set loading state to true
  /// 2. Clear any previous errors
  /// 3. Call notifyListeners() to update UI
  /// 4. Perform async operation (call service)
  /// 5. Update state with result
  /// 6. Set loading to false
  /// 7. Call notifyListeners() again
  /// 8. Handle errors with try-catch
  ///
  /// Example usage (in a widget):
  /// ```dart
  /// final authProvider = context.read<AuthProvider>();
  /// await authProvider.loadCurrentUser();
  /// ```
  Future<void> loadCurrentUser() async {
    try {
      // STEP 1-3: Set loading state and notify UI
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();  // UI will show loading indicator

      // STEP 4: Call the service to get data
      final user = await _authService.getCurrentUser();

      // STEP 5: Update state with result
      _currentUser = user;

      // STEP 6-7: Clear loading state and notify UI
      _isLoading = false;
      notifyListeners();  // UI will update with new user data
    } catch (e) {
      // STEP 8: Handle errors
      _isLoading = false;
      _errorMessage = 'Failed to load user: $e';
      notifyListeners();  // UI will show error message
    }
  }

  // ========================================================================
  // TODO 1: ENROLL USER
  // ========================================================================
  /// Enroll a new user with the provided enrollment code
  ///
  /// TODO: Implement this method
  /// Steps:
  /// 1. Set isLoading = true, clear error, notify listeners
  /// 2. Validate enrollment code using authService.validateEnrollmentCode()
  /// 3. If invalid, set error message and return
  /// 4. Generate study ID using authService.generateStudyId()
  /// 5. Create new UserModel with:
  ///    - studyId: generated study ID
  ///    - enrollmentCode: the provided code
  ///    - enrolledAt: DateTime.now()
  /// 6. Save user using authService.saveUser()
  /// 7. Update _currentUser with the saved user
  /// 8. Set isLoading = false, notify listeners
  /// 9. Wrap in try-catch to handle errors
  ///
  /// Example usage:
  /// ```dart
  /// await authProvider.enrollUser('ABC12345');
  /// ```
  Future<void> enrollUser(String code) async {
    try {
      // Set loading state
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Validate enrollment code
      final isValid = await _authService.validateEnrollmentCode(code);
      if (!isValid) {
        _errorMessage = 'Invalid enrollment code format. Must be 8-12 alphanumeric characters.';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Generate study ID
      final studyId = _authService.generateStudyId(code);

      // Create new user model
      final user = UserModel(
        studyId: studyId,
        enrollmentCode: code,
        enrolledAt: DateTime.now(),
      );

      // Save user to database
      await _authService.saveUser(user);

      // Update state
      _currentUser = user;

      // Clear loading
      _isLoading = false;
      notifyListeners();

      print('✅ User enrolled successfully: ${user.studyId}');
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to enroll user. Please try again.';
      notifyListeners();
      print('❌ Enrollment error: $e');
    }
  }

  // ========================================================================
  // TODO 2: ACCEPT CONSENT
  // ========================================================================
  /// Mark consent as accepted for current user
  ///
  /// TODO: Implement this method
  /// Steps:
  /// 1. Check if _currentUser is null, if so return (can't accept consent without user)
  /// 2. Set isLoading = true, clear error, notify listeners
  /// 3. Call authService.updateConsentStatus() with current user's study ID
  /// 4. Update _currentUser using copyWith():
  ///    ```dart
  ///    _currentUser = _currentUser!.copyWith(
  ///      consentAccepted: true,
  ///      consentAcceptedAt: DateTime.now(),
  ///    );
  ///    ```
  /// 5. Set isLoading = false, notify listeners
  /// 6. Wrap in try-catch
  ///
  /// Example usage:
  /// ```dart
  /// await authProvider.acceptConsent();
  /// ```
  Future<void> acceptConsent() async {
    if (_currentUser == null) {
      print('⚠️ Cannot accept consent: No user enrolled');
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.updateConsentStatus(_currentUser!.studyId);

      _currentUser = _currentUser!.copyWith(
        consentAccepted: true,
        consentAcceptedAt: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();

      print('✅ Consent accepted for ${_currentUser!.studyId}');
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to accept consent. Please try again.';
      notifyListeners();
      print('❌ Accept consent error: $e');
    }
  }

  // ========================================================================
  // TODO 3: COMPLETE TUTORIAL
  // ========================================================================
  /// Mark tutorial as completed for current user
  ///
  /// TODO: Implement this method
  /// Steps:
  /// 1. Check if _currentUser is null
  /// 2. Set loading state
  /// 3. Call authService.updateTutorialStatus()
  /// 4. Update _currentUser using copyWith() with tutorialCompleted: true
  /// 5. Clear loading, notify listeners
  /// 6. Handle errors
  ///
  /// Example usage:
  /// ```dart
  /// await authProvider.completeTutorial();
  /// ```
  Future<void> completeTutorial() async {
    if (_currentUser == null) {
      print('⚠️ Cannot complete tutorial: No user enrolled');
      return;
    }

    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.updateTutorialStatus(_currentUser!.studyId);

      _currentUser = _currentUser!.copyWith(
        tutorialCompleted: true,
      );

      _isLoading = false;
      notifyListeners();

      print('✅ Tutorial completed for ${_currentUser!.studyId}');
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to complete tutorial. Please try again.';
      notifyListeners();
      print('❌ Complete tutorial error: $e');
    }
  }

  // ========================================================================
  // TODO 4: UPDATE ENROLLMENT CODE
  // ========================================================================
  /// Update the enrollment code being entered
  ///
  /// This is called when user types in the enrollment code field
  ///
  /// TODO: Implement this method
  /// Steps:
  /// 1. Update _enrollmentCode with the new value
  /// 2. Call notifyListeners() so UI updates
  ///
  /// Example usage:
  /// ```dart
  /// authProvider.updateEnrollmentCode('ABC12345');
  /// ```
  void updateEnrollmentCode(String code) {
    _enrollmentCode = code;
    notifyListeners();
  }

  // ========================================================================
  // HELPER METHODS (Already implemented)
  // ========================================================================

  /// Clear any error messages
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Logout current user (delete from database)
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await _authService.deleteUserData();
      _currentUser = null;
      _enrollmentCode = '';

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to logout: $e';
      _isLoading = false;
      notifyListeners();
    }
  }
}

// ============================================================================
// LEARNING NOTES FOR STUDENTS:
// ============================================================================
//
// 1. What is ChangeNotifier?
//    - A class that can notify listeners when it changes
//    - Part of Flutter's state management
//    - Used with Provider package
//
// 2. When should I call notifyListeners()?
//    - After changing ANY state variable
//    - This tells the UI to rebuild
//    - Don't forget it or UI won't update!
//
// 3. Why use private variables (_currentUser) with public getters?
//    - Prevents outside code from modifying state directly
//    - Forces all changes to go through methods
//    - Makes code more maintainable and debuggable
//
// 4. What's the pattern for async methods in providers?
//    - Set loading = true, notify
//    - Do async work
//    - Update state
//    - Set loading = false, notify
//    - Always use try-catch!
//
// 5. Why use copyWith() instead of modifying _currentUser directly?
//    - UserModel is immutable (all fields are final)
//    - copyWith() creates a NEW object with changes
//    - This is safer and prevents bugs
//
// 6. How does the UI use this provider?
//    - Consumer widget: rebuilds when state changes
//    - context.watch(): gets provider and listens
//    - context.read(): gets provider without listening (for methods)
//
// ============================================================================
