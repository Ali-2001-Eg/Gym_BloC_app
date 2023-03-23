import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_studt_app/bloc/workout_cubit.dart';
import 'package:flutter_studt_app/helpers/shared.dart';
import 'package:flutter_studt_app/model/exercise.dart';
import 'package:flutter_studt_app/model/workout.dart';
import 'package:flutter_studt_app/screens/edit_exercise_screen.dart';
import 'package:flutter_studt_app/screens/home_screen.dart';
import 'package:flutter_studt_app/states/workout_states.dart';

import '../bloc/workouts_cubit.dart';

class EditWorkoutScreen extends StatelessWidget {
  const EditWorkoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => BlocProvider.of<WorkoutCubit>(context).goHome(),
      child: BlocBuilder<WorkoutCubit, WorkoutStates>(
        builder: (context, state) {
          WorkoutEditingState we = state as WorkoutEditingState;
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: BackButton(
                  onPressed: () =>
                      BlocProvider.of<WorkoutCubit>(context).goHome(),
                ),
                title: InkWell(
                    onTap: () => showDialog(
                          context: context,
                          builder: (_) {
                            final controller = TextEditingController(
                              text: we.workout!.title
                            );

                            return AlertDialog(
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  labelText: 'Workout Title',
                                ),
                              ),
                              actions: [
                                TextButton(onPressed: (){
                                  if(controller.text.isNotEmpty){
                                    Navigator.pop(context);
                                    Workout renamed = we.workout!.copyWith(title: controller.text);
                                    BlocProvider.of<WorkoutsCubit>(context).saveWorkouts(renamed, we.index);
                                    BlocProvider.of<WorkoutCubit>(context).editWorkout(renamed, we.index);
                                  }
                                }, child: const Text('Save'))
                              ],
                            );
                          },
                        ),
                    child: Text(we.workout!.title!)),
              ),
              body: ListView.builder(
                itemCount: we.workout!.exercisesList.length,
                itemBuilder: (context, index) {
                  Exercise exercise =
                      we.workout!.exercisesList[index];
                  if (we.exIndex == index) {
                    return EditExerciseScreen(
                        we.workout, we.index, we.exIndex);
                  } else {
                    return ListTile(
                      leading: Text(formatTime(exercise.prelude!, true)),
                      title: Text(exercise.title!),
                      trailing: Text(formatTime(exercise.duration!, true)),
                      onTap: () => BlocProvider.of<WorkoutCubit>(context)
                          .editExercise(index),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
