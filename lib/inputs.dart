import 'package:finalproject/thememode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Inputs extends StatelessWidget {
  final String title;
  final String Subtitle;
  final TextEditingController? controller;
  final Widget? widget;
  const Inputs(
      {Key? key,
      required this.title,
      required this.Subtitle,
      this.controller,
      this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
         Padding(
           padding: const EdgeInsets.symmetric(horizontal: 0),
           child: Container(
            margin:EdgeInsets.only(top:8.0,left: 15,right: 10),
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(
                color:Colors.grey,
                width:1.0,
              ),
              borderRadius: BorderRadius.circular(12)
            ),
            child: Row(children: [
              Expanded(
                child:TextFormField(
                  readOnly: widget==null?false:true,
                  autofocus: false,
                  cursorColor: Colors.black,
                  controller: controller,
                  style:TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Provider.of<ThemeModel>(context)
                                            .isDarkMode
                                        ?Colors.grey[400]
                                        :Colors.grey[600]
                      ),
                      decoration: InputDecoration(
                        hintText: Subtitle,
                         hintStyle: TextStyle(
                          color: Provider.of<ThemeModel>(context).isDarkMode
                              ? Colors.white // Adjust hint text color based on theme
                              : Colors.grey[600],
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                      ), 
                )
              ),
              widget==null?Container():Container(child:widget)
            ],),
    ),
         )
        ],
      ),
    );
  }
}
