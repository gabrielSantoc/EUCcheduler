import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_schedule/shared/constants.dart';

class ViewPage extends StatefulWidget {
  @override
  ViewPageState createState() => ViewPageState();
}

class ViewPageState extends State<ViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MAROON,
      appBar: AppBar(
        backgroundColor: MAROON,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Business Practicum',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: WHITE
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.all(23),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold,color: WHITE),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Time',
                      style: TextStyle(fontWeight: FontWeight.bold,color: WHITE),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Teacher',
                      style: TextStyle(fontWeight: FontWeight.bold,color: WHITE),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Sept. 23, 2024',style: TextStyle(fontWeight: FontWeight.bold,color: WHITE),),
                    SizedBox(height: 8),
                    Text('11:35pm - 11:35 am',style: TextStyle(fontWeight: FontWeight.bold,color: WHITE),),
                    SizedBox(height: 8),
                    Text('Clark Kent',style: TextStyle(fontWeight: FontWeight.bold,color: WHITE),),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'ANNOUNCEMENTS',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        children: const [
                          AnnouncementCard(
                            title: 'Title',
                            content:
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                          ),
                          SizedBox(height: 16),
                          AnnouncementCard(
                            title: 'Title',
                            content:
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                          ),
                          SizedBox(height: 16),
                          AnnouncementCard(
                            title: 'Title',
                            content:
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                          ),
                          SizedBox(height: 16),
                          AnnouncementCard(
                            title: 'Title',
                            content:
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                          ),
                          SizedBox(height: 16),
                          AnnouncementCard(
                            title: 'Title',
                            content:
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnnouncementCard extends StatelessWidget {
  final String title;
  final String content;

  const AnnouncementCard({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: LIGHTGRAY,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
