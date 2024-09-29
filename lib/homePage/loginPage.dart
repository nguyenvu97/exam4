import 'package:flutetr_demo/Getx/DatabaseHelper.dart';
import 'package:flutetr_demo/Getx/TodoGetx.dart';
import 'package:flutetr_demo/homePage/HomePage.dart';
import 'package:flutetr_demo/util/AppColors.dart';
import 'package:flutetr_demo/util/Text_Data.dart';
import 'package:flutetr_demo/util/Text_From.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPage2State();
}

class _loginPage2State extends State<loginPage> {
  TodoGetX todoGetX = Get.put(TodoGetX());
  TodoProvider todoProvider = Get.put(TodoProvider());

  @override
  void initState() {
    super.initState();
    todoProvider.open();
  }

  final GlobalKey<FormState> fromKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Container(
            height: media.height,
            width: media.width,
            child: Stack(
              children: [
                Positioned(
                    top: -media.height * 0.1,
                    right: media.width * 0.4,
                    left: -media.width * 0.4,
                    bottom: media.height * 0.8,
                    child: Container(
                      height: 100,
                      width: media.width * 0.05,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor),
                    )),
                Positioned(
                    top: media.height * 0.07,
                    right: -media.width * 0.4,
                    left: media.width * 0.6,
                    bottom: 0,
                    child: Container(
                      height: media.height * 0.04,
                      width: media.width * 0.05,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor),
                    )),
                Positioned(
                  top: media.height * 0.2,
                  right: 0,
                  left: 0,
                  bottom: 0,
                  child: Column(
                    children: [
                      SizedBox(
                        child: Text_Data(
                          color: AppColors.primaryColor,
                          name: 'L O G I N ',
                          size: 30,
                          maxLine: 1,
                        ),
                      ),
                      Image.asset(
                        "assets/login-background.png",
                      ),
                      Form(
                          autovalidateMode: AutovalidateMode.always,
                          key: fromKey,
                          child: Container(
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(
                                color: Colors.white12,
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(children: [
                              text_from(
                                labelText: 'email',
                                icon: Icon(Icons.email),
                                obscureText: false,
                                onSaved: (value) {
                                  todoGetX.email.value = value ?? "";
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              text_from(
                                labelText: "password",
                                icon: Icon(Icons.password),
                                obscureText: true,
                                onSaved: (value) {
                                  todoGetX.password.value = value ?? "";
                                },
                              )
                            ]),
                          )),
                      ElevatedButton(
                        onPressed: () async {
                          fromKey.currentState?.save();
                          if (await todoGetX.login() == false) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Đăng nhập thất bại! Vui lòng kiểm tra lại."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Text_Data(
                          name: "Đăng Nhập",
                          color: AppColors.primaryColor,
                          size: 20,
                          maxLine: 1,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
