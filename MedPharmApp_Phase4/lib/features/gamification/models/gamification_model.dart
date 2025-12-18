// ============================================================================
// GAMIFICATION MODEL - SCAFFOLDED FOR PHASE 3
// ============================================================================
// Students: This file contains models for the gamification system.
//
// Phase 3 Learning Goals:
// - Work with multiple related models
// - Implement complex business logic in models
// - Create enums for type-safe constants
// - Apply patterns learned in Phase 1 and 2
//
// Scaffolding Level: 30% (Less help than previous phases - you are expected
// to apply patterns you learned earlier)
// ============================================================================

/// Badge types available in the app
///
/// Each badge has specific unlock criteria defined in GamificationService.
enum BadgeType {
  // Streak badges - consecutive days of assessments
  streak3Day,
  streak7Day,
  streak14Day,
  streak30Day,

  // Milestone badges - total assessment count
  firstAssessment,
  tenthAssessment,
  twentyFifthAssessment,
  fiftiethAssessment,
  hundredthAssessment,

  // Special badges
  earlyBird,      // Complete 5 assessments within first hour of window
  perfectWeek,    // Complete all 7 assessments in a week
  dedicated,      // Complete assessment every day for a month
}

/// Extension to add display properties to BadgeType
extension BadgeTypeExtension on BadgeType {
  /// Get the display name for this badge
  String get displayName {
    switch (this) {
      case BadgeType.streak3Day:
        return '3-Day Streak';
      case BadgeType.streak7Day:
        return '7-Day Streak';
      case BadgeType.streak14Day:
        return '14-Day Streak';
      case BadgeType.streak30Day:
        return '30-Day Streak';
      case BadgeType.firstAssessment:
        return 'First Steps';
      case BadgeType.tenthAssessment:
        return 'Getting Started';
      case BadgeType.twentyFifthAssessment:
        return 'Quarter Century';
      case BadgeType.fiftiethAssessment:
        return 'Halfway Hero';
      case BadgeType.hundredthAssessment:
        return 'Century Club';
      case BadgeType.earlyBird:
        return 'Early Bird';
      case BadgeType.perfectWeek:
        return 'Perfect Week';
      case BadgeType.dedicated:
        return 'Dedicated';
    }
  }

  /// Get the description for this badge
  String get description {
    switch (this) {
      case BadgeType.streak3Day:
        return 'Complete assessments for 3 consecutive days';
      case BadgeType.streak7Day:
        return 'Complete assessments for 7 consecutive days';
      case BadgeType.streak14Day:
        return 'Complete assessments for 14 consecutive days';
      case BadgeType.streak30Day:
        return 'Complete assessments for 30 consecutive days';
      case BadgeType.firstAssessment:
        return 'Complete your first assessment';
      case BadgeType.tenthAssessment:
        return 'Complete 10 assessments';
      case BadgeType.twentyFifthAssessment:
        return 'Complete 25 assessments';
      case BadgeType.fiftiethAssessment:
        return 'Complete 50 assessments';
      case BadgeType.hundredthAssessment:
        return 'Complete 100 assessments';
      case BadgeType.earlyBird:
        return 'Complete 5 assessments early in the day';
      case BadgeType.perfectWeek:
        return 'Complete all assessments in a week';
      case BadgeType.dedicated:
        return 'Complete assessments every day for a month';
    }
  }

  /// Get the icon name for this badge (use with Icons class)
  String get iconName {
    switch (this) {
      case BadgeType.streak3Day:
      case BadgeType.streak7Day:
      case BadgeType.streak14Day:
      case BadgeType.streak30Day:
        return 'local_fire_department';
      case BadgeType.firstAssessment:
        return 'star';
      case BadgeType.tenthAssessment:
      case BadgeType.twentyFifthAssessment:
      case BadgeType.fiftiethAssessment:
      case BadgeType.hundredthAssessment:
        return 'emoji_events';
      case BadgeType.earlyBird:
        return 'wb_sunny';
      case BadgeType.perfectWeek:
        return 'calendar_today';
      case BadgeType.dedicated:
        return 'workspace_premium';
    }
  }
}

// ============================================================================
// USER STATS MODEL
// ============================================================================

/// Represents the user's gamification statistics
///
/// This model holds all gamification-related data for a user:
/// - Total points earned
/// - Current streak (consecutive days)
/// - Longest streak achieved
/// - Total assessments completed
class UserStatsModel {
  final String odId;  // Unique ID for this stats record
  final String studyId;  // Links to user
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final int totalAssessments;
  final int earlyCompletions;  // Assessments completed early (for Early Bird badge)
  final DateTime lastAssessmentDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserStatsModel({
    String? odId,
    required this.studyId,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.totalAssessments = 0,
    this.earlyCompletions = 0,
    DateTime? lastAssessmentDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : odId = odId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        lastAssessmentDate = lastAssessmentDate ?? DateTime(2000),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  // ==========================================================================
  // LEVEL CALCULATION
  // ==========================================================================

  /// Calculate user's level based on total points
  ///
  /// Level formula: Level N requires N * 500 points
  /// Level 1: 0-499 points
  /// Level 2: 500-1499 points
  /// Level 3: 1500-2999 points
  /// etc.
  int get level {
    if (totalPoints < 500) return 1;
    // Formula: floor(sqrt(totalPoints / 250)) + 1
    // This gives a nice progression curve
    int lvl = 1;
    int required = 0;
    while (required <= totalPoints) {
      lvl++;
      required = (lvl * (lvl - 1) * 250);
    }
    return lvl - 1;
  }

  /// Get points required to reach the next level
  int get pointsToNextLevel {
    final nextLevel = level + 1;
    final required = nextLevel * (nextLevel - 1) * 250;
    return required - totalPoints;
  }

  /// Get progress percentage to next level (0.0 to 1.0)
  double get levelProgress {
    final currentLevelPoints = level * (level - 1) * 250;
    final nextLevelPoints = (level + 1) * level * 250;
    final pointsInCurrentLevel = totalPoints - currentLevelPoints;
    final pointsNeededForLevel = nextLevelPoints - currentLevelPoints;
    return pointsInCurrentLevel / pointsNeededForLevel;
  }

  // ==========================================================================
  // EXAMPLE: toMap() - FULLY IMPLEMENTED
  // ==========================================================================

  /// Convert to Map for database storage
  ///
  /// This follows the same pattern as Phase 1 and 2 models.
  Map<String, dynamic> toMap() {
    return {
      'id': odId,
      'study_id': studyId,
      'total_points': totalPoints,
      'current_streak': currentStreak,
      'longest_streak': longestStreak,
      'total_assessments': totalAssessments,
      'early_completions': earlyCompletions,
      'last_assessment_date': lastAssessmentDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // ==========================================================================
  // TODO 1: IMPLEMENT fromMap()
  // ==========================================================================

  /// Create UserStatsModel from database Map
  ///
  /// TODO: Implement this factory constructor
  /// Hints:
  /// 1. Follow the same pattern as AssessmentModel.fromMap()
  /// 2. Extract each field from the map
  /// 3. Parse DateTime strings using DateTime.parse()
  /// 4. Use proper type casting (as int, as String)
  ///
  /// Pattern:
  /// ```dart
  /// factory UserStatsModel.fromMap(Map<String, dynamic> map) {
  ///   return UserStatsModel(
  ///     odId: map['id'] as String,
  ///     studyId: map['study_id'] as String,
  ///     totalPoints: map['total_points'] as int,
  ///     // ... continue for all fields
  ///   );
  /// }
  /// ```
  factory UserStatsModel.fromMap(Map<String, dynamic> map) {
    // TODO: IMPLEMENT THIS METHOD
    // Apply the pattern you learned in Phase 1 and 2
    throw UnimplementedError('fromMap() not implemented yet');
  }

  // ==========================================================================
  // TODO 2: IMPLEMENT copyWith()
  // ==========================================================================

  /// Create a copy with some fields updated
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. All parameters should be optional (nullable)
  /// 2. Use the ?? operator: newValue ?? this.currentValue
  /// 3. Same pattern as Phase 1 and 2 models
  ///
  /// Example usage:
  /// ```dart
  /// final updated = stats.copyWith(
  ///   totalPoints: stats.totalPoints + 100,
  ///   currentStreak: stats.currentStreak + 1,
  /// );
  /// ```
  UserStatsModel copyWith({
    String? odId,
    String? studyId,
    int? totalPoints,
    int? currentStreak,
    int? longestStreak,
    int? totalAssessments,
    int? earlyCompletions,
    DateTime? lastAssessmentDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    // TODO: IMPLEMENT THIS METHOD
    // Apply the pattern you learned in Phase 1 and 2
    throw UnimplementedError('copyWith() not implemented yet');
  }

  @override
  String toString() {
    return 'UserStatsModel(studyId: $studyId, points: $totalPoints, level: $level, streak: $currentStreak)';
  }
}

// ============================================================================
// BADGE MODEL
// ============================================================================

/// Represents a badge earned by the user
class BadgeModel {
  final String id;
  final String studyId;
  final BadgeType badgeType;
  final DateTime earnedAt;

  BadgeModel({
    String? id,
    required this.studyId,
    required this.badgeType,
    DateTime? earnedAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        earnedAt = earnedAt ?? DateTime.now();

  // ==========================================================================
  // EXAMPLE: toMap() - FULLY IMPLEMENTED
  // ==========================================================================

  /// Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'study_id': studyId,
      'badge_type': badgeType.name,  // Enum to string
      'earned_at': earnedAt.toIso8601String(),
    };
  }

  // ==========================================================================
  // TODO 3: IMPLEMENT fromMap()
  // ==========================================================================

  /// Create BadgeModel from database Map
  ///
  /// TODO: Implement this factory constructor
  /// Hints:
  /// 1. For the badgeType, you need to convert string back to enum:
  ///    BadgeType.values.firstWhere((e) => e.name == map['badge_type'])
  /// 2. Parse the earnedAt DateTime
  ///
  /// Pattern:
  /// ```dart
  /// factory BadgeModel.fromMap(Map<String, dynamic> map) {
  ///   return BadgeModel(
  ///     id: map['id'] as String,
  ///     studyId: map['study_id'] as String,
  ///     badgeType: BadgeType.values.firstWhere(
  ///       (e) => e.name == map['badge_type'],
  ///     ),
  ///     earnedAt: DateTime.parse(map['earned_at'] as String),
  ///   );
  /// }
  /// ```
  factory BadgeModel.fromMap(Map<String, dynamic> map) {
    // TODO: IMPLEMENT THIS METHOD
    throw UnimplementedError('fromMap() not implemented yet');
  }

  @override
  String toString() {
    return 'BadgeModel(${badgeType.displayName}, earned: $earnedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BadgeModel &&
        other.studyId == studyId &&
        other.badgeType == badgeType;
  }

  @override
  int get hashCode => studyId.hashCode ^ badgeType.hashCode;
}

// ============================================================================
// POINTS CONSTANTS
// ============================================================================

/// Point values for various actions
///
/// These constants define how many points are awarded for each action.
/// You can reference these in GamificationService when calculating points.
class PointValues {
  static const int assessmentComplete = 100;
  static const int earlyBonus = 50;  // Completed in first hour
  static const int firstAssessment = 200;
  static const int weeklyBonus = 500;  // All 7 days completed
  static const int streakBonus3Day = 150;
  static const int streakBonus7Day = 300;
  static const int streakBonus14Day = 500;
  static const int streakBonus30Day = 1000;
}

// ============================================================================
// LEARNING NOTES:
// ============================================================================
//
// 1. Why use an enum for BadgeType?
//    - Type safety: Can only use defined badge types
//    - IDE support: Autocomplete for badge types
//    - Prevents typos: "streak3Day" vs "strek3Day"
//    - Easy to iterate: BadgeType.values gives all types
//
// 2. What is an extension?
//    - Adds methods to existing types
//    - BadgeTypeExtension adds displayName, description to BadgeType
//    - Keeps related code together
//    - Use: BadgeType.streak3Day.displayName
//
// 3. Level calculation explained:
//    - Uses quadratic formula for nice progression curve
//    - Level 1: 0 points, Level 2: 500, Level 3: 1500, etc.
//    - Each level requires more points than the previous
//    - This keeps players engaged longer
//
// 4. What is the ?? operator?
//    - Null coalescing operator
//    - Returns left side if not null, otherwise right side
//    - Example: name ?? 'Unknown' returns 'Unknown' if name is null
//    - Used extensively in copyWith() methods
//
// 5. Pattern Recognition from Phase 1 & 2:
//    - toMap(): Convert model to database format
//    - fromMap(): Create model from database data
//    - copyWith(): Create modified copies (immutability)
//    - Same patterns, different data!
//
// 6. Why separate PointValues class?
//    - Single source of truth for point values
//    - Easy to adjust game balance
//    - No magic numbers scattered in code
//    - Clear documentation of point system
//
// ============================================================================
