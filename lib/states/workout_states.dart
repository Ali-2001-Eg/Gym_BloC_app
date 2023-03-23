import 'package:equatable/equatable.dart';
import 'package:flutter_studt_app/model/workout.dart';

abstract class WorkoutStates extends Equatable {
  final Workout? workout;
  final int? elapsed;

  const WorkoutStates({required this.workout, required this.elapsed});
}

class WorkoutInitialState extends WorkoutStates {
  const WorkoutInitialState() : super(workout: null, elapsed: 0);

  @override
  List<Object?> get props => [elapsed, workout];
}

class WorkoutEditingState extends WorkoutStates {
  const WorkoutEditingState(Workout? workoutModel,this.index, this.exIndex)
      : super(workout: workoutModel, elapsed: 0);
  final int index;
  final int? exIndex;
  @override
  List<Object?> get props => [workout,index,exIndex];
}

class WorkoutInProgressState extends WorkoutStates{
   const WorkoutInProgressState(Workout? workout, int? elapsed)
       : super(workout:workout,elapsed: elapsed);

  @override
  List<Object?> get props => [workout,elapsed];
}

class WorkoutPausedState extends WorkoutStates{
   const WorkoutPausedState(Workout? workout,int? elapsed)
      : super(workout: workout,elapsed: elapsed);

  @override
  List<Object?> get props => [workout,elapsed];
}

