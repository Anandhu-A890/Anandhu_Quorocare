import 'package:flutter/material.dart';
import 'package:quorocare4/appointments/style/styles.dart';
import 'package:quorocare4/appointments/widget/widgets.dart';

class AppointmentView extends StatelessWidget {
  const AppointmentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0, // Set to upcoming (index 0) to match the screenshot
      length: 3, // For Upcoming, Completed, Cancelled
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.darkText,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text('Appointments'),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.darkText,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: AppColors.darkText),
              onPressed: () {
                /*Handle Search functionality*/
              },
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt, color: AppColors.darkText),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
          ],
          // The TabBar is placed inside a Container for styling its background
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(
              120.0,
            ), // Height of the Patient Bar + TabBar
            child: Column(
              children: [
                // 1. New Patient Selection Bar
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: PatientSelectionBar(),
                ),
                // 2. TabBar
                Padding(
                  padding: const EdgeInsets.only(
                    left: 16.0,
                    right: 16.0,
                    bottom: 10.0,
                  ),
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Builder(
                      builder: (BuildContext context) {
                        return Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: TabBar(
                            labelPadding: EdgeInsets.zero,
                            dividerColor: Colors.transparent,
                            // Custom Indicator Style
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: AppColors.activeTabColor,
                            ),
                            // Tab Colors and Labels
                            labelColor: AppColors.lightText,
                            unselectedLabelColor: Colors.black54,

                            labelStyle: AppFonts.bodyText.copyWith(
                              fontWeight: FontWeight.bold,
                            ),

                            indicatorColor: Colors.transparent,
                            indicatorWeight: 0.1,
                            tabs: const [
                              Tab(child: Center(child: Text('Upcoming'))),
                              Tab(child: Center(child: Text('Completed'))),
                              Tab(child: Center(child: Text('Cancelled'))),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            AppointmentList(pageType: 'Upcoming'),
            AppointmentList(pageType: 'Completed'),
            AppointmentList(pageType: 'Cancelled'),
          ],
        ),
      ),
    );
  }
}
