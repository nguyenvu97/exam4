import 'package:flutetr_demo/Body/Add_Todo.dart';
import 'package:flutetr_demo/Getx/DatabaseHelper.dart';
import 'package:flutetr_demo/homePage/HomePage.dart';
import 'package:flutetr_demo/util/Text_Data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Todo_body extends StatefulWidget {
  const Todo_body({super.key});

  @override
  State<Todo_body> createState() => _Todo_bodyState();
}

class _Todo_bodyState extends State<Todo_body> with TickerProviderStateMixin {
  List<Widget> body = [];
  GlobalKey<AnimatedListState> list_key = GlobalKey();

  final todoProvider = TodoProvider();
  late AnimationController animationController;
  late Animation<double> openContainerAnimation;
  late Tween<double> opencontainer;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    opencontainer = Tween<double>(begin: 0.0, end: 100);
    openContainerAnimation = opencontainer.animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getData();
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void getData() async {
    await todoProvider.open();
    var data = await todoProvider.listTodo();

    if (data!.isNotEmpty) {
      data.forEach((todo) {
        body.add(buildTodo(todo));
        list_key.currentState?.insertItem(body.length - 1);
      });
    } else {
      print("Không có dữ liệu");
    }
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return AnimatedList(
      key: list_key,
      initialItemCount: body.length,
      itemBuilder: (context, index, animation) {
        return SlideTransition(
          position:
              animation.drive(Tween(begin: Offset(1, 0), end: Offset(0, 0))),
          child: body[index],
        );
      },
    );
  }

  Widget buildTodo(Todo todo) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (animationController.isCompleted) {
                  animationController.reverse();
                  print(openContainerAnimation.value);
                } else {
                  animationController.forward();

                  print(openContainerAnimation.value);
                }
              });
            },
            child: AnimatedBuilder(
              animation: openContainerAnimation,
              builder: (context, child) {
                return AnimatedContainer(
                  height: 150,
                  width: 410 - openContainerAnimation.value,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(width: 1, color: Colors.black)),
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        todo.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[300],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              todo.description,
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey[600]),
                            ),
                          ),
                          Visibility(
                            visible: todo.done,
                            child: const Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.done,
                                  color: Colors.blue,
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text_Data(
                                name:
                                    "Ngày tạo : ${DateFormat("dd-MM-yyyy").format(todo.createAt)}",
                                color: Colors.black,
                                size: 14,
                                maxLine: 1),
                          ),
                          Text_Data(
                              name:
                                  "Hết Hạn : ${DateFormat("dd-MM-yyyy").format(todo.dueDate ?? DateTime.now())}",
                              color: Colors.red,
                              size: 14,
                              maxLine: 1)
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          AnimatedBuilder(
              animation: openContainerAnimation,
              builder: (context, child) {
                return AnimatedContainer(
                    height: 80,
                    width: openContainerAnimation.value,
                    duration:
                        Duration(milliseconds: 200), // Changed to milliseconds
                    curve: Curves.bounceInOut,
                    child: Row(
                      children: [
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  final GlobalKey<FormState> formKey1 =
                                      GlobalKey<FormState>();
                                  todoGetX.addData.value = false;
                                  todoGetX.addData.value = false;
                                  showModalBottomSheet(
                                      isDismissible: true,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          key: UniqueKey(),
                                          height: 500,
                                          width: 430,
                                          child: Create_todo(
                                            id: todo.id!,
                                            formKey: formKey1,
                                          ),
                                        );
                                      });
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ))),
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  if (todo.id != null) {
                                    // int indexToRemove =
                                    //     body.indexOf(buildTodo(todo));

                                    todoProvider.delete(todo.id!);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()));

                                    // list_key.currentState?.removeItem(
                                    //   indexToRemove + 1,
                                    //   (context, animation) {
                                    //     return SlideTransition(
                                    //       position: animation.drive(Tween(
                                    //         begin: Offset(0, 0),
                                    //         end: Offset(-1, 0),
                                    //       )),
                                    //       child: buildTodo(todo),
                                    //     );
                                    //   },
                                    // );
                                    // body.removeAt(indexToRemove + 1);
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))),
                        Expanded(
                            child: IconButton(
                                onPressed: () {
                                  todoProvider.updateTodoStatus(
                                      todo.id ?? 0, false);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                },
                                icon: Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ))),
                      ],
                    ));
              })
        ],
      ),
    );
  }
}
