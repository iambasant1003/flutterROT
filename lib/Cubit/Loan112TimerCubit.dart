import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class Loan112TimerCubit extends Cubit<int> {
  Loan112TimerCubit() : super(0); // default to 0

  Timer? _timer;

  /// Start timer with a given duration from backend
  void startTimer(int durationInSeconds) {
    _timer?.cancel(); // cancel if already running
    emit(durationInSeconds); // set backend value

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        emit(state - 1);
      } else {
        _timer?.cancel();
      }
    });
  }

  /// Reset timer back to a given duration
  void resetTimer(int durationInSeconds) {
    _timer?.cancel();
    emit(durationInSeconds);
  }

  /// Stop timer completely
  void stopTimer() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
