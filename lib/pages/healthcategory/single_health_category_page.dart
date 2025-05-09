import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthcare/constants/colors.dart';
import 'package:healthcare/functions/function_dart';
import 'package:healthcare/models/health_category_model.dart';
import 'package:healthcare/pages/healthcategory/add_clinic_record_page.dart';
import 'package:healthcare/pages/healthcategory/add_health_report.dart';
import 'package:healthcare/pages/update_pages/update_single_category_page.dart';
import 'package:healthcare/services/category/health_category_service.dart';
import 'package:healthcare/widgets/single_category/add_health_record_card.dart';
import 'package:healthcare/widgets/single_category/category_botton_sheet.dart';

class SingleHealthCategoryPage extends StatefulWidget {
  final HealthCategory healthCategory;
  const SingleHealthCategoryPage({
    super.key,
    required this.healthCategory,
  });

  @override
  State<SingleHealthCategoryPage> createState() =>
      _SingleHealthCategoryPageState();
}

class _SingleHealthCategoryPageState extends State<SingleHealthCategoryPage> {
  bool _isLoading = false;

  void _deleteCategory(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await HealthCategoryService().deleteHealthCategoryWithSubCollection(
        FirebaseAuth.instance.currentUser!.uid,
        widget.healthCategory.id,
      );

      UtilFunctions().showSnackBarWdget(
        // ignore: use_build_context_synchronously
        context,
        "category deleted successfully",
      );

      // ignore: use_build_context_synchronously
      GoRouter.of(context).go("/");
    } catch (error) {
      print("error: ${error}");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.healthCategory.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).go("/");
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CategoryBottonSheet(
                    title1: "Delete Category",
                    title2: "Edit Category",
                    deleteCallback: () {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "Delete category",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            content: Text(
                              "If you delete a category, then all associated symptoms and clinic records should also be deleted",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: mainOrangeColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .labelLarge,
                                          ),
                                          onPressed: () =>
                                              _deleteCategory(context),
                                          child: Text(
                                            "Ok",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    editCallback: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateSingleCategoryPage(
                            healthCategory: widget.healthCategory,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  widget.healthCategory.description,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                // SizedBox(
                //   height: 10,
                // ),
                SizedBox(
                  height: 300,
                  child: ClipRRect(
                    child: Center(
                      child: Image.asset(
                        "assets/images/nurse-wearing-protection-equipment-while-fighting-corona-virus-with-syringe.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddHealthReport(
                                healthCategory: widget.healthCategory),
                          ),
                        );
                      },
                      child: AddHealthRecordCard(
                        imageUrl: "assets/images/statistics_14659998.png",
                        title: " Add new Symptom ",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddClinicRecordPage(
                              healthCategory: widget.healthCategory,
                            ),
                          ),
                        );
                      },
                      child: AddHealthRecordCard(
                        imageUrl: "assets/images/caduceus_6916165.png",
                        title: "Add Clinic Record",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
