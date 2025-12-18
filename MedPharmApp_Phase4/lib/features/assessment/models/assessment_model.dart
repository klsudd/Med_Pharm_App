// ============================================================================
// ASSESSMENT MODEL - SCAFFOLDED FOR PHASE 2
// ============================================================================
// Students: This model represents a pain assessment submitted by the user.
//
// Phase 2 Learning Goals:
// - Work with more complex models (multiple score fields)
// - Handle validation in models
// - Practice the same serialization patterns from Phase 1
//
// Scaffolding Level: 60% (more help than Phase 1)
// ============================================================================

/// Represents a daily pain assessment
///
/// An assessment includes:
/// - NRS score (0-10): Numerical Rating Scale
/// - VAS score (0-100): Visual Analog Scale
/// - Timestamps for tracking
/// - Sync status for offline-first functionality
class AssessmentModel {
  // ========================================================================
  // PROPERTIES
  // ========================================================================

  final String id;  // Unique ID (generated from timestamp)
  final String studyId;  // Links to user (foreign key)
  final int nrsScore;  // Pain rating 0-10
  final int vasScore;  // Visual analog 0-100
  final DateTime timestamp;  // When assessment was taken
  final bool isSynced;  // Has it been synced to server?
  final DateTime createdAt;  // When record was created

  // ========================================================================
  // CONSTRUCTOR
  // ========================================================================

  AssessmentModel({
    String? id,
    required this.studyId,
    required this.nrsScore,
    required this.vasScore,
    required this.timestamp,
    this.isSynced = false,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now() {
    // Validation in constructor
    if (nrsScore < 0 || nrsScore > 10) {
      throw ArgumentError('NRS score must be between 0 and 10');
    }
    if (vasScore < 0 || vasScore > 100) {
      throw ArgumentError('VAS score must be between 0 and 100');
    }
  }

  // ========================================================================
  // EXAMPLE METHOD (FULLY IMPLEMENTED) - STUDY THIS!
  // ========================================================================

  /// Convert AssessmentModel to Map for database storage
  ///
  /// This is the SAME pattern as Phase 1 UserModel.toMap()
  /// Students: Review how we handle DateTime and bool conversions
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'study_id': studyId,
      'nrs_score': nrsScore,
      'vas_score': vasScore,
      'timestamp': timestamp.toIso8601String(),  // DateTime → String
      'is_synced': isSynced ? 1 : 0,  // bool → int
      'created_at': createdAt.toIso8601String(),
    };
  }

  // ========================================================================
  // TODO 1: IMPLEMENT fromMap() - Similar to Phase 1
  // ========================================================================

  /// Create AssessmentModel from database Map
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Extract values from map using map['column_name']
  /// 2. Convert String back to DateTime using DateTime.parse()
  /// 3. Convert int back to bool (1 == true, 0 == false)
  /// 4. Use proper type casting: map['id'] as String
  ///
  /// Pattern (same as Phase 1):
  /// ```dart
  /// factory AssessmentModel.fromMap(Map<String, dynamic> map) {
  ///   return AssessmentModel(
  ///     id: map['id'] as String,
  ///     studyId: map['study_id'] as String,
  ///     nrsScore: map['nrs_score'] as int,
  ///     // ... add other fields
  ///   );
  /// }
  /// ```
  factory AssessmentModel.fromMap(Map<String, dynamic> map) {
    return AssessmentModel(
      id: map['id'] as String,
      studyId: map['study_id'] as String,
      nrsScore: map['nrs_score'] as int,
      vasScore: map['vas_score'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
      isSynced: map['is_synced'] == 1,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  // ========================================================================
  // TODO 2: IMPLEMENT copyWith() - Same pattern as Phase 1
  // ========================================================================

  /// Create a copy with some fields updated
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. All parameters should be optional and nullable
  /// 2. Use ?? operator: newValue ?? this.value
  /// 3. Same pattern as Phase 1 UserModel.copyWith()
  ///
  /// Example usage:
  /// ```dart
  /// final updated = assessment.copyWith(isSynced: true);
  /// ```
  AssessmentModel copyWith({
    String? id,
    String? studyId,
    int? nrsScore,
    int? vasScore,
    DateTime? timestamp,
    bool? isSynced,
    DateTime? createdAt,
  }) {
    return AssessmentModel(
      id: id ?? this.id,
      studyId: studyId ?? this.studyId,
      nrsScore: nrsScore ?? this.nrsScore,
      vasScore: vasScore ?? this.vasScore,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // ========================================================================
  // HELPER METHODS (Already implemented)
  // ========================================================================

  /// Get a user-friendly pain level description based on NRS score
  String get painLevelDescription {
    if (nrsScore == 0) return 'No Pain';
    if (nrsScore <= 3) return 'Mild Pain';
    if (nrsScore <= 6) return 'Moderate Pain';
    if (nrsScore <= 9) return 'Severe Pain';
    return 'Worst Possible Pain';
  }

  /// Get color for pain level visualization
  /// Useful for UI display
  String get painLevelColor {
    if (nrsScore == 0) return '#4CAF50';  // Green
    if (nrsScore <= 3) return '#8BC34A';  // Light Green
    if (nrsScore <= 6) return '#FFC107';  // Yellow
    if (nrsScore <= 9) return '#FF9800';  // Orange
    return '#F44336';  // Red
  }

  /// Check if assessment was taken today
  bool get isTodayAssessment {
    final now = DateTime.now();
    return timestamp.year == now.year &&
        timestamp.month == now.month &&
        timestamp.day == now.day;
  }

  /// Get formatted date for display
  String get formattedDate {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
  }

  /// Get formatted time for display
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }

  @override
  String toString() {
    return 'AssessmentModel(id: $id, NRS: $nrsScore, VAS: $vasScore, date: $formattedDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AssessmentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// ============================================================================
// LEARNING NOTES:
// ============================================================================
//
// 1. How is this different from Phase 1 UserModel?
//    - More fields to manage (nrsScore, vasScore, etc.)
//    - Validation in constructor (throws error if invalid)
//    - More helper methods for UI display
//    - But the SAME patterns: toMap, fromMap, copyWith
//
// 2. Why validation in constructor?
//    - Ensures invalid assessments can never be created
//    - "Fail fast" principle - catch errors early
//    - Example: AssessmentModel(nrsScore: 15) → throws error!
//
// 3. What are the helper methods for?
//    - painLevelDescription: User-friendly text ("Mild Pain")
//    - painLevelColor: For color-coding UI
//    - isTodayAssessment: Check if user already assessed today
//    - formattedDate/Time: Display-ready strings
//
// 4. Why implement == and hashCode?
//    - Allows comparing assessments: assessment1 == assessment2
//    - Useful in lists, sets, maps
//    - Dart best practice for data models
//
// 5. Pattern Recognition from Phase 1:
//    - toMap() → Same DateTime/bool conversion
//    - fromMap() → Same type casting and parsing
//    - copyWith() → Same null coalescing pattern
//    - You already know these patterns!
//
// ============================================================================
