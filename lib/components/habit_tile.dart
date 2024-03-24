import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final bool isCompleted;
  final String habitName;

  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deleteHabit;

  const HabitTile(
      {super.key,
      required this.isCompleted,
      required this.habitName,
      required this.onChanged,
      required this.editHabit,
      required this.deleteHabit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const StretchMotion(), children: [
        //edit option
        SlidableAction(
          onPressed: editHabit,
          backgroundColor: Colors.grey,
          icon: Icons.settings,
        ),
        SlidableAction(
          onPressed: deleteHabit,
          backgroundColor: Colors.red,
          icon: Icons.delete,
        )
      ]),
      child: GestureDetector(
        onTap: () {
          if (onChanged != null) {
            onChanged!(!isCompleted);
          }
        },
        child: Container(
            decoration: BoxDecoration(
              color: isCompleted ? Colors.green : Colors.grey.shade200,
            ),
            margin: const EdgeInsets.all(18),
            padding: EdgeInsets.all(10),
            child: ListTile(
              leading: Checkbox(
                onChanged: onChanged,
                value: isCompleted,
              ),
              title: Text(
                habitName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )),
      ),
    );
  }
}
