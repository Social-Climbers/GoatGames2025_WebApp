import 'package:flutter/material.dart';
import 'package:goatgames25webapp/Theme.dart';
import 'package:goatgames25webapp/data.dart';
import 'package:intl/intl.dart';

class CrestSlotBookingPage extends StatelessWidget {
  final List<String> saturdaySlots = [
    'Saturday 3rd 9AM-12PM',
    'Saturday 3rd 12PM-3PM',
    'Saturday 3rd 3PM-6PM',
    'Saturday 3rd 6PM-9PM',
    'Saturday 3rd 9PM-12AM',
  ];

  final List<String> sundaySlots = [
    'Sunday 4th 9AM-12PM',
    'Sunday 4th 12PM-3PM',
    'Sunday 4th 3PM-6PM',
    'Sunday 4th 6PM-9PM',
    'Sunday 4th 9PM-12AM',
  ];

  final List<String> juneSlots = [
    'Saturday 10th 9AM-12PM',
    'Saturday 10th 12PM-3PM',
    'Saturday 10th 3PM-6PM',
    'Saturday 10th 6PM-9PM',
    'Saturday 10th 9PM-12AM',
    'Sunday 11th 9AM-12PM',
    'Sunday 11th 12PM-3PM',
    'Sunday 11th 3PM-6PM',
    'Sunday 11th 6PM-9PM',
    'Sunday 11th 9PM-12AM',
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Time Booking', style: TextStyle(color: AccentColor)),
              Image.asset('assets/crest_logo.jpg', height: size.height * 0.05),
            ],
          ),

          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.black,
                    child: SponsorBox(),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.black,

                    child: TabBar(
                      tabs: [Tab(text: 'Saturday'), Tab(text: 'Sunday')],
                      labelColor: AccentColor,
                      indicatorColor: AccentColor,
                      unselectedLabelColor: Colors.white,
                    ),
                  ),

                  Expanded(
                    child: TabBarView(
                      children: [
                        SlotListView(slots: saturdaySlots),
                        SlotListView(slots: sundaySlots),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SlotListView extends StatelessWidget {
  final List<String> slots;
  final int totalSlots = 25;

  SlotListView({required this.slots});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ListView.builder(
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slotParts = slots[index].split(' ');
        final day = slotParts[0];
        final date = slotParts[1];
        final time = slotParts[2];

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: LayoutBuilder(
              builder: (context, constraints) {
                double fontSize = constraints.maxWidth * 0.04;
                return Text(
                  '$time',
                  style: TextStyle(
                    color: AccentColor,
                    fontSize: size.width * 0.04,
                  ),
                );
              },
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$day $date'
                  ' June 2025',
                  style: TextStyle(
                    color: AccentColor,
                    fontSize: size.width * 0.03,
                  ),
                ),
                Text(
                  'Available slots: 0/$totalSlots ',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      title: Text(
                        'Confirm Booking',
                        style: TextStyle(color: AccentColor),
                      ),
                      content: Text(
                        'Are you sure you want to book this time slot?',
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: AccentColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Confirm',
                            style: TextStyle(color: AccentColor),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Booked: ${slots[index]}'),
                              ),
                            );
                            // Update userData
                            userData.phases['Crest_Booked']['Completed'] = true;
                            userData.phases['Crest_Booked']['Timestamp'] =
                                DateTime.now().toIso8601String();
                            print(
                              'Booking confirmed at: ${userData.phases['Crest_Booked']['Timestamp']}',
                            );
                            // Navigate to main menu
                            Navigator.of(
                              context,
                            ).popUntil((route) => route.isFirst);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Book', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: AccentColor),
            ),
          ),
        );
      },
    );
  }
}
