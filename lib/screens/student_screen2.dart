import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:my_schedule/model/schedule_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int selectedDay = DateTime.now().weekday % 7;
  // Get current day of the week (0 = Sunday, 6 = Saturday)
  final List<String> days = ["S", "M", "T", "W", "TH", "F", "SA"];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController
        .dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8F8E8E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8F8E8E),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Option 1'),
              onTap: () {},
            ),
            ListTile(
              title: const Text('Option 2'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Juan Dela Cruztzy",
              style: TextStyle(fontSize: 40),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: days.asMap().entries.map((entry) {
                        int index = entry.key;
                        String day = entry.value;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedDay = index;
                            });
                          },
                          child: SizedBox(
                            width: 50,
                            height: 55,
                            child: Container(
                              margin: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: selectedDay == index
                                    ? const Color(0xFF862349)
                                    : Color(0xFFECECEC),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Center(
                                  child: Text(
                                    day,
                                    style: TextStyle(
                                        color: selectedDay == index
                                            ? Color.fromARGB(255, 255, 255, 255)
                                            : Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Expanded(
                    child: ScheduleList(
                      selectedDay: selectedDay,
                      scrollController: _scrollController,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ScheduleList extends StatefulWidget {
  final int selectedDay;
  final ScrollController scrollController;

  ScheduleList({required this.selectedDay, required this.scrollController});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<SchedModel> allSched = [];

  fetchSched() async {
    try {
      
      final response = await Supabase.instance.client
          .from('tbl_schedule')
          .select()
          .eq('section', 'BSHM-2B');
      for (var sched_items in response) {
        var user = SchedModel(
          schedId: sched_items['schedule_id'],
          profName: sched_items['professor_name'],
          subject: sched_items['subject'],
          rawStartTime: sched_items['start_time'],
          rawEndTime: sched_items['end_time'],
          dayOfWeek: sched_items['day_of_week'],
        );
        allSched.add(user);
      }
      // for (var sched in allSched) {
      //   print(sched.subject);
      // }
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    fetchSched();

    // Filter schedules based on the selected day
    List<SchedModel> filteredSchedules = allSched
        .where((schedule) => schedule.dayIndex == widget.selectedDay)
        .toList();

    // Find the index of the first highlighted schedule (if any)
    int highlightedIndex = filteredSchedules.indexWhere((schedule) {
      return checkIfCurrentTime(schedule.startTime!, schedule.endTime!);
    });

    // Scroll to the highlighted schedule after build
    if (highlightedIndex != -1) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        widget.scrollController.animateTo(
          highlightedIndex * 105.0, // Estimate height of the item
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      });
    }

    return ListView.builder(
      controller: widget.scrollController,
      itemCount: filteredSchedules.length,
      itemBuilder: (context, index) {
        var schedule = filteredSchedules[index];
        bool isCurrentTime =
            checkIfCurrentTime(schedule.startTime!, schedule.endTime!);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Column
              Container(
                width: 60, // Fixed width for time
                child: Column(
                  children: [
                    Text(
                      schedule.startTime!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      schedule.endTime!,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 126, 126, 126),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10), // Space between time and container
              // Schedule Detail Container
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: isCurrentTime
                        ? const Color(0xFF862349)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule.subject!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCurrentTime
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 3, 3, 3),
                        ),
                      ),
                      // const SizedBox(height: 5),
                      // Text(
                      //   schedule['topic']!,
                      //   style: TextStyle(
                      //     fontSize: 12,
                      //     color: isCurrentTime
                      //         ? const Color.fromARGB(255, 255, 255, 255)
                      //         : const Color.fromARGB(255, 3, 3, 3),
                      //   ),
                      // ),
                      const SizedBox(height: 5),
                      Text(
                        schedule.profName!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isCurrentTime
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 3, 3, 3),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
bool checkIfCurrentTime(String startTime, String endTime) {
  // Get today's date
  DateTime now = DateTime.now();

  // Parse the start_time and end_time string
  final scheduleStartTime = _parseTimeString(startTime, now);
  final scheduleEndTime = _parseTimeString(endTime, now);

  // Define a time range (1 minute before the start_time and up to the end_time)
  final lowerBound = scheduleStartTime.subtract(Duration(minutes: 1));
  final upperBound = scheduleEndTime;

  // Check if the current time falls within the range
  return now.isAfter(lowerBound) && now.isBefore(upperBound);
}

DateTime _parseTimeString(String timeString, DateTime currentDate) {
  // Extract hours and minutes
  List<String> parts = timeString.split(' ');
  List<String> timeParts = parts[0].split(':');
  int hours = int.parse(timeParts[0]);
  int minutes = int.parse(timeParts[1]);
  
  // Adjust for PM
  if (parts[1].toLowerCase() == 'pm' && hours != 12) {
    hours += 12;
  }
  // Adjust for AM 12:00
  if (parts[1].toLowerCase() == 'am' && hours == 12) {
    hours = 0;
  }

  return DateTime(
    currentDate.year,
    currentDate.month,
    currentDate.day,
    hours,
    minutes,
  );
}
}
