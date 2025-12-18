// ============================================================================
// ASSESSMENT PROVIDER - SCAFFOLDED FOR PHASE 2
// ============================================================================
// Students: This provider manages assessment state and coordinates with the service.
//
// Phase 2 Learning Goals:
// - Apply Provider patterns from Phase 1
// - Handle more complex state (lists, today's assessment check)
// - Work with business logic ("one per day" rule)
//
// Scaffolding Level: 60% (MORE examples than Phase 1)
// ============================================================================

import 'package:flutter/foundation.dart';
import '../models/assessment_model.dart';
import '../services/assessment_service.dart';

/// AssessmentProvider manages assessment state
///
/// Responsibilities:
/// - Submit new assessments
/// - Load assessment history
/// - Check if today's assessment exists
/// - Manage loading/error states
class AssessmentProvider with ChangeNotifier {
  final AssessmentService _assessmentService;

  AssessmentProvider(this._assessmentService);

  // ========================================================================
  // STATE
  // ========================================================================

  AssessmentModel? _todayAssessment;
  List<AssessmentModel> _assessmentHistory = [];
  bool _isLoading = false;
  String? _errorMessage;

  // ========================================================================
  // GETTERS
  // ========================================================================

  AssessmentModel? get todayAssessment => _todayAssessment;
  List<AssessmentModel> get assessmentHistory => _assessmentHistory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Check if user can submit assessment today
  bool get canSubmitToday => _todayAssessment == null;

  // ========================================================================
  // EXAMPLE METHOD 1 (FULLY IMPLEMENTED) - STUDY THIS!
  // ========================================================================

  /// Submit a new pain assessment
  ///
  /// This shows the SAME pattern as Phase 1 AuthProvider.enrollUser()
  /// Students: See how we handle business logic and state updates
  Future<void> submitAssessment({
    required String studyId,
    required int nrsScore,
    required int vasScore,
  }) async {
    try {
      print('📝 Submitting assessment (NRS: $nrsScore, VAS: $vasScore)');

      // Set loading state
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Check if already submitted today
      final existing = await _assessmentService.getTodayAssessment(studyId);
      if (existing != null) {
        _errorMessage = 'You have already submitted an assessment today';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Create new assessment
      final assessment = AssessmentModel(
        studyId: studyId,
        nrsScore: nrsScore,
        vasScore: vasScore,
        timestamp: DateTime.now(),
      );

      // Save to database
      await _assessmentService.saveAssessment(assessment);

      // Update state
      _todayAssessment = assessment;

      // Add to history at the beginning (newest first)
      _assessmentHistory.insert(0, assessment);

      print('✅ Assessment submitted successfully');

      // Clear loading state
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ Error submitting assessment: $e');
      _isLoading = false;
      _errorMessage = 'Failed to submit assessment. Please try again.';
      notifyListeners();
    }
  }

  // ========================================================================
  // EXAMPLE METHOD 2 (FULLY IMPLEMENTED) - STUDY THIS!
  // ========================================================================

  /// Load today's assessment if it exists
  ///
  /// This shows how to load a single item and update state
  /// Students: Compare with Phase 1 AuthProvider patterns
  Future<void> loadTodayAssessment(String studyId) async {
    try {
      print('🔍 Loading today\'s assessment');

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final assessment = await _assessmentService.getTodayAssessment(studyId);
      _todayAssessment = assessment;

      if (assessment != null) {
        print('✅ Found today\'s assessment: ${assessment.id}');
      } else {
        print('ℹ️ No assessment submitted today');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ Error loading today\'s assessment: $e');
      _isLoading = false;
      _errorMessage = 'Failed to load assessment';
      notifyListeners();
    }
  }

  // ========================================================================
  // TODO 1: LOAD ASSESSMENT HISTORY
  // ========================================================================

  /// Load assessment history for the user
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. Same pattern as loadTodayAssessment() above
  /// 2. Call _assessmentService.getAssessmentHistory(studyId, limit: limit)
  /// 3. Update _assessmentHistory state variable
  /// 4. Don't forget: try-catch, loading states, notifyListeners()
  ///
  /// Pattern:
  /// ```dart
  /// Future<void> loadAssessmentHistory(String studyId, {int limit = 30}) async {
  ///   try {
  ///     _isLoading = true;
  ///     _errorMessage = null;
  ///     notifyListeners();
  ///
  ///     final history = await _assessmentService.getAssessmentHistory(
  ///       studyId,
  ///       limit: limit,
  ///     );
  ///     _assessmentHistory = history;
  ///
  ///     _isLoading = false;
  ///     notifyListeners();
  ///   } catch (e) {
  ///     _isLoading = false;
  ///     _errorMessage = 'Failed to load history';
  ///     notifyListeners();
  ///   }
  /// }
  /// ```
  Future<void> loadAssessmentHistory(String studyId, {int limit = 30}) async {
    try {
      print('📜 Loading assessment history');

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final history = await _assessmentService.getAssessmentHistory(
        studyId,
        limit: limit,
      );
      _assessmentHistory = history;

      print('✅ Loaded ${history.length} assessments');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ Error loading assessment history: $e');
      _isLoading = false;
      _errorMessage = 'Failed to load assessment history';
      notifyListeners();
    }
  }

  // ========================================================================
  // TODO 2: REFRESH ALL DATA
  // ========================================================================

  /// Refresh both today's assessment and history
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. This is a SIMPLE method - just call the two existing methods!
  /// 2. Call loadTodayAssessment(studyId)
  /// 3. Call loadAssessmentHistory(studyId)
  /// 4. Both are already implemented, so this is easy!
  ///
  /// Pattern:
  /// ```dart
  /// Future<void> refreshAssessments(String studyId) async {
  ///   await loadTodayAssessment(studyId);
  ///   await loadAssessmentHistory(studyId);
  /// }
  /// ```
  Future<void> refreshAssessments(String studyId) async {
    await loadTodayAssessment(studyId);
    await loadAssessmentHistory(studyId);
  }

  // ========================================================================
  // TODO 3: CLEAR ERROR MESSAGE
  // ========================================================================

  /// Clear the current error message
  ///
  /// TODO: Implement this method
  /// Hints:
  /// 1. This is the SIMPLEST method in this file!
  /// 2. Set _errorMessage to null
  /// 3. Call notifyListeners()
  /// 4. That's it!
  ///
  /// Pattern:
  /// ```dart
  /// void clearError() {
  ///   _errorMessage = null;
  ///   notifyListeners();
  /// }
  /// ```
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ========================================================================
  // HELPER METHODS (Already implemented)
  // ========================================================================

  /// Get assessment count
  Future<int> getAssessmentCount(String studyId) async {
    try {
      return await _assessmentService.getAssessmentCount(studyId);
    } catch (e) {
      print('❌ Error getting assessment count: $e');
      return 0;
    }
  }

  /// Get average pain scores
  Future<Map<String, double>> getAverageScores(String studyId) async {
    try {
      return await _assessmentService.getAverageScores(studyId);
    } catch (e) {
      print('❌ Error getting average scores: $e');
      return {'nrs': 0.0, 'vas': 0.0};
    }
  }

  /// Clear all state (for testing)
  void clearState() {
    _todayAssessment = null;
    _assessmentHistory = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}

// ============================================================================
// LEARNING NOTES:
// ============================================================================
//
// 1. How is this different from Phase 1 AuthProvider?
//    - Works with LISTS (_assessmentHistory) not just single objects
//    - Has business logic: "one assessment per day" rule
//    - Multiple load methods (today vs history)
//    - But SAME patterns: try-catch, loading states, notifyListeners()
//
// 2. Understanding the "One Per Day" Rule:
//    - submitAssessment() checks getTodayAssessment() first
//    - If exists, set error message and return early
//    - This is "business logic" - rules about how the app works
//    - User sees error: "You have already submitted..."
//
// 3. Working with Lists in State:
//    - _assessmentHistory is a List<AssessmentModel>
//    - insert(0, item) adds to beginning (newest first)
//    - When we load from DB, we replace entire list
//    - UI will rebuild when list changes (thanks to notifyListeners!)
//
// 4. The canSubmitToday Getter:
//    - Computed property (calculated on demand)
//    - No need to call notifyListeners() - it's just a getter
//    - Returns true if _todayAssessment is null
//    - UI can use this to enable/disable submit button
//
// 5. Pattern Recognition from Phase 1:
//    - submitAssessment() → Same as enrollUser()
//      * Set loading true
//      * Do operation
//      * Update state
//      * Set loading false
//      * Handle errors
//    - loadTodayAssessment() → Similar to loading current user
//    - clearError() → Simple state update pattern
//
// 6. Why insert(0, assessment)?
//    - insert(0, x) adds to beginning of list
//    - We want newest assessments first
//    - Alternative: _assessmentHistory.add(x) adds to end
//    - UI typically shows newest → oldest
//
// 7. Error Handling Strategy:
//    - Business rule violation: Set error message, don't throw
//    - Database/system errors: Catch and show user-friendly message
//    - Always clear error at start of operation
//    - User can see error in UI via Consumer<AssessmentProvider>
//
// 8. State Management Best Practices:
//    - Always set _isLoading before async operations
//    - Always clear _errorMessage at start (assume success)
//    - Always call notifyListeners() after state changes
//    - Use try-catch for all async operations
//
// ============================================================================
