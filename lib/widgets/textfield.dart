import 'package:flutter/material.dart';
//Codigo escrito por Alexis Garcia Perez
class Textfield extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final bool isPassword;
  const Textfield({
    super.key,
    @required required this.icon, 
    @required required this.placeholder, 
    @required required this.textController, 
     this.isPassword=false
  });
 @override
  Widget build(BuildContext context) {
    return Container(
            padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
            margin: EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  offset: Offset(10, 15),
                  blurRadius: 10
                )
              ]
            ),
            child: TextField(
              obscureText: isPassword,
              controller: textController,
              autocorrect: false,
              decoration: InputDecoration(
                prefixIcon: Icon(icon, color: Colors.blue[600],),
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: placeholder,
              ),
            ),
          );          
  }

}