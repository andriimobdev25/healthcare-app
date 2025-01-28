import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/models/user_model.dart';
import 'package:healthcare/widgets/charts/show_blood_suger_chart.dart';
import 'package:healthcare/widgets/profile_data_page/single_profile_data_card.dart';

class ProfileDataPage extends StatelessWidget {
  final UserModel user;
  const ProfileDataPage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(user.name),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).go("/");
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Personalize Fitness and Health",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "This information ensures Fitnes and Health data are as accurate as possible",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    // color: subLandMarksCardBg.withOpacity(0.9),
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    child: Column(
                      children: [
                        SingleProfileDataCard(
                          title: "Name",
                          userData: user.name,
                          imageUrl: "assets/images/card_16581871.png",
                        ),
                        SingleProfileDataCard(
                          title: "Sex",
                          userData: user.sex!,
                          imageUrl: "assets/images/sex_5625548.png",
                        ),
                        SingleProfileDataCard(
                          title: "Day of Birth",
                          userData:
                              "${_getMonthName(user.dateOfBirth.month)} ${user.dateOfBirth.day}, ${user.dateOfBirth.year}",
                          imageUrl: "assets/images/open_9181809.png",
                        ),
                        SingleProfileDataCard(
                          title: "Height",
                          userData: "${user.heightFeet} ${user.heightInches}\"",
                          imageUrl: "assets/images/height_5474787.png",
                        ),
                        SingleProfileDataCard(
                          title: "Weight",
                          userData: "${user.weight} lb",
                          imageUrl: "assets/images/body-scale_17488088.png",
                        ),
                        SingleProfileDataCard(
                          title: "Blood Group",
                          userData: "${user.bloodGroup}",
                          imageUrl: "assets/images/check-list_5535285.png",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Analytics about blood suger level",
                  style: TextStyle(
                    fontSize: 20,
                    color: mainLandMarksColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 212,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: mainYellowColor.withOpacity(0.1),
                        // color: mainPurpleColor.withOpacity(0.1),
                      ),
                    ),
                    ShowBloodSugerChart(),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
