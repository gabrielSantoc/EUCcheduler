import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  int selectedDay = DateTime.now().weekday %
      7; // Get current day of the week (0 = Sunday, 6 = Saturday)
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
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
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

class ScheduleList extends StatelessWidget {
  final int selectedDay;
  final ScrollController scrollController;

  ScheduleList({required this.selectedDay, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    // List of schedules with 'start_time' and 'end_time'
    List<Map<String, dynamic>> schedules = [
      {
        'start_time': '02:00',
        'end_time': '02:30',
        'course': 'Mathematics',
        'topic': 'Chapter 1: Introduction',
        'instructor': 'Clark Kent',
        'day_of_week': 0 // Sunday
      },
      {
        'start_time': '10:00',
        'end_time': '11:00',
        'course': 'Science',
        'topic': 'Chapter 2: Physics',
        'instructor': 'Bruce Wayne',
        'day_of_week': 3 // Wednesday
      },
      {
        'start_time': '11:35',
        'end_time': '12:30',
        'course': 'History',
        'topic': 'Ancient Civilizations',
        'instructor': 'Diana Prince',
        'day_of_week': 3 // Wednesday
      },
      {
        'start_time': '12:00',
        'end_time': '13:00',
        'course': 'Math',
        'topic': 'Algebra',
        'instructor': 'Albert Einstein',
        'day_of_week': 5 // Monday
      },
      {
        'start_time': '13:00',
        'end_time': '14:00',
        'course': 'Math',
        'topic': 'Algebra',
        'instructor': 'Albert Einstein',
        'day_of_week': 5 // Monday
      },
      {
        'start_time': '14:00',
        'end_time': '15:00',
        'course': 'Math',
        'topic': 'Algebra',
        'instructor': 'Albert Einstein',
        'day_of_week': 5 // Monday
      },
      {
        'start_time': '15:00',
        'end_time': '16:00',
        'course': 'Math',
        'topic': 'Algebra',
        'instructor': 'Albert Einstein',
        'day_of_week': 5 // Monday
      },
      {
        'start_time': '15:00',
        'end_time': '16:00',
        'course': 'Math',
        'topic': 'Algebra',
        'instructor': 'Albert Einstein',
        'day_of_week': 5 // Monday
      },
      {
        'start_time': '15:00',
        'end_time': '16:00',
        'course': 'Math',
        'topic': 'Algebra',
        'instructor': 'Albert Einstein',
        'day_of_week': 5 // Monday
      },
      {
        'start_time': '15:00',
        'end_time': '16:00',
        'course': 'Math',
        'topic': 'Algebra',
        'instructor': 'Albert Einstein',
        'day_of_week': 5 // Monday
      },
      {
        'start_time': '15:00',
        'end_time': '16:00',
        'course': 'Math',
        'topic': 'Algebra',
        'instructor': 'Albert Einstein',
        'day_of_week': 5 // Monday
      },
      {
        'start_time': '15:00',
        'end_time': '16:00',
        'course': 'Math',
        'topic': 'Algebra',
        'instructor': 'Albert Einstein',
        'day_of_week': 5 // Monday
      },
      {
        'start_time': '15:00',
        'end_time': '16:00',
        'course': 'Math',
        'topic': 'Algebra',
        'instructor': 'Albert Einstein',
        'day_of_week': 5 // Monday
      },
    ];

    // Filter schedules based on the selected day
    List<Map<String, dynamic>> filteredSchedules = schedules
        .where((schedule) => schedule['day_of_week'] == selectedDay)
        .toList();

    // Find the index of the first highlighted schedule (if any)
    int highlightedIndex = filteredSchedules.indexWhere((schedule) {
      return checkIfCurrentTime(schedule['start_time']!, schedule['end_time']!);
    });

    // Scroll to the highlighted schedule after build
    if (highlightedIndex != -1) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          highlightedIndex * 105.0, // Estimate height of the item
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      });
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: filteredSchedules.length,
      itemBuilder: (context, index) {
        var schedule = filteredSchedules[index];
        bool isCurrentTime =
            checkIfCurrentTime(schedule['start_time']!, schedule['end_time']!);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Time Column
              Container(
                width: 60, // Fixed width for time
                child: Column(
                  children: [
                    Text(
                      schedule['start_time']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      schedule['end_time']!,
                      style: const TextStyle(
                        fontSize: 16,
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
                        schedule['course']!,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isCurrentTime
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 3, 3, 3),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        schedule['topic']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isCurrentTime
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 3, 3, 3),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        schedule['instructor']!,
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

    // Parse the start_time and end_time string into DateTime objects for today
    final scheduleStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(startTime.split(":")[0]), // hour
      int.parse(startTime.split(":")[1]), // minute
    );

    final scheduleEndTime = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(endTime.split(":")[0]), // hour
      int.parse(endTime.split(":")[1]), // minute
    );

    // Define a time range (15 minutes before the start_time and up to the end_time)
    final lowerBound = scheduleStartTime.subtract(Duration(minutes: 1));
    final upperBound = scheduleEndTime;
    print('Now: $now, Lower Bound: $lowerBound, Upper Bound: $upperBound');

    // Check if the current time falls within the range (15 minutes before start_time and before end_time)
    return now.isAfter(lowerBound) && now.isBefore(upperBound);
  }
}