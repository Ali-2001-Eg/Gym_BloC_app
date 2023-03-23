import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_studt_app/model/exercise.dart';
import 'package:flutter_studt_app/model/workout.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class WorkoutsCubit extends HydratedCubit<List<Workout>> {
  WorkoutsCubit() : super([]);

  getWorkouts() async {
    final List<Workout> workouts = [];
    final workoutJson =
        jsonDecode(await rootBundle.loadString('assets/json/workouts.json'));
    for (var element in (workoutJson as Iterable)) {
      workouts.add(Workout.fromJson(element));
    }
    emit(workouts);
  }

  saveWorkouts(Workout workoutModel, int index) {
    Workout newWorkout =
        Workout(title: workoutModel.title, exercisesList: []);
    for (var ex in workoutModel.exercisesList) {
      newWorkout.exercisesList.add(ex);
    }
    //to make this state view in the screen after modification
    state[index] = newWorkout;
    print('I have ${state.length} states');
    //spread operator to add state in the list
    emit([...state]);
  }



  @override
  List<Workout>? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    List<Workout> workouts = [];
    json['workouts'].forEach((el) {
      workouts.add(Workout.fromJson(el));
    });
    return workouts;
  }

  @override
  Map<String, dynamic>? toJson(List<Workout> state) {
    // TODO: implement toJson
    if (state is List<Workout>) {
      var json = {
        'workouts': [],
      };
      for (var workout in state) {
        json['workouts']!.add(workout.toJson());
      }
      return json;
    } else {
      return null;
    }
  }
}
