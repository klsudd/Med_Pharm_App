// ============================================================================
// GAMIFICATION PROVIDER - SCAFFOLDED FOR PHASE 3
// ============================================================================
// Students: This provider manages gamification state for the UI.
//
// Phase 3 Learning Goals:
// - Manage complex state (stats, badges, newly earned items)
// - Coordinate between service calls
// - Handle loading states for multiple operations
// - Apply Provider patterns independently
//
// Scaffolding Level: 30% (Apply what you learned in Phase 1 and 2)
// ============================================================================

import 'package:flutter/foundation.dart';
import '../models/gamification_model.dart';
import '../services/gamification_service.dart';

/// GamificationProvider manages gamification state
///
/// Responsibilities:
/// - Hold current user stats (points, level, streak)
/// - Track earned badges
/// - Notify UI of newly earned badges
/// - Manage loading states
class GamificationProvider with ChangeNotifier {
  final GamificationService _gamificationService;

  GamificationProvider(this._gamificationService);

  // ==========================================================================
  // STATE VARIABLES
  // ==========================================================================

  /// Current user's gamification stats
  UserStatsModel? _userStats;

  /// List of all earned badges
  List<BadgeModel> _earnedBadges = [];

  /// Badges earned in the most recent action (for celebration UI)
  List<BadgeModel> _newlyEarnedBadges = [];

  /// Points awarded in the most recent action (for animation)
  int _lastPointsAwarded = 0;

  /// Loading state
  bool _isLoading = false;

  /// Error message
  String? _errorMessage;

  // ==========================================================================
  // GETTERS
  // ==========================================================================

  UserStatsModel? get userStats => _userStats;
  List<BadgeModel> get earnedBadges => _earnedBadges;
  List<BadgeModel> get newlyEarnedBadges => _newlyEarnedBadges;
  int get lastPointsAwarded => _lastPointsAwarded;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Get current level (0 if no stats)
  int get currentLevel => _userStats?.level ?? 0;

  /// Get total points (0 if no stats)
  int get totalPoints => _userStats?.totalPoints ?? 0;

  /// Get current streak (0 if no stats)
  int get currentStreak => _userStats?.currentStreak ?? 0;

  /// Get progress to next level (0.0 to 1.0)
  double get levelProgress => _userStats?.levelProgress ?? 0.0;

  /// Get points needed for next level
  int get pointsToNextLevel => _userStats?.pointsToNextLevel ?? 500;

  /// Check if there are new badges to celebrate
  bool get hasNewBadges => _newlyEarnedBadges.isNotEmpty;

  // ==========================================================================
  // EXAMPLE: LOAD USER STATS - FULLY IMPLEMENTED
  // ==========================================================================

  /// Load user gamification stats from database
  ///
  /// This shows the pattern for loading data into provider state.
  Future<void> loadUserStats(String studyId) async {
    try {
      print('Loading gamification stats for $studyId');

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Load stats from service
      final stats = await _gamificationService.getOrCreateUserStats(studyId);
      _userStats = stats;

      // Also load badges
      final badges = await _gamificationService.getEarnedBadges(studyId);
      _earnedBadges = badges;

      print('Loaded stats: Level ${stats.level}, ${stats.totalPoints} points');
      print('Loaded ${badges.length} badges');

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading gamification stats: $e');
      _isLoading = false;
      _errorMessage = 'Failed to load gamification data';
      notifyListeners();
    }
  }

  // ==========================================================================
  // TODO 1: RECORD ASSESSMENT COMPLETION
  // ==========================================================================

  /// Record that user completed an assessment and award points/badges
  ///
  /// TODO: Implement this method
  ///
  /// This is called after an assessment is submitted successfully.
  /// Steps:
  /// 1. Set loading state, clear previous newly earned badges
  /// 2. Call _gamificationService.awardPointsForAssessment()
  /// 3. Store the points returned in _lastPointsAwarded
  /// 4. Call _gamificationService.checkAndAwardBadges()
  /// 5. Store new badges in _newlyEarnedBadges
  /// 6. Reload user stats to get updated values
  /// 7. Clear loading, notify listeners
  /// 8. Handle errors with try-catch
  ///
  /// The isEarly parameter indicates if the assessment was completed
  /// in the first hour of the available window.
  ///
  /// Example usage (called from AssessmentProvider after submit):
  /// ```dart
  /// await gamificationProvider.recordAssessmentCompletion(
  ///   studyId: 'STUDY123',
  ///   isEarly: true,
  /// );
  /// if (gamificationProvider.hasNewBadges) {
  ///   // Show celebration dialog
  /// }
  /// ```
  Future<void> recordAssessmentCompletion({
    required String studyId,
    bool isEarly = false,
  }) async {
    // TODO: IMPLEMENT THIS METHOD
    // This connects assessment completion to gamification
    throw UnimplementedError('recordAssessmentCompletion() not implemented yet');
  }

  // ==========================================================================
  // TODO 2: REFRESH ALL GAMIFICATION DATA
  // ==========================================================================

  /// Refresh all gamification data from database
  ///
  /// TODO: Implement this method
  /// Steps:
  /// 1. Set loading state
  /// 2. Reload user stats using getOrCreateUserStats
  /// 3. Reload earned badges using getEarnedBadges
  /// 4. Clear loading, notify listeners
  /// 5. Handle errors
  ///
  /// This is similar to refreshAssessments() from Phase 2!
  Future<void> refreshGamificationData(String studyId) async {
    // TODO: IMPLEMENT THIS METHOD
    // Same pattern as Phase 2 refresh methods
    throw UnimplementedError('refreshGamificationData() not implemented yet');
  }

  // ==========================================================================
  // TODO 3: CLEAR NEW BADGES
  // ==========================================================================

  /// Clear the newly earned badges after they've been shown
  ///
  /// TODO: Implement this method
  ///
  /// This should be called after showing the badge celebration UI.
  /// Steps:
  /// 1. Set _newlyEarnedBadges to empty list
  /// 2. Set _lastPointsAwarded to 0
  /// 3. Call notifyListeners()
  ///
  /// This is the simplest TODO in this file!
  void clearNewBadges() {
    // TODO: IMPLEMENT THIS METHOD
    // Very simple - just clear the lists and notify
    throw UnimplementedError('clearNewBadges() not implemented yet');
  }

  // ==========================================================================
  // HELPER METHODS - FULLY IMPLEMENTED
  // ==========================================================================

  /// Get completion percentage
  Future<double> getCompletionPercentage(String studyId) async {
    try {
      return await _gamificationService.getCompletionPercentage(studyId);
    } catch (e) {
      print('Error getting completion percentage: $e');
      return 0.0;
    }
  }

  /// Get weekly completion for calendar
  Future<Map<String, bool>> getWeeklyCompletion(String studyId) async {
    try {
      return await _gamificationService.getWeeklyCompletion(studyId);
    } catch (e) {
      print('Error getting weekly completion: $e');
      return {};
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset state (for logout)
  void resetState() {
    _userStats = null;
    _earnedBadges = [];
    _newlyEarnedBadges = [];
    _lastPointsAwarded = 0;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Check if a specific badge type is earned
  bool hasBadge(BadgeType badgeType) {
    return _earnedBadges.any((b) => b.badgeType == badgeType);
  }

  /// Get all unearned badge types (for badge gallery)
  List<BadgeType> get unearnedBadgeTypes {
    final earnedTypes = _earnedBadges.map((b) => b.badgeType).toSet();
    return BadgeType.values.where((t) => !earnedTypes.contains(t)).toList();
  }
}

// ============================================================================
// LEARNING NOTES:
// ============================================================================
//
// 1. Why track newlyEarnedBadges separately?
//    - Allows showing celebration UI only for NEW badges
//    - User doesn't get repeat celebrations for old badges
//    - Clear after showing to prevent re-showing
//
// 2. Why track lastPointsAwarded?
//    - For points animation on completion screen
//    - Shows "+100" or "+150" as feedback
//    - Clear after showing so it's not stale
//
// 3. State Management Pattern:
//    - All state is private (_userStats)
//    - Public getters for reading (userStats)
//    - Methods for modifying (recordAssessmentCompletion)
//    - notifyListeners() after every state change
//
// 4. Computed Properties:
//    - currentLevel, totalPoints, currentStreak are getters
//    - They compute values from _userStats
//    - Return safe defaults (0) if stats not loaded
//    - No need to store separately!
//
// 5. Integration with Assessment Flow:
//    - After AssessmentProvider.submitAssessment() succeeds
//    - Call GamificationProvider.recordAssessmentCompletion()
//    - Check hasNewBadges to show celebration
//    - This keeps features loosely coupled
//
// 6. Error Handling Pattern:
//    - Set _errorMessage on failure
//    - UI can show error from provider
//    - clearError() to dismiss
//    - Same pattern as Phase 1 and 2!
//
// ============================================================================
