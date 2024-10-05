import 'package:flutter/material.dart';
import 'package:my_schedule/auth/auth.dart';
import 'package:my_schedule/main.dart';
import 'package:my_schedule/model/schedule_model.dart';
import 'package:my_schedule/screens/view_page.dart';
import 'package:my_schedule/shared/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:badges/badges.dart' as badges;
import 'package:hive_flutter/hive_flutter.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => ScheduleScreenState();
}

class ScheduleScreenState extends State<ScheduleScreen> {
  int selectedDay = DateTime.now().weekday % 7;
  final List<String> days = ["S", "M", "T", "W", "TH", "F", "SA"];
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MAROON,
      appBar: AppBar(
        backgroundColor: MAROON,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(),
          ),
        ],
      ),
      drawer: const DrawerClass(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Juan Dela Cruztzy",
                  style: TextStyle(
                      fontSize: 30, color: WHITE, fontWeight: FontWeight.bold),
                ),
                Text(
                  "BSCS-4",
                  style: TextStyle(
                    fontSize: 20,
                    color: WHITE,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 10),
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
                            height: 60,
                            child: Container(
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color:
                                    selectedDay == index ? MAROON : LIGHTGRAY,
                              ),
                              child: Center(
                                child: Text(
                                  day,
                                  style: TextStyle(
                                      fontSize: 19,
                                      color: selectedDay == index
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 45),
                    child: Text(
                      "Time            Course",
                      style: TextStyle(color: GRAY),
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

  const ScheduleList({super.key, required this.selectedDay, required this.scrollController});

  @override
  State<ScheduleList> createState() => _ScheduleListState();
}

class _ScheduleListState extends State<ScheduleList> {
  final SupabaseClient supabase = Supabase.instance.client;
  late Future<List<SchedModel>> schedFuture;
  Map<int, bool> newAnnouncementsMap = {};
  late Box<String> announcementsBox;
  Map<int, String> latestAnnouncementTimes = {};

  @override
  void initState() {
    super.initState();
    initHive();
    schedFuture = fetchSched();
  }

  void initHive() async {
    await Hive.initFlutter();
    announcementsBox = await Hive.openBox<String>('announcements');
    loadData();
  }

  Future<void> loadData() async {
    schedFuture = fetchSched();
    await checkForNewAnnouncements();
    setState(() {});
  }

  Future<List<SchedModel>> fetchSched() async {
    try {

      final response = await supabase.from('tbl_schedule').select().eq('section', 'BSHM-2B');
      return SchedModel.jsonToList(response);
    } catch (e) {
      print('Error fetching schedules: $e');
      return [];
    }
  }

  Future<void> checkForNewAnnouncements() async {
    final response = await supabase
        .from('tbl_announcement')
        .select('schedule_id, created_at')
        .order('created_at', ascending: false);

    for (var announcement in response) {
      int schedId = announcement['schedule_id'];
      String createdAt = announcement['created_at'];

      // Store the latest created_at for each schedule
      if (!latestAnnouncementTimes.containsKey(schedId) || createdAt.compareTo(latestAnnouncementTimes[schedId]!) > 0) {
        latestAnnouncementTimes[schedId] = createdAt;
      }

      String lastViewedKey = 'last_viewed_$schedId';
      String? lastViewedTime = announcementsBox.get(lastViewedKey);

      if (lastViewedTime == null || createdAt.compareTo(lastViewedTime) > 0) {
        newAnnouncementsMap[schedId] = true;
      }
    }
  }

  void updateLastViewedTime(int schedId) async {
    String? latestTime = latestAnnouncementTimes[schedId];
    if (latestTime != null) {
      await announcementsBox.put('last_viewed_$schedId', latestTime);
      setState(() {
        newAnnouncementsMap[schedId] = false;
      });
    }
  }

  bool checkIfCurrentTime(String startTime, String endTime) {
    DateTime now = DateTime.now();
    final scheduleStartTime = _parseTimeString(startTime, now);
    final scheduleEndTime = _parseTimeString(endTime, now);
    final lowerBound = scheduleStartTime.subtract(Duration(minutes: 1));
    final upperBound = scheduleEndTime;
    return now.isAfter(lowerBound) && now.isBefore(upperBound);
  }

  DateTime _parseTimeString(String timeString, DateTime currentDate) {
    List<String> parts = timeString.split(' ');
    List<String> timeParts = parts[0].split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);
    if (parts[1].toLowerCase() == 'pm' && hours != 12) {
      hours += 12;
    }
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadData,
      child: FutureBuilder<List<SchedModel>>(
        future: schedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                SizedBox(height: 50),
                Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: MAROON,
                    size: 50,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Just a moment, retrieving schedule...",
                  style: TextStyle(color: GRAY, fontSize: 15),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No schedules available'));
          }

          List<SchedModel> allSched = snapshot.data!;
          List<SchedModel> filteredSchedules = allSched
              .where((schedule) => schedule.dayIndex == widget.selectedDay)
              .toList();

          return ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
            controller: widget.scrollController,
            itemCount: filteredSchedules.length,
            itemBuilder: (context, index) {
              var schedule = filteredSchedules[index];
              bool isCurrentTime = checkIfCurrentTime(
                schedule.startTime,
                schedule.endTime,
              );
              bool hasNewAnnouncement =
                  newAnnouncementsMap[schedule.schedId] ?? false;

              return ScheduleListItem(
                schedule: schedule,
                isCurrentTime: isCurrentTime,
                hasNewAnnouncement: hasNewAnnouncement,
                onTap: () {
                  updateLastViewedTime(schedule.schedId);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPage(
                        startTime: schedule.startTime,
                        endTime: schedule.endTime,
                        profName: schedule.profName,
                        subjectName: schedule.subject,
                        schedId: schedule.schedId,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ScheduleListItem extends StatelessWidget {
  final SchedModel schedule;
  final bool isCurrentTime;
  final bool hasNewAnnouncement;
  final VoidCallback onTap;

  const ScheduleListItem({
    required this.schedule,
    required this.isCurrentTime,
    required this.hasNewAnnouncement,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(width: 2, color: GRAY)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 18),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          schedule.startTime,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          schedule.endTime,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 126, 126, 126),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    splashColor: Color.fromARGB(29, 0, 0, 0),
                    borderRadius: BorderRadius.circular(8.0),
                    onTap: onTap,
                    child: Ink(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isCurrentTime ? MAROON : LIGHTGRAY,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: badges.Badge(
                        position: badges.BadgePosition.topEnd(),
                        showBadge: hasNewAnnouncement,
                        
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Colors.transparent,
                        ),
                        badgeContent: Icon(
                          Icons.circle,
                          size: 10,
                          color: Color.fromARGB(255, 51, 231, 57),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              schedule.subject,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    isCurrentTime ? Colors.white : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              schedule.profName!,
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    isCurrentTime ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
