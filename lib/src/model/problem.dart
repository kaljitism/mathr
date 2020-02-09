import 'package:flutter/foundation.dart';

import 'problem_data.dart';

class Problem<T> extends ChangeNotifier {
  final ProblemData<T> data;
  final answers = <AnswerModel<T>>[];
  int _wrongAnswers = 0;
  bool _solved = false;

  Problem(this.data, Iterable<T> answerValues)
      : assert(
          answerValues.any((element) => element == data.solution),
          'At least one answer should be the right solution.',
        ) {
    answers.addAll(answerValues.map((e) => AnswerModel(e, this)));
  }

  bool get solved => _solved;

  int get incorrectAttempts => _wrongAnswers;

  AnswerModel<T> get correctAnswer =>
      answers.singleWhere((element) => element.value == data.solution);

  void _click(AnswerModel answer) {
    assert(answers.contains(answer));
    assert(answer._enabled);

    if (answer.value == data.solution) {
      _solved = true;
      for (var value in answers) {
        value._enabled = false;
      }
    } else {
      _wrongAnswers++;
      answer._enabled = false;
    }
    notifyListeners();
  }

  @override
  bool operator ==(Object other) => other is Problem && other.data == data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Problem: $data';
}

class AnswerModel<T> {
  final T value;
  final Problem _parent;

  bool _enabled = true;

  AnswerModel(this.value, this._parent);

  bool get enabled => _enabled;

  void Function() get onClick {
    if (!_enabled) {
      return null;
    }

    return () => _parent._click(this);
  }
}
