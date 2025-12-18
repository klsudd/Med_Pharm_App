// ============================================================================
// AUTHENTICATION SERVICE - PARTIALLY IMPLEMENTED
// ============================================================================
// Students: This service handles all authentication-related data operations.
//
// A Service is a class that:
// 1. Talks to the database or API
// 2. Contains business logic
// 3. Used by Providers (state management)
//
// STUDY THE EXAMPLE METHOD (saveUser) then implement the TODOs
// ============================================================================

import 'package:sqflite/sqflite.dart';
import '../../../core/services/database_service.dart';
import '../models/user_model.dart';

/// AuthService handles user enrollment and session management
///
/// This service is responsible for:
/// - Saving user data to the database
/// - Loading user session
/// - Updating user progress (consent, tutorial)
/// - Validating enrollment codes
class AuthService {
  // ========================================================================
  // DEPENDENCY
  // ========================================================================
  // DatabaseService provides access to the SQLite database
  final DatabaseService _databaseService;

  // Constructor with dependency injection
  // The database service is passed in (not created here)
  // This makes testing easier!
  AuthService(this._databaseService);

  // ========================================================================
  // EXAMPLE METHOD (FULLY IMPLEMENTED) - STUDY THIS!
  // ========================================================================
  /// Save user to database
  ///
  /// This method shows you the PATTERN for database operations:
  /// 1. Get database instance
  /// 2. Convert model to Map
  /// 3. Perform database operation (insert/update/query/delete)
  /// 4. Handle result
  /// 5. Convert Map back to model (if needed)
  ///
  /// Example usage:
  /// ```dart
  /// final user = UserModel(...);
  /// await authService.saveUser(user);
  /// ```
  Future<int> saveUser(UserModel user) async {
    try {
      // STEP 1: Get database instance
      final db = await _databaseService.database;

      // STEP 2: Convert UserModel to Map
      final userMap = user.toMap();

      // STEP 3: Insert into database
      // insert() returns the new row ID
      final id = await db.insert(
        'user_session',  // Table name
        userMap,  // Data to insert
        conflictAlgorithm: ConflictAlgorithm.replace,  // Replace if exists
      );

      // STEP 4: Return the ID
      print('✅ User saved with ID: $id');
      return id;
    } catch (e) {
      // Always handle errors!
      print('❌ Error saving user: $e');
      rethrow;  // Re-throw so caller can handle it
    }
  }

  // ========================================================================
  // TODO 1: GET CURRENT USER
  // ========================================================================
  /// Get the current user session from database
  ///
  /// Returns null if no user is enrolled
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Follow the same pattern as saveUser()
  /// 2. Use db.query() to read from database
  ///    ```dart
  ///    final results = await db.query('user_session', limit: 1);
  ///    ```
  /// 3. Check if results is empty (no user enrolled)
  /// 4. If not empty, convert first result to UserModel using fromMap()
  /// 5. Return the UserModel (or null if no results)
  ///
  /// Example usage:
  /// ```dart
  /// final user = await authService.getCurrentUser();
  /// if (user == null) {
  ///   print('No user enrolled');
  /// }
  /// ```
  Future<UserModel?> getCurrentUser() async {
    try {
      final db = await _databaseService.database;

      final results = await db.query(
        'user_session',
        limit: 1,
      );

      if (results.isEmpty) {
        print('ℹ️ No user enrolled yet');
        return null;
      }

      final user = UserModel.fromMap(results.first);
      print('✅ Current user loaded: ${user.studyId}');
      return user;
    } catch (e) {
      print('❌ Error getting current user: $e');
      rethrow;
    }
  }

  // ========================================================================
  // TODO 2: UPDATE CONSENT STATUS
  // ========================================================================
  /// Mark consent as accepted for the current user
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Get database instance
  /// 2. Use db.update() to modify the record
  ///    ```dart
  ///    await db.update(
  ///      'user_session',
  ///      {'consent_accepted': 1, 'consent_accepted_at': DateTime.now().toIso8601String()},
  ///      where: 'study_id = ?',
  ///      whereArgs: [studyId],
  ///    );
  ///    ```
  /// 3. Return number of rows updated (should be 1)
  ///
  /// Example usage:
  /// ```dart
  /// await authService.updateConsentStatus('STUDY123');
  /// ```
  Future<int> updateConsentStatus(String studyId) async {
    try {
      final db = await _databaseService.database;

      final rowsUpdated = await db.update(
        'user_session',
        {
          'consent_accepted': 1,
          'consent_accepted_at': DateTime.now().toIso8601String(),
        },
        where: 'study_id = ?',
        whereArgs: [studyId],
      );

      print('✅ Consent status updated for $studyId ($rowsUpdated rows)');
      return rowsUpdated;
    } catch (e) {
      print('❌ Error updating consent status: $e');
      rethrow;
    }
  }

  // ========================================================================
  // TODO 3: UPDATE TUTORIAL STATUS
  // ========================================================================
  /// Mark tutorial as completed for the current user
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Similar to updateConsentStatus()
  /// 2. Update the 'tutorial_completed' field to 1 (true)
  /// 3. Use WHERE clause to find the right user by study_id
  ///
  /// Example usage:
  /// ```dart
  /// await authService.updateTutorialStatus('STUDY123');
  /// ```
  Future<int> updateTutorialStatus(String studyId) async {
    try {
      final db = await _databaseService.database;

      final rowsUpdated = await db.update(
        'user_session',
        {'tutorial_completed': 1},
        where: 'study_id = ?',
        whereArgs: [studyId],
      );

      print('✅ Tutorial marked complete for $studyId');
      return rowsUpdated;
    } catch (e) {
      print('❌ Error updating tutorial status: $e');
      rethrow;
    }
  }

  // ========================================================================
  // TODO 4: VALIDATE ENROLLMENT CODE
  // ========================================================================
  /// Validate an enrollment code
  ///
  /// In a real app, this would call an API to check if the code is valid.
  /// For this educational project, we'll use simple validation rules.
  ///
  /// TODO: Implement this method
  /// Validation rules:
  /// 1. Code must not be empty
  /// 2. Code must be 8-12 characters long
  /// 3. Code must contain only letters and numbers (alphanumeric)
  ///
  /// Hints:
  /// - Use code.isEmpty to check if empty
  /// - Use code.length to check length
  /// - Use RegExp to check alphanumeric:
  ///   ```dart
  ///   final alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');
  ///   alphanumeric.hasMatch(code)
  ///   ```
  ///
  /// Example usage:
  /// ```dart
  /// if (await authService.validateEnrollmentCode('ABC12345')) {
  ///   print('Valid code!');
  /// }
  /// ```
  Future<bool> validateEnrollmentCode(String code) async {
    // Rule 1: Cannot be empty
    if (code.isEmpty) {
      print('❌ Validation failed: Code is empty');
      return false;
    }

    // Rule 2: Length must be 8-12 characters
    if (code.length < 8 || code.length > 12) {
      print('❌ Validation failed: Code must be 8-12 characters (got ${code.length})');
      return false;
    }

    // Rule 3: Must be alphanumeric (letters and numbers only)
    final alphanumericPattern = RegExp(r'^[a-zA-Z0-9]+$');
    if (!alphanumericPattern.hasMatch(code)) {
      print('❌ Validation failed: Code must be alphanumeric only');
      return false;
    }

    // All validations passed
    print('✅ Code validation passed: $code');
    return true;
  }

  // ========================================================================
  // TODO 5: CHECK IF USER EXISTS
  // ========================================================================
  /// Check if a user is already enrolled
  ///
  /// Returns true if user_session table has any records
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Query the user_session table
  /// 2. Check if results is empty
  /// 3. Return true if results is NOT empty
  ///
  /// Example usage:
  /// ```dart
  /// if (await authService.isUserEnrolled()) {
  ///   print('User already enrolled');
  /// }
  /// ```
  Future<bool> isUserEnrolled() async {
    try {
      final db = await _databaseService.database;

      final results = await db.query('user_session');

      final isEnrolled = results.isNotEmpty;

      if (isEnrolled) {
        print('✅ User is enrolled');
      } else {
        print('ℹ️ No user enrolled');
      }

      return isEnrolled;
    } catch (e) {
      print('❌ Error checking enrollment status: $e');
      return false;
    }
  }

  // ========================================================================
  // HELPER METHOD (Already implemented - study this!)
  // ========================================================================

  /// Generate a study ID from enrollment code
  ///
  /// In a real app, this would come from the API.
  /// For this project, we'll generate it locally.
  String generateStudyId(String enrollmentCode) {
    // Simple generation: STUDY_ + enrollment code + timestamp
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'STUDY_${enrollmentCode}_$timestamp';
  }

  /// Delete all user data (for testing/logout)
  ///
  /// WARNING: This deletes ALL user data!
  Future<void> deleteUserData() async {
    final db = await _databaseService.database;
    await db.delete('user_session');
    print('🗑️ User data deleted');
  }
}

// ============================================================================
// LEARNING NOTES FOR STUDENTS:
// ============================================================================
//
// 1. Why do we pass DatabaseService to the constructor?
//    - This is called "Dependency Injection"
//    - Makes the code more testable (we can pass a fake database for testing)
//    - Follows the Dependency Inversion Principle (SOLID)
//
// 2. What's the difference between insert(), update(), query(), delete()?
//    - insert() = Add new row (CREATE)
//    - query() = Read rows (READ)
//    - update() = Modify existing rows (UPDATE)
//    - delete() = Remove rows (DELETE)
//    - Together they're called CRUD operations!
//
// 3. Why use try-catch?
//    - Database operations can fail (disk full, permission denied, etc.)
//    - try-catch prevents the app from crashing
//    - We can show user-friendly error messages
//
// 4. What does 'async' and 'await' mean?
//    - async = This function runs asynchronously (doesn't block UI)
//    - await = Wait for this operation to finish before continuing
//    - Database operations are slow, so we use async/await
//
// 5. Why print() statements?
//    - Helps with debugging (see what's happening)
//    - In production apps, you'd use a proper logging framework
//
// ============================================================================
