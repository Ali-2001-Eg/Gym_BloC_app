import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_studt_app/bloc/workouts_cubit.dart';
import 'package:flutter_studt_app/helpers/shared.dart';
import 'package:flutter_studt_app/model/workout.dart';
import 'package:numberpicker/numberpicker.dart';

class EditExerciseScreen extends StatefulWidget {
  final int index;
  final Workout? workoutModel;
  final int? exIndex;

  const EditExerciseScreen(this.workoutModel, this.index, this.exIndex,
      {Key? key})
      : super(key: key);

  @override
  State<EditExerciseScreen> createState() => _EditExerciseScreenState();
}

class _EditExerciseScreenState extends State<EditExerciseScreen> {
  TextEditingController? title;

  @override
  void initState() {
    title = TextEditingController(
      text: widget.workoutModel!.exercisesList[widget.exIndex!].title,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                onLongPress: () => showDialog(
                  context: context,
                  builder: (_) {
                    final controller = TextEditingController(
                      text: widget
                          .workoutModel!.exercisesList[widget.exIndex!].prelude
                          .toString(),
                    );
                    return AlertDialog(
                      content: TextField(
                        maxLength: 3,
                        controller: controller,
                        decoration:
                            const InputDecoration(labelText: 'Prelude Seconds'),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              Navigator.pop(context);
                              setState(() {
                                widget.workoutModel!
                                        .exercisesList[widget.exIndex!] =
                                    widget.workoutModel!
                                        .exercisesList[widget.exIndex!]
                                        .copyWith(
                                  prelude: int.parse(controller.text),
                                );
                              });
                              BlocProvider.of<WorkoutsCubit>(context)
                                  .saveWorkouts(
                                      widget.workoutModel!, widget.index);
                            }
                          },
                          child: Text('Save'),
                        )
                      ],
                    );
                  },
                ),
                child: NumberPicker(
                  minValue: 0,
                  maxValue: 3599,
                  value: widget
                      .workoutModel!.exercisesList[widget.exIndex!].prelude!,
                  onChanged: (value) {
                    setState(() {
                      widget.workoutModel!.exercisesList[widget.exIndex!] =
                          widget.workoutModel!.exercisesList[widget.exIndex!]
                              .copyWith(
                        prelude: value,
                      );
                    });
                    BlocProvider.of<WorkoutsCubit>(context)
                        .saveWorkouts(widget.workoutModel!, widget.index);
                  },
                  itemHeight: 30,
                  textMapper: (strVal) => formatTime(int.parse(strVal), false),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: TextField(
                controller: title,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    widget.workoutModel!.exercisesList[widget.exIndex!] = widget
                        .workoutModel!.exercisesList[widget.exIndex!]
                        .copyWith(
                      title: value,
                    );
                  });
                  BlocProvider.of<WorkoutsCubit>(context)
                      .saveWorkouts(widget.workoutModel!, widget.index);
                },
              ),
            ),
            Expanded(
              child: InkWell(
                onLongPress: () => showDialog(
                  context: context,
                  builder: (_) {
                    final controller = TextEditingController(
                      text: widget
                          .workoutModel!.exercisesList[widget.exIndex!].duration
                          .toString(),
                    );
                    return AlertDialog(
                      content: TextField(
                        maxLength: 3,
                        controller: controller,
                        decoration: const InputDecoration(
                          labelText: 'Duration Seconds',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            if (controller.text.isNotEmpty) {
                              Navigator.pop(context);

                              setState(() {
                                widget.workoutModel!
                                        .exercisesList[widget.exIndex!] =
                                    widget.workoutModel!
                                        .exercisesList[widget.exIndex!]
                                        .copyWith(
                                  duration: int.parse(controller.text),
                                );
                              });
                              BlocProvider.of<WorkoutsCubit>(context)
                                  .saveWorkouts(
                                      widget.workoutModel!, widget.index);
                            }
                          },
                          child: Text('Save'),
                        )
                      ],
                    );
                  },
                ),
                child: NumberPicker(
                  minValue: 0,
                  maxValue: 3599,
                  value: widget
                      .workoutModel!.exercisesList[widget.exIndex!].duration!,
                  onChanged: (value) {
                    setState(() {
                      widget.workoutModel!.exercisesList[widget.exIndex!] =
                          widget.workoutModel!.exercisesList[widget.exIndex!]
                              .copyWith(
                        duration: value,
                      );
                    });
                    BlocProvider.of<WorkoutsCubit>(context)
                        .saveWorkouts(widget.workoutModel!, widget.index);
                  },
                  itemHeight: 30,
                  textMapper: (strVal) => formatTime(int.parse(strVal), false),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
