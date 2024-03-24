import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:karmafy/components/habit_tile.dart';
import 'package:karmafy/components/heat_map.dart';
import 'package:karmafy/components/my_drawer.dart';
import 'package:karmafy/db/habit_database.dart';
import 'package:karmafy/db/habit_database.dart';
import 'package:karmafy/models/habit.dart';
import 'package:karmafy/utils/habit_utils.dart';
import 'package:provider/provider.dart';

import '../db/habit_database.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();
  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: InputDecoration(hintText: "Create a habit"),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;
              //save to db
              context.read<HabitDatabase>().addHabit(newHabitName);

              Navigator.pop(context);
              textController.clear();
            },
            child: Text("Save"),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
              textController.clear();
            },
            child: Text("Cancel"),
          )
        ],
      ),
    );
  }

  void checkHabitOnOff(bool? value, Habit habit) {
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  //*delete habit
  void deleteHabit(Habit habit) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Delete Habit"),
              actions: [
                //delete btn
                MaterialButton(
                  onPressed: () {
                    context.read<HabitDatabase>().deleteHabit(habit.id);
                    Navigator.pop(context);
                  },
                  child: Text("Delete"),
                )

                //cancel btn
                ,
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                )
              ],
            ));
  }

  //*edit habit
  void editHabit(Habit habit) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Edit Habit"),
              content: TextField(
                controller: textController,
              ),
              actions: [
                //save btn
                MaterialButton(
                  onPressed: () {
                    String newHabitName = textController.text;

                    context
                        .read<HabitDatabase>()
                        .updateHabitName(habit.id, newHabitName);
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                )

                //cancel btn
                ,
                MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                    textController.clear();
                  },
                  child: const Text("Cancel"),
                )
              ],
            ));
  }

  @override
  void initState() {
    // TODO: implement initState
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        child: Icon(Icons.add),
      ),
      body: ListView(
        children: [
          //*heatmap
          _buildHeatMap(),
          //*habit list
          _buildHabitList()
        ],
      ),
    );
  }

  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();

    List<Habit> currentHabits = habitDatabase.currentHabits;

    return ListView.builder(
        itemCount: currentHabits.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final habit = currentHabits[index];

          bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
          return HabitTile(
            isCompleted: isCompletedToday,
            habitName: habit.name,
            onChanged: (value) => checkHabitOnOff(value, habit),
            editHabit: (context) => editHabit(habit),
            deleteHabit: (context) => deleteHabit(habit),
          );
        });
  }

  Widget _buildHeatMap() {
    final habitDatabase = context.watch<HabitDatabase>();
    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    return FutureBuilder(
        future: habitDatabase.getFirstLaunchedDate(),
        builder: (context, snapshot) {
          //once data available build the heatmap
          if (snapshot.hasData) {
            return MyHeatMap(
              startDate: snapshot.data!,
              datasets: prepHeatMapDataset(currentHabits),
            );
          } else {
            return Container();
          }
          //when no data is returned
        });
  }
}
