// ============================================================================
// GAMIFICATION SERVICE - SCAFFOLDED FOR PHASE 3
// ============================================================================
// Students: This service handles all gamification-related database operations.
//
// Phase 3 Learning Goals:
// - Implement complex business logic (streak calculation, badge checking)
// - Work with multiple database tables
// - Apply database patterns from Phase 1 and 2 independently
//
// Scaffolding Level: 30% (You should be comfortable with database patterns now)
// ============================================================================

import 'package:sqflite/sqflite.dart';
import '../../../core/services/database_service.dart';
import '../../assessment/services/assessment_service.dart';
import '../models/gamification_model.dart';

/// GamificationService handles points, levels, and badges
///
/// Responsibilities:
/// - Track and update user points
/// - Calculate and maintain streaks
/// - Award and store badges
/// - Provide gamification statistics
class GamificationService {
  final DatabaseService _databaseService;
  final AssessmentService _assessmentService;

  GamificationService(this._databaseService, this._assessmentService);

  // ==========================================================================
  // EXAMPLE: GET OR CREATE USER STATS - FULLY IMPLEMENTED
  // ==========================================================================

  /// Get user stats, creating initial record if none exists
  ///
  /// This method demonstrates:
  /// 1. Querying for existing data
  /// 2. Creating default data if none exists
  /// 3. Error handling pattern
  Future<UserStatsModel> getOrCreateUserStats(String studyId) async {
    try {
      final db = await _databaseService.database;

      // Try to find existing stats
      final results = await db.query(
        'user_stats',
        where: 'study_id = ?',
        whereArgs: [studyId],
        limit: 1,
      );

      if (results.isNotEmpty) {
        print('Found existing stats for $studyId');
        return UserStatsModel.fromMap(results.first);
      }

      // Create new stats if none exist
      print('Creating new stats for $studyId');
      final newStats = UserStatsModel(studyId: studyId);
      await db.insert('user_stats', newStats.toMap());
      return newStats;
    } catch (e) {
      print('Error getting/creating user stats: $e');
      rethrow;
    }
  }

  // ==========================================================================
  // EXAMPLE: SAVE USER STATS - FULLY IMPLEMENTED
  // ==========================================================================

  /// Save or update user stats
  Future<void> saveUserStats(UserStatsModel stats) async {
    try {
      final db = await _databaseService.database;

      // Update with new timestamp
      final updatedStats = stats.copyWith(updatedAt: DateTime.now());

      await db.insert(
        'user_stats',
        updatedStats.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('Stats saved: ${stats.totalPoints} points, level ${stats.level}');
    } catch (e) {
      print('Error saving user stats: $e');
      rethrow;
    }
  }

  // ==========================================================================
  // TODO 1: AWARD POINTS FOR ASSESSMENT
  // ==========================================================================

  /// Award points when user completes an assessment
  ///
  /// TODO: Implement this method
  ///
  /// This is the MAIN method that updates gamification after an assessment.
  /// It should:
  /// 1. Get current user stats using getOrCreateUserStats()
  /// 2. Calculate points to award:
  ///    - Base points: PointValues.assessmentComplete (100)
  ///    - If first assessment: add PointValues.firstAssessment (200)
  ///    - If early completion (isEarly parameter): add PointValues.earlyBonus (50)
  /// 3. Update streak:
  ///    - If lastAssessmentDate was yesterday: increment currentStreak
  ///    - If lastAssessmentDate was today: do nothing (already counted)
  ///    - Otherwise: reset currentStreak to 1
  /// 4. Update longestStreak if currentStreak > longestStreak
  /// 5. Increment totalAssessments
  /// 6. If isEarly, increment earlyCompletions
  /// 7. Update lastAssessmentDate to today
  /// 8. Save updated stats
  /// 9. Check for new badges (call checkAndAwardBadges)
  /// 10. Return the points awarded
  ///
  /// Hints:
  /// - Use DateTime.now() for current date
  /// - To check if dates are the same day:
  ///   ```dart
  ///   bool isSameDay(DateTime a, DateTime b) {
  ///     return a.year == b.year && a.month == b.month && a.day == b.day;
  ///   }
  ///   ```
  /// - To check if a date was yesterday:
  ///   ```dart
  ///   final yesterday = DateTime.now().subtract(Duration(days: 1));
  ///   bool wasYesterday = isSameDay(date, yesterday);
  ///   ```
  ///
  /// Example usage:
  /// ```dart
  /// final points = await gamificationService.awardPointsForAssessment(
  ///   studyId: 'STUDY123',
  ///   isEarly: true,
  /// );
  /// print('Awarded $points points!');
  /// ```
  Future<int> awardPointsForAssessment({
    required String studyId,
    bool isEarly = false,
  }) async {
    // TODO: IMPLEMENT THIS METHOD
    // This is the most important method in gamification!
    // Follow the steps outlined above.
    throw UnimplementedError('awardPointsForAssessment() not implemented yet');
  }

  // ==========================================================================
  // TODO 2: CHECK AND AWARD BADGES
  // ==========================================================================

  /// Check if user has earned any new badges and award them
  ///
  /// TODO: Implement this method
  ///
  /// This method should check all badge conditions and award new badges.
  /// Steps:
  /// 1. Get current user stats
  /// 2. Get already earned badges using getEarnedBadges()
  /// 3. Create a Set of earned badge types for easy lookup
  /// 4. Check each badge condition:
  ///
  ///    Milestone badges (based on totalAssessments):
  ///    - firstAssessment: totalAssessments >= 1
  ///    - tenthAssessment: totalAssessments >= 10
  ///    - twentyFifthAssessment: totalAssessments >= 25
  ///    - fiftiethAssessment: totalAssessments >= 50
  ///    - hundredthAssessment: totalAssessments >= 100
  ///
  ///    Streak badges (based on currentStreak):
  ///    - streak3Day: currentStreak >= 3
  ///    - streak7Day: currentStreak >= 7
  ///    - streak14Day: currentStreak >= 14
  ///    - streak30Day: currentStreak >= 30
  ///
  ///    Special badges:
  ///    - earlyBird: earlyCompletions >= 5
  ///    - perfectWeek: Check if all 7 days this week have assessments
  ///    - dedicated: longestStreak >= 30
  ///
  /// 5. For each badge earned (not already in earnedBadges), call saveBadge()
  /// 6. Return list of newly earned badges
  ///
  /// Hints:
  /// - Use Set.contains() to check if badge already earned
  /// - Create BadgeModel with studyId and badgeType
  /// - Return List<BadgeModel> of new badges
  ///
  /// Example:
  /// ```dart
  /// Future<List<BadgeModel>> checkAndAwardBadges(String studyId) async {
  ///   final stats = await getOrCreateUserStats(studyId);
  ///   final earnedBadges = await getEarnedBadges(studyId);
  ///   final earnedTypes = earnedBadges.map((b) => b.badgeType).toSet();
  ///   final newBadges = <BadgeModel>[];
  ///
  ///   // Check milestone badges
  ///   if (stats.totalAssessments >= 1 && !earnedTypes.contains(BadgeType.firstAssessment)) {
  ///     final badge = BadgeModel(studyId: studyId, badgeType: BadgeType.firstAssessment);
  ///     await saveBadge(badge);
  ///     newBadges.add(badge);
  ///   }
  ///   // ... check other badges
  ///
  ///   return newBadges;
  /// }
  /// ```
  Future<List<BadgeModel>> checkAndAwardBadges(String studyId) async {
    // TODO: IMPLEMENT THIS METHOD
    // Check all badge conditions and award new ones
    throw UnimplementedError('checkAndAwardBadges() not implemented yet');
  }

  // ==========================================================================
  // TODO 3: GET EARNED BADGES
  // ==========================================================================

  /// Get all badges earned by a user
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Query the 'user_badges' table
  /// 2. Filter by study_id
  /// 3. Order by earned_at DESC (newest first)
  /// 4. Convert each result to BadgeModel using fromMap()
  /// 5. Return List<BadgeModel>
  ///
  /// This is similar to getAssessmentHistory() from Phase 2!
  Future<List<BadgeModel>> getEarnedBadges(String studyId) async {
    // TODO: IMPLEMENT THIS METHOD
    // Same pattern as getting assessment history
    throw UnimplementedError('getEarnedBadges() not implemented yet');
  }

  // ==========================================================================
  // TODO 4: SAVE BADGE
  // ==========================================================================

  /// Save a new badge to the database
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Get database instance
  /// 2. Convert badge to map using toMap()
  /// 3. Insert into 'user_badges' table
  /// 4. Use ConflictAlgorithm.ignore to prevent duplicates
  ///
  /// This is similar to saveAssessment() from Phase 2!
  Future<void> saveBadge(BadgeModel badge) async {
    // TODO: IMPLEMENT THIS METHOD
    // Same pattern as saving an assessment
    throw UnimplementedError('saveBadge() not implemented yet');
  }

  // ==========================================================================
  // TODO 5: CALCULATE CURRENT STREAK
  // ==========================================================================

  /// Calculate the current streak from assessment history
  ///
  /// TODO: Implement this method
  ///
  /// A streak is the number of consecutive days with assessments.
  /// Steps:
  /// 1. Get assessment history using _assessmentService.getAssessmentHistory()
  /// 2. If empty, return 0
  /// 3. Sort by date (newest first) - should already be sorted
  /// 4. Start from today and count backwards
  /// 5. For each day, check if there's an assessment
  /// 6. Stop counting when a day is missed
  /// 7. Return the streak count
  ///
  /// Hints:
  /// - Use a loop starting from today
  /// - Check each day: does an assessment exist for this date?
  /// - Helper to check same day:
  ///   ```dart
  ///   bool hasAssessmentOnDate(List<AssessmentModel> assessments, DateTime date) {
  ///     return assessments.any((a) =>
  ///       a.timestamp.year == date.year &&
  ///       a.timestamp.month == date.month &&
  ///       a.timestamp.day == date.day
  ///     );
  ///   }
  ///   ```
  ///
  /// Example:
  /// If today is Friday and user has assessments on Fri, Thu, Wed, but not Tue:
  /// Streak = 3
  Future<int> calculateCurrentStreak(String studyId) async {
    // TODO: IMPLEMENT THIS METHOD
    // This requires working with dates - take your time!
    throw UnimplementedError('calculateCurrentStreak() not implemented yet');
  }

  // ==========================================================================
  // HELPER METHODS - FULLY IMPLEMENTED
  // ==========================================================================

  /// Check if two dates are the same day
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Check if a date was yesterday
  bool _wasYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return _isSameDay(date, yesterday);
  }

  /// Check if a date is today
  bool _isToday(DateTime date) {
    return _isSameDay(date, DateTime.now());
  }

  /// Get completion percentage (assessments completed / days enrolled)
  Future<double> getCompletionPercentage(String studyId) async {
    try {
      final stats = await getOrCreateUserStats(studyId);
      final daysSinceCreation = DateTime.now().difference(stats.createdAt).inDays + 1;

      if (daysSinceCreation <= 0) return 0.0;

      final percentage = (stats.totalAssessments / daysSinceCreation) * 100;
      return percentage.clamp(0.0, 100.0);
    } catch (e) {
      print('Error calculating completion percentage: $e');
      return 0.0;
    }
  }

  /// Get weekly completion data (for calendar view)
  ///
  /// Returns a map of date strings to boolean (completed or not)
  Future<Map<String, bool>> getWeeklyCompletion(String studyId) async {
    try {
      final assessments = await _assessmentService.getRecentAssessments(
        studyId,
        days: 7,
      );

      final completion = <String, bool>{};
      final today = DateTime.now();

      for (int i = 0; i < 7; i++) {
        final date = today.subtract(Duration(days: i));
        final dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
        final hasAssessment = assessments.any((a) => _isSameDay(a.timestamp, date));
        completion[dateKey] = hasAssessment;
      }

      return completion;
    } catch (e) {
      print('Error getting weekly completion: $e');
      return {};
    }
  }

  /// Delete all gamification data for a user (for testing)
  Future<void> deleteUserGamificationData(String studyId) async {
    try {
      final db = await _databaseService.database;
      await db.delete('user_stats', where: 'study_id = ?', whereArgs: [studyId]);
      await db.delete('user_badges', where: 'study_id = ?', whereArgs: [studyId]);
      print('Gamification data deleted for $studyId');
    } catch (e) {
      print('Error deleting gamification data: $e');
      rethrow;
    }
  }
}

// ============================================================================
// LEARNING NOTES:
// ============================================================================
//
// 1. Why does this service depend on AssessmentService?
//    - Gamification needs assessment data to calculate streaks
//    - Reuses existing assessment queries instead of duplicating
//    - This is called "composition" - building from existing parts
//
// 2. Understanding Streaks:
//    - A streak counts consecutive days with completed assessments
//    - If user misses a day, streak resets to 0
//    - Longest streak is tracked separately (never decreases)
//    - Streaks are a powerful motivation tool!
//
// 3. Badge Checking Strategy:
//    - Check all possible badges after each assessment
//    - Only award if not already earned (check earnedBadges)
//    - Store earned date for badge history
//    - Some badges can only be earned once (milestones)
//    - Some badges can theoretically be earned multiple times
//      (but we track first earn only)
//
// 4. Point Calculation:
//    - Base points for every assessment (100)
//    - Bonus for early completion (50)
//    - First assessment bonus (200)
//    - Weekly completion bonus (500)
//    - Streak bonuses at milestones
//
// 5. Error Handling:
//    - Always use try-catch for database operations
//    - Print error for debugging
//    - Rethrow to let caller handle (or return safe default)
//
// 6. Date Handling Tips:
//    - DateTime.now() gets current date and time
//    - subtract(Duration(days: 1)) gets yesterday
//    - Compare year, month, day for "same day" check
//    - toIso8601String() for database storage
//    - DateTime.parse() to read back
//
// ============================================================================
