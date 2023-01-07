import 'package:flutter/material.dart';
import '../constants/color.dart';
import '../models/category_ui.dart';
import '../models/category.dart';
import '../services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Map<String, int> popularMap = {};
  Map<String, List<CategoryUi>> categoryUiMap = {};
  bool isDataLoaded = false;
  double count = 0;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future<void> getData() async {
    setState(() {
      isDataLoaded = false;
    });
    Map<String, List<Category>> categoryMap =
        await APIServices().getCategories();
    categoryMap.forEach((key, v) {
      List<CategoryUi> list = [];
      for (Category category in v) {
        list.add(CategoryUi(itemCount: 0, category: category));
      }
      categoryUiMap[key] = list;
    });
    setState(() {
      isDataLoaded = true;
    });
  }

  Future<void> placeOrder() async {

    bool isOrderPlace = false;
    popularMap = {};
    for (int i = 0; i < categoryUiMap.length; i++) {
      List<CategoryUi> categoryUiList = categoryUiMap.values.elementAt(i);
      for (int j = 0; j < categoryUiList.length; j++) {
        if (categoryUiList[j].itemCount != 0) {
          isOrderPlace = true;
          categoryUiList[j].totalOrdered =
              categoryUiList[j].totalOrdered + 1/*categoryUiList[j].itemCount*/;
          categoryUiList[j].itemCount = 0;
        }
        if (categoryUiList[j].totalOrdered != 0) {
          popularMap[i.toString() + j.toString()] =
              categoryUiList[j].totalOrdered;

        }

        //}
      }
    }
    popularMap = Map.fromEntries(popularMap.entries.toList()
      ..sort((e1, e2) => e2.value.compareTo(e1.value)));
    count = 0;
    print(popularMap);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isOrderPlace
          ? "Order Placed Successfully"
          : "Please add items to place order"),
      backgroundColor: isOrderPlace ? Colors.green : Colors.amber,
    ));

    if(isOrderPlace)
      {
        setState(() {
          isDataLoaded = false;
        });
        await Future.delayed(const Duration(seconds: 4));
        setState(() {
          isDataLoaded = true;
        });
      }
  }

  getChildrenForPopularItems() {
    int len = popularMap.length < 3 ? popularMap.length : 3;
    List<Widget> itemList = [];
    for (int index = 0; index < len; index++) {
      String str = popularMap.keys.elementAt(index);
      int i = int.parse(str.split('').first);
      int j = int.parse(str.split('').last);
      ListTile item = ListTile(
        textColor: Colors.grey,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(categoryUiMap.values.elementAt(i)[j].category.name!),
            index == 0
                ? Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.pink,
                    ),
                    child: const Text(
                      "Bestseller",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ))
                : Container(),
            SizedBox(
              child: categoryUiMap.values.elementAt(i)[j].itemCount == 0
                  ? TextButton(
                      onPressed: () {
                        categoryUiMap.values.elementAt(i)[j].itemCount = 1;
                        count = count +
                            categoryUiMap.values
                                .elementAt(i)[j]
                                .category
                                .price!;
                        setState(() {});
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.red)))),
                      child: const Text('Add'),
                    )
                  : Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: mainColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              if (categoryUiMap.values
                                      .elementAt(i)[j]
                                      .itemCount ==
                                  1) {
                                count = count -
                                    categoryUiMap.values
                                        .elementAt(i)[j]
                                        .category
                                        .price!;
                                categoryUiMap.values.elementAt(i)[j].itemCount =
                                    0;
                              } else {
                                if (categoryUiMap.values
                                        .elementAt(i)[j]
                                        .itemCount !=
                                    0) {
                                  count = count -
                                      categoryUiMap.values
                                          .elementAt(i)[j]
                                          .category
                                          .price!;
                                }
                                categoryUiMap.values.elementAt(i)[j].itemCount =
                                    categoryUiMap.values
                                            .elementAt(i)[j]
                                            .itemCount -
                                        1;
                              }
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.remove,
                              color: mainColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: mainColor,
                            ),
                            child: Text(
                              "${categoryUiMap.values.elementAt(i)[j].itemCount}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              categoryUiMap.values.elementAt(i)[j].itemCount =
                                  categoryUiMap.values
                                          .elementAt(i)[j]
                                          .itemCount +
                                      1;
                              count = count +
                                  categoryUiMap.values
                                      .elementAt(i)[j]
                                      .category
                                      .price!;
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.add,
                              color: mainColor,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          ],
        ),
        subtitle:
            Text("\$ ${categoryUiMap.values.elementAt(i)[j].category.price!}"),
      );
      itemList.add(item);
      itemList.add(const Divider());
    }
    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Demo App")),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          height: 50,
          margin: const EdgeInsets.all(10),
          child: ElevatedButton(
              child: isDataLoaded ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(""),
                  const Text(
                    "Place Order",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "\$$count",
                    style: const TextStyle(fontSize: 20),
                  )
                ],
              ) : CircularProgressIndicator(color: Colors.white,),
              onPressed: () {
                placeOrder();
              }),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: isDataLoaded
              ? Column(
                  children: [
                    popularMap.isNotEmpty
                        ? ExpansionTile(
                            backgroundColor: greyBGColor,
                            childrenPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Popular items",
                                  style: TextStyle(
                                      color: Colors.black87, fontSize: 18),
                                ),
                                Text(
                                  popularMap.length < 3
                                      ? '${popularMap.length}'
                                      : '3',
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 16),
                                )
                              ],
                            ),
                            children: getChildrenForPopularItems())
                        : Container(),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: categoryUiMap.length,
                        itemBuilder: (BuildContext context1, int index) {
                          String key = categoryUiMap.keys.elementAt(index);
                          return ExpansionTile(
                              backgroundColor: greyBGColor,
                              childrenPadding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    key,
                                    style: const TextStyle(
                                        color: Colors.black87, fontSize: 18),
                                  ),
                                  Text(
                                    categoryUiMap.values
                                        .elementAt(index)
                                        .length
                                        .toString(),
                                    style: const TextStyle(
                                        color: Colors.black54, fontSize: 16),
                                  )
                                ],
                              ),
                              children: getChildrenList(
                                  categoryUiMap.values.elementAt(index)));
                        })
                  ],
                )
              : Center(
                  child: Container(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                ),
        ));
  }

  List<Widget> getChildrenList(List<CategoryUi> categoryUiList) {
    List<Widget> list = [];

    for (CategoryUi categoryUi in categoryUiList) {
      ListTile item = ListTile(
        textColor: Colors.grey,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(categoryUi.category.name!),
            SizedBox(
              child: categoryUi.itemCount == 0
                  ? TextButton(
                      onPressed: () {
                        categoryUi.itemCount = 1;
                        count = count + categoryUi.category.price!;
                        setState(() {});
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.red)))),
                      child: const Text('Add'),
                    )
                  : Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: mainColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              if (categoryUi.itemCount == 1) {
                                count = count - categoryUi.category.price!;
                                categoryUi.itemCount = 0;
                              } else {
                                if (categoryUi.itemCount != 0) {
                                  count = count - categoryUi.category.price!;
                                }
                                categoryUi.itemCount = categoryUi.itemCount - 1;
                              }
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.remove,
                              color: mainColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: mainColor,
                            ),
                            child: Text(
                              "${categoryUi.itemCount}",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              categoryUi.itemCount = categoryUi.itemCount + 1;
                              count = count + categoryUi.category.price!;
                              setState(() {});
                            },
                            child: const Icon(
                              Icons.add,
                              color: mainColor,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          ],
        ),
        subtitle: Text(categoryUi.category.price!.toString()),
      );
      list.add(item);
      list.add(const Divider());
    }
    return list;
  }
}
