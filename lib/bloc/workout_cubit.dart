import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_studt_app/model/workout.dart';
import 'package:wakelock/wakelock.dart';

import '../states/workout_states.dart';

class WorkoutCubit extends Cubit<WorkoutStates> {
  WorkoutCubit() : super(const WorkoutInitialState());

  Timer? timer;

  editWorkout(Workout workoutModel, int index) {
    return emit(WorkoutEditingState(workoutModel, index, null));
  }

  editExercise(int exIndex) {
    print('editing $exIndex....');
    emit(WorkoutEditingState(
        state.workout, (state as WorkoutEditingState).index, exIndex));
  }

  goHome() => emit(const WorkoutInitialState());

  startWorkout(Workout workout, [int? index]) async {
    Wakelock.enable();
    if (index != null) {
    } else {
      emit(WorkoutInProgressState(workout, 0));
    }
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
  }

  void onTick(Timer timer) {
    if (state is WorkoutInProgressState) {
      WorkoutInProgressState wip = state as WorkoutInProgressState;
      if (wip.elapsed! < wip.workout!.getTotal) {
        emit(WorkoutInProgressState(wip.workout, wip.elapsed! + 1));
        // log('my elapsed time is ${wip.elapsed}');
      } else {
        timer.cancel();
        Wakelock.disable();
        emit(const WorkoutInitialState());
      }
    }
  }

  void pauseWorkout() =>
      emit(WorkoutPausedState(state.workout!, state.elapsed!));

  void resume() => emit(WorkoutInProgressState(state.workout!, state.elapsed!));
}
