// ============================================================================
// USER MODEL - SCAFFOLDED FOR STUDENTS
// ============================================================================
// Students: This class represents a User in our app.
// Your task is to implement the TODO methods below.
//
// A Model is a class that represents data. It should:
// 1. Store data in properties (variables)
// 2. Convert to/from Map (for database storage)
// 3. Be immutable (use 'final' for all properties)
// ============================================================================

/// Represents a user enrolled in the clinical trial
///
/// This model contains all the information about a user that we
/// store in the database.
class UserModel {
  // ========================================================================
  // PROPERTIES
  // ========================================================================
  // These are the data fields for a user
  // 'final' means they can't be changed after creation (immutable)

  final int? id;  // Database ID (null if not yet saved)
  final String studyId;  // Unique ID from the trial system
  final String enrollmentCode;  // Code used to enroll
  final DateTime enrolledAt;  // When the user enrolled
  final bool consentAccepted;  // Has user accepted consent?
  final DateTime? consentAcceptedAt;  // When consent was accepted
  final bool tutorialCompleted;  // Has user completed tutorial?

  // ========================================================================
  // CONSTRUCTOR
  // ========================================================================
  // This is how you create a new UserModel instance
  //
  // Example usage:
  // ```dart
  // final user = UserModel(
  //   studyId: 'STUDY123',
  //   enrollmentCode: 'ABC12345',
  //   enrolledAt: DateTime.now(),
  // );
  // ```

  UserModel({
    this.id,
    required this.studyId,
    required this.enrollmentCode,
    required this.enrolledAt,
    this.consentAccepted = false,
    this.consentAcceptedAt,
    this.tutorialCompleted = false,
  });

  // ========================================================================
  // METHOD 1: toMap() - Convert UserModel to Map<String, dynamic>
  // ========================================================================
  // This method converts the UserModel object to a Map so it can be
  // stored in the SQLite database.
  //
  // Why Map? SQLite stores data as key-value pairs (like a Map)
  //
  // TODO: Implement this method
  // Hints:
  // 1. Return a Map with keys matching the database column names
  // 2. Use the column names from database_service.dart (user_session table)
  // 3. Convert DateTime to String using .toIso8601String()
  // 4. Convert bool to int (1 for true, 0 for false) - SQLite doesn't have boolean type
  // 5. Don't include 'id' if it's null (database will auto-generate it)
  //
  // Example structure:
  // return {
  //   'study_id': studyId,
  //   'enrollment_code': ...,
  //   // ... add other fields
  // };
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'study_id': studyId,
      'enrollment_code': enrollmentCode,
      'enrolled_at': enrolledAt.toIso8601String(),
      'consent_accepted': consentAccepted ? 1 : 0,
      'consent_accepted_at': consentAcceptedAt?.toIso8601String(),
      'tutorial_completed': tutorialCompleted ? 1 : 0,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  // ========================================================================
  // METHOD 2: fromMap() - Create UserModel from Map<String, dynamic>
  // ========================================================================
  // This is a factory constructor that creates a UserModel from a Map
  // It's used when reading data FROM the database
  //
  // Factory constructor = special constructor that can return an instance
  //
  // TODO: Implement this method
  // Hints:
  // 1. Use map['column_name'] to get values
  // 2. Convert String back to DateTime using DateTime.parse()
  // 3. Convert int back to bool (1 == true, 0 == false)
  // 4. Handle nullable fields carefully (use map['field'] as DateTime?)
  //
  // Example structure:
  // factory UserModel.fromMap(Map<String, dynamic> map) {
  //   return UserModel(
  //     id: map['id'] as int?,
  //     studyId: map['study_id'] as String,
  //     // ... add other fields
  //   );
  // }
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      studyId: map['study_id'] as String,
      enrollmentCode: map['enrollment_code'] as String,
      enrolledAt: DateTime.parse(map['enrolled_at'] as String),
      consentAccepted: map['consent_accepted'] == 1,
      consentAcceptedAt: map['consent_accepted_at'] != null
          ? DateTime.parse(map['consent_accepted_at'] as String)
          : null,
      tutorialCompleted: map['tutorial_completed'] == 1,
    );
  }

  // ========================================================================
  // METHOD 3: copyWith() - Create a copy with some fields changed
  // ========================================================================
  // This method creates a new UserModel with some fields updated
  // It's useful because UserModel is immutable (can't change fields directly)
  //
  // Example usage:
  // ```dart
  // final user = UserModel(studyId: 'STUDY123', ...);
  // final updatedUser = user.copyWith(consentAccepted: true);
  // // user is unchanged, updatedUser has consentAccepted = true
  // ```
  //
  // TODO: Implement this method
  // Hints:
  // 1. All parameters should be optional and nullable
  // 2. Use ?? operator: newValue ?? this.value
  //    (means: use newValue if provided, otherwise keep current value)
  //
  // Example structure:
  // UserModel copyWith({
  //   int? id,
  //   String? studyId,
  //   // ... add other fields
  // }) {
  //   return UserModel(
  //     id: id ?? this.id,
  //     studyId: studyId ?? this.studyId,
  //     // ... add other fields
  //   );
  // }
  UserModel copyWith({
    int? id,
    String? studyId,
    String? enrollmentCode,
    DateTime? enrolledAt,
    bool? consentAccepted,
    DateTime? consentAcceptedAt,
    bool? tutorialCompleted,
  }) {
    return UserModel(
      id: id ?? this.id,
      studyId: studyId ?? this.studyId,
      enrollmentCode: enrollmentCode ?? this.enrollmentCode,
      enrolledAt: enrolledAt ?? this.enrolledAt,
      consentAccepted: consentAccepted ?? this.consentAccepted,
      consentAcceptedAt: consentAcceptedAt ?? this.consentAcceptedAt,
      tutorialCompleted: tutorialCompleted ?? this.tutorialCompleted,
    );
  }

  // ========================================================================
  // HELPER METHODS (Already implemented - study these!)
  // ========================================================================

  /// Check if user has completed onboarding
  /// Onboarding = consent accepted + tutorial completed
  bool get hasCompletedOnboarding {
    return consentAccepted && tutorialCompleted;
  }

  /// Get a display-friendly enrollment status
  String get enrollmentStatus {
    if (!consentAccepted) return 'Consent Pending';
    if (!tutorialCompleted) return 'Tutorial Pending';
    return 'Enrolled';
  }

  /// Override toString() for easy debugging
  /// This is what you see when you print(userModel)
  @override
  String toString() {
    return 'UserModel(id: $id, studyId: $studyId, status: $enrollmentStatus)';
  }
}

// ============================================================================
// LEARNING NOTES FOR STUDENTS:
// ============================================================================
//
// 1. Why do we need toMap() and fromMap()?
//    - SQLite stores data as tables (rows and columns)
//    - Dart uses objects (classes with properties)
//    - We need to convert between them!
//
// 2. Why is UserModel immutable (all 'final')?
//    - Immutability prevents bugs (can't accidentally change data)
//    - Makes code predictable and easier to test
//    - Common pattern in Flutter/Dart
//
// 3. Why use copyWith() instead of setters?
//    - Because properties are 'final' (can't be changed)
//    - copyWith() creates a NEW object with changes
//    - This is a functional programming pattern
//
// 4. What's the difference between 'int?' and 'int'?
//    - int? = nullable (can be null)
//    - int = non-nullable (must have a value)
//    - id is int? because new users don't have an ID yet
//
// ============================================================================
