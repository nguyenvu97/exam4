import 'package:flutetr_demo/Body/Add_Todo.dart';
import 'package:flutetr_demo/homePage/loginPage.dart';
import 'package:flutter/material.dart';

class Data {
  final String text;
  final Icon icon;
  Data({required this.icon, required this.text});
}

var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);
var defaultBackgroundColor = Colors.grey[300];
var drawerTextColor = TextStyle(
  color: Colors.grey[600],
);

class myDrawer extends StatefulWidget {
  const myDrawer({super.key});

  @override
  State<myDrawer> createState() => _myDrawerState();
}

class _myDrawerState extends State<myDrawer> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    List<Data> listData = [
      Data(
          icon: Icon(
            Icons.home,
            size: 20,
          ),
          text: "D A S H B O A R D"),
      Data(
          icon: Icon(
            Icons.create,
            size: 20,
          ),
          text: "C R E A T E T A S K"),
      Data(
          icon: Icon(
            Icons.settings,
            size: 20,
          ),
          text: "S E T T I N G S'"),
      Data(
          icon: Icon(
            Icons.info,
            size: 20,
          ),
          text: "A B O U T"),
      Data(
          icon: Icon(
            Icons.logout,
            size: 20,
          ),
          text: "L O G O U T"),
    ];

    Tween<Offset> offset = Tween(begin: Offset(1, 0), end: Offset(0, 0));

    return Drawer(
      backgroundColor: Colors.grey[300],
      elevation: 0,
      child: Column(
        children: [
          DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage("assets/img.jpeg"))),
                  ),
                ),
                Expanded(flex: 1, child: Text("nguyen vu"))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: listData.length,
                itemBuilder: (context, index) {
                  return AnimatedContainer(
                    curve: Curves.bounceInOut,
                    duration: Duration(minutes: 1),
                    padding: tilePadding,
                    child: ListTile(
                      onTap: () {
                        if (index == 1) {
                          final GlobalKey<FormState> formKey2 =
                              GlobalKey<FormState>();
                          todoGetX.addData..value = true;
                          showModalBottomSheet(
                              isDismissible: true,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return SizedBox(
                                  key: UniqueKey(),
                                  height: media.height * 0.5,
                                  width: media.width * 1,
                                  child: Create_todo(
                                    formKey: formKey2,
                                  ),
                                );
                              });
                        }
                        if (index == 4) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => loginPage()));
                        }
                      },
                      leading: listData[index].icon,
                      title: Text(
                        "${listData[index].text}",
                        style: drawerTextColor,
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
