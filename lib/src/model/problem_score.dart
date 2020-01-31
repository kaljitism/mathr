import 'dart:collection';

import 'package:mathr/src/model/problem.dart';

import '../util.dart';
import 'score_entry.dart';

class ProblemScore {
  static const _maxEntries = 5;
  final _entries = ListQueue<ScoreEntry>();

  void scoreCurrentProblem(Problem problem, Duration elapsed) {
    _entries.add(ScoreEntry(problem.solved, problem.wrongAnswers, elapsed));

    while (_entries.length > _maxEntries) {
      _entries.removeLast();
    }
  }

  num get average => _entries.isEmpty
      ? null
      : _entries.map((element) => element.points).average;

  bool get hasEntries => _entries.isNotEmpty;

  int get entryCount => _entries.length;
}
