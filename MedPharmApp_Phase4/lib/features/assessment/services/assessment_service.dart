// ============================================================================
// ASSESSMENT SERVICE - SCAFFOLDED FOR PHASE 2
// ============================================================================
// Students: This service handles all assessment-related database operations.
//
// Phase 2 Learning Goals:
// - Practice database patterns from Phase 1
// - Work with more complex queries (date filtering, ordering)
// - Handle "one per day" business logic
//
// Scaffolding Level: 60% (MORE examples than Phase 1)
// ============================================================================

import 'package:sqflite/sqflite.dart';
import '../../../core/services/database_service.dart';
import '../models/assessment_model.dart';

/// AssessmentService handles pain assessment data operations
///
/// Responsibilities:
/// - Save daily assessments
/// - Retrieve assessment history
/// - Check if today's assessment exists
/// - Query assessments by date range
class AssessmentService {
  final DatabaseService _databaseService;

  AssessmentService(this._databaseService);

  // ========================================================================
  // EXAMPLE METHOD 1 (FULLY IMPLEMENTED) - STUDY THIS!
  // ========================================================================

  /// Save assessment to database
  ///
  /// This shows the SAME pattern as Phase 1 AuthService.saveUser()
  /// Students: See how we handle the database insert operation
  Future<String> saveAssessment(AssessmentModel assessment) async {
    try {
      print('💾 Saving assessment: ${assessment.toString()}');

      final db = await _databaseService.database;

      // Convert model to Map
      final assessmentMap = assessment.toMap();

      // Insert into database
      await db.insert(
        'assessments',
        assessmentMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      print('✅ Assessment saved: ${assessment.id}');
      return assessment.id;
    } catch (e) {
      print('❌ Error saving assessment: $e');
      rethrow;
    }
  }

  // ========================================================================
  // EXAMPLE METHOD 2 (FULLY IMPLEMENTED) - STUDY THIS!
  // ========================================================================

  /// Get today's assessment if it exists
  ///
  /// This shows how to query by date range
  /// Students: Study the WHERE clause for date filtering
  Future<AssessmentModel?> getTodayAssessment(String studyId) async {
    try {
      final db = await _databaseService.database;

      // Calculate today's date range
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // Query assessments taken today
      final results = await db.query(
        'assessments',
        where: 'study_id = ? AND timestamp >= ? AND timestamp < ?',
        whereArgs: [
          studyId,
          startOfDay.toIso8601String(),
          endOfDay.toIso8601String(),
        ],
        limit: 1,
      );

      if (results.isEmpty) {
        print('ℹ️ No assessment found for today');
        return null;
      }

      final assessment = AssessmentModel.fromMap(results.first);
      print('✅ Found today\'s assessment: ${assessment.id}');
      return assessment;
    } catch (e) {
      print('❌ Error getting today\'s assessment: $e');
      rethrow;
    }
  }

  // ========================================================================
  // TODO 1: GET ASSESSMENT HISTORY
  // ========================================================================

  /// Get assessment history for a user
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Query the 'assessments' table
  /// 2. Filter by study_id: where: 'study_id = ?', whereArgs: [studyId]
  /// 3. Order by timestamp DESC (newest first): orderBy: 'timestamp DESC'
  /// 4. Use limit parameter to control how many results
  /// 5. Convert each result Map to AssessmentModel using fromMap()
  /// 6. Return List<AssessmentModel>
  ///
  /// Pattern:
  /// ```dart
  /// Future<List<AssessmentModel>> getAssessmentHistory(
  ///   String studyId, {
  ///   int limit = 30,
  /// }) async {
  ///   try {
  ///     final db = await _databaseService.database;
  ///
  ///     final results = await db.query(
  ///       'assessments',
  ///       where: 'study_id = ?',
  ///       whereArgs: [studyId],
  ///       orderBy: 'timestamp DESC',
  ///       limit: limit,
  ///     );
  ///
  ///     return results.map((map) => AssessmentModel.fromMap(map)).toList();
  ///   } catch (e) {
  ///     print('❌ Error getting history: $e');
  ///     rethrow;
  ///   }
  /// }
  /// ```
  Future<List<AssessmentModel>> getAssessmentHistory(
    String studyId, {
    int limit = 30,
  }) async {
    try {
      print('📜 Loading assessment history for $studyId');

      final db = await _databaseService.database;

      final results = await db.query(
        'assessments',
        where: 'study_id = ?',
        whereArgs: [studyId],
        orderBy: 'timestamp DESC',
        limit: limit,
      );

      final history = results.map((map) => AssessmentModel.fromMap(map)).toList();
      print('✅ Loaded ${history.length} assessments');
      return history;
    } catch (e) {
      print('❌ Error getting assessment history: $e');
      rethrow;
    }
  }

  // ========================================================================
  // TODO 2: GET ASSESSMENT COUNT
  // ========================================================================

  /// Get total number of assessments for a user
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Query assessments table
  /// 2. Filter by study_id
  /// 3. Use results.length to count
  /// 4. Return the count as int
  ///
  /// This is simpler than other methods!
  ///
  /// Pattern:
  /// ```dart
  /// Future<int> getAssessmentCount(String studyId) async {
  ///   try {
  ///     final db = await _databaseService.database;
  ///     final results = await db.query(
  ///       'assessments',
  ///       where: 'study_id = ?',
  ///       whereArgs: [studyId],
  ///     );
  ///     return results.length;
  ///   } catch (e) {
  ///     print('❌ Error counting assessments: $e');
  ///     return 0;
  ///   }
  /// }
  /// ```
  Future<int> getAssessmentCount(String studyId) async {
    try {
      final db = await _databaseService.database;

      final results = await db.query(
        'assessments',
        where: 'study_id = ?',
        whereArgs: [studyId],
      );

      print('📊 Assessment count for $studyId: ${results.length}');
      return results.length;
    } catch (e) {
      print('❌ Error counting assessments: $e');
      return 0;
    }
  }

  // ========================================================================
  // TODO 3: CHECK IF TODAY'S ASSESSMENT EXISTS (SIMPLER VERSION)
  // ========================================================================

  /// Check if user has already completed today's assessment
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Call getTodayAssessment() (already implemented above!)
  /// 2. Return true if result is not null
  /// 3. Return false if result is null
  ///
  /// This is a VERY simple method - just use the existing method!
  ///
  /// Pattern:
  /// ```dart
  /// Future<bool> hasTodayAssessment(String studyId) async {
  ///   final todayAssessment = await getTodayAssessment(studyId);
  ///   return todayAssessment != null;
  /// }
  /// ```
  Future<bool> hasTodayAssessment(String studyId) async {
    final todayAssessment = await getTodayAssessment(studyId);
    return todayAssessment != null;
  }

  // ========================================================================
  // HELPER METHODS (Already implemented)
  // ========================================================================

  /// Get assessments from last N days
  ///
  /// Example: Get last 7 days of assessments
  Future<List<AssessmentModel>> getRecentAssessments(
    String studyId, {
    int days = 7,
  }) async {
    try {
      final db = await _databaseService.database;

      // Calculate date range
      final now = DateTime.now();
      final startDate = now.subtract(Duration(days: days));

      final results = await db.query(
        'assessments',
        where: 'study_id = ? AND timestamp >= ?',
        whereArgs: [studyId, startDate.toIso8601String()],
        orderBy: 'timestamp DESC',
      );

      return results.map((map) => AssessmentModel.fromMap(map)).toList();
    } catch (e) {
      print('❌ Error getting recent assessments: $e');
      rethrow;
    }
  }

  /// Get average pain scores for a user
  ///
  /// Returns a map with 'nrs' and 'vas' averages
  Future<Map<String, double>> getAverageScores(String studyId) async {
    try {
      final db = await _databaseService.database;

      final results = await db.query(
        'assessments',
        where: 'study_id = ?',
        whereArgs: [studyId],
      );

      if (results.isEmpty) {
        return {'nrs': 0.0, 'vas': 0.0};
      }

      double totalNrs = 0;
      double totalVas = 0;

      for (var map in results) {
        totalNrs += (map['nrs_score'] as int).toDouble();
        totalVas += (map['vas_score'] as int).toDouble();
      }

      return {
        'nrs': totalNrs / results.length,
        'vas': totalVas / results.length,
      };
    } catch (e) {
      print('❌ Error calculating averages: $e');
      return {'nrs': 0.0, 'vas': 0.0};
    }
  }

  /// Delete an assessment (for testing or corrections)
  Future<void> deleteAssessment(String assessmentId) async {
    try {
      final db = await _databaseService.database;
      await db.delete(
        'assessments',
        where: 'id = ?',
        whereArgs: [assessmentId],
      );
      print('🗑️ Assessment deleted: $assessmentId');
    } catch (e) {
      print('❌ Error deleting assessment: $e');
      rethrow;
    }
  }

  /// Delete all assessments for a user (for testing)
  Future<void> deleteAllAssessments(String studyId) async {
    try {
      final db = await _databaseService.database;
      await db.delete(
        'assessments',
        where: 'study_id = ?',
        whereArgs: [studyId],
      );
      print('🗑️ All assessments deleted for $studyId');
    } catch (e) {
      print('❌ Error deleting assessments: $e');
      rethrow;
    }
  }
}

// ============================================================================
// LEARNING NOTES:
// ============================================================================
//
// 1. How is this different from Phase 1 AuthService?
//    - Works with lists (List<AssessmentModel>) not single objects
//    - Uses ORDER BY for sorting results
//    - More complex WHERE clauses (date ranges, multiple conditions)
//    - But SAME patterns: try-catch, print statements, rethrow
//
// 2. Understanding Date Queries:
//    - startOfDay: DateTime(year, month, day) → sets time to 00:00:00
//    - endOfDay: startOfDay + 1 day → next day at 00:00:00
//    - Query: timestamp >= start AND timestamp < end
//    - This captures all assessments in a specific day
//
// 3. Working with Lists:
//    - results.map((map) => Model.fromMap(map)).toList()
//    - .map() transforms each item
//    - .toList() converts back to List
//    - Common pattern in Dart!
//
// 4. ORDER BY clause:
//    - 'timestamp DESC' → newest first
//    - 'timestamp ASC' → oldest first
//    - DESC = descending, ASC = ascending
//
// 5. LIMIT clause:
//    - Limits number of results returned
//    - Performance optimization (don't load all data)
//    - Good for pagination: "Show last 30"
//
// 6. Pattern Recognition:
//    - saveAssessment() → Same as Phase 1 saveUser()
//    - getTodayAssessment() → Similar to getCurrentUser()
//    - Same error handling: try-catch-rethrow
//    - You already know these patterns from Phase 1!
//
// ============================================================================
