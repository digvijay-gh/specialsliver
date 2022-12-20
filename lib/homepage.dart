import 'package:flutter/material.dart';
import 'package:specialsliver/extra.dart';

const List categoryMenus = ["red", "blue", "green", "yellow", "pink", "grey"];
const List colorList = [
  Colors.red,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.pink,
  Colors.grey,
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomepageState();
}

class _HomepageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  double restaurantInfoHeight = 200 - kToolbarHeight;
  int selectedCategoryIndex = 0;

  void scrollToCategory(int index) {
    if (selectedCategoryIndex != index) {
      int totalItems = 0;
      for (var i = 0; i < index; i++) {
        totalItems += 1;
      }
      scrollController.animateTo(
        restaurantInfoHeight + (totalItems * 576),
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        selectedCategoryIndex = index;
      });
    }
  }

  List<double> breakPoints = [];
  void createBreakPoints() {
    double firstBreakPoint = restaurantInfoHeight + (576);
    print(firstBreakPoint);
    breakPoints.add(firstBreakPoint);
    for (var i = 1; i < categoryMenus.length; i++) {
      double breakPoint = breakPoints.last + (576);
      print(breakPoint);
      breakPoints.add(breakPoint);
    }
  }

  @override
  void initState() {
    createBreakPoints();
    scrollController.addListener(() {
      updateCategoryIndexOnScroll(scrollController.offset);
    });
    super.initState();
  }

  void updateCategoryIndexOnScroll(double offset) {
    for (var i = 0; i < categoryMenus.length; i++) {
      if (i == 0) {
        if ((offset < breakPoints.first) & (selectedCategoryIndex != 0)) {
          setState(() {
            selectedCategoryIndex = 0;
          });
        }
      } else if ((breakPoints[i - 1] <= offset) & (offset < breakPoints[i])) {
        if (selectedCategoryIndex != i) {
          setState(() {
            selectedCategoryIndex = i;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            SliverAppBar(
              elevation: 0,
              pinned: true,
              backgroundColor: Colors.grey.shade300,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                  "Special Sliver",
                  style: TextStyle(color: Colors.black),
                ),
                background: Container(
                  height: 200,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: ColorCategories(
                onChanged: scrollToCategory,
                selectedIndex: selectedCategoryIndex,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: categoryMenus.length,
                (context, categoryIndex) {
                  return Column(
                    children: [
                      ...List.generate(
                        9,
                        (index) {
                          return Card(
                            child: ListTile(
                              tileColor: colorList[categoryIndex]
                                  [(index + 1) * 100],
                              title: Text(
                                categoryMenus[categoryIndex],
                                style: TextStyle(
                                  color: Colors.black.withOpacity(1),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}
