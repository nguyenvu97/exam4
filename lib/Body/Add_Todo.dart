import 'package:flutetr_demo/Getx/DatabaseHelper.dart';
import 'package:flutetr_demo/Getx/TodoGetx.dart';
import 'package:flutetr_demo/homePage/HomePage.dart';
import 'package:flutetr_demo/util/Text_Data.dart';
import 'package:flutetr_demo/util/Text_From.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class Create_todo extends StatefulWidget {
  int? id;
  final GlobalKey<FormState> formKey;
  Create_todo({super.key, this.id, required this.formKey});

  @override
  State<Create_todo> createState() => _Create_todoState();
}

TodoGetX todoGetX = Get.put(TodoGetX());
TodoProvider todoProvider = Get.put(TodoProvider());

class _Create_todoState extends State<Create_todo> {
  @override
  void initState() {
    // todoProvider.open();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Form(
        autovalidateMode: AutovalidateMode.always,
        key: widget.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text_from(
                labelText: 'Tiêu Đề',
                icon: Icon(Icons.title_sharp),
                obscureText: false,
                onSaved: (value) {
                  todoGetX.title.value = value ?? ''; // Update observable
                },
              ),
              const SizedBox(
                height: 20,
              ),
              text_from(
                labelText: 'Nội dung',
                icon: Icon(Icons.content_paste_sharp),
                obscureText: false,
                onSaved: (value) {
                  todoGetX.description.value = value ?? "";
                },
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    ).then((selectedDate) {
                      setState(() {
                        todoGetX.dueDate.value = selectedDate;
                      });
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: Row(children: [
                      const Icon(
                        (Icons.timelapse),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text_Data(
                          name: "Chọn Thời Gian",
                          color: Colors.black,
                          size: 15,
                          maxLine: 1)
                    ]),
                  )),
              SizedBox(
                height: media.height * 0.1,
              ),
              GestureDetector(
                onTap: () async {
                  widget.formKey.currentState!.save(); // Lưu dữ liệu từ form

                  if (todoGetX.addData.value) {
                    await todoGetX.addTodo(); // Gọi hàm thêm todo
                  } else {
                    await todoGetX
                        .updateTodo(widget.id!); // Gọi hàm cập nhật todo
                  }

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    height: media.height * 0.05,
                    width: media.width * 1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.amber),
                    child: Text_Data(
                        name: "Lưu", color: Colors.black, size: 20, maxLine: 1),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
