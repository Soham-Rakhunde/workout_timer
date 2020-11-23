import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';



class drawerPage extends StatefulWidget {

  @override
  _drawerPageState createState() => _drawerPageState();
}

class _drawerPageState extends State<drawerPage> with SingleTickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: drawerColor,
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 25, 0, 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  // Icon(
                  //   Icons.watch_later_outlined,
                  //   size: 50,
                  //   color: Colors.teal[200],
                  // ),
                  // SizedBox(width:10),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Workout Timer',
                        style:TextStyle(
                          color: Colors.teal[200],
                          letterSpacing: 2.0,
                          fontSize: 30,
                          fontFamily: 'MontserratBold',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'High-intensity interval training',
                        style:TextStyle(
                          color: Colors.teal,
                          letterSpacing: 1.5,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ]
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.timer,
                        size: 25,
                        color: Colors.teal[200],
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Timer',
                        style:TextStyle(
                          fontFamily: 'MontserratBold',
                          color: Colors.teal[200],
                          letterSpacing: 1.5,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.stacked_line_chart_rounded,
                        size: 25,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Stats',
                        style:TextStyle(
                          fontFamily: 'MontserratBold',
                          color: Colors.teal,
                          letterSpacing: 1.5,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet_outlined,
                        size: 25,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Donate',
                        style:TextStyle(
                          fontFamily: 'MontserratBold',
                          color: Colors.teal,
                          letterSpacing: 1.5,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40,),
                  GestureDetector(
                    onTap: ()=>createDialog(context),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 25,
                          color: Colors.teal,
                        ),
                        SizedBox(width: 15),
                        Text(
                          'About',
                          style:TextStyle(
                            fontFamily: 'MontserratBold',
                            color: Colors.teal,
                            letterSpacing: 1.5,
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 40,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star_border_rounded,
                        size: 25,
                        color: Colors.teal,
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Rate',
                        style:TextStyle(
                          fontFamily: 'MontserratBold',
                          color: Colors.teal,
                          letterSpacing: 1.5,
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30,),
                ],
              ),
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    Icon(
                      Icons.settings,
                      size: 23,
                      color: Colors.teal,
                    ),
                    SizedBox(width: 10,),
                    Text(
                      'Settings',
                      style:TextStyle(
                        fontFamily: 'MontserratBold',
                        color: Colors.teal,
                        letterSpacing: 1.5,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 15,),
                    Container(
                      height: 20,
                      width: 2.5,
                      color: Colors.teal,
                    ),
                    SizedBox(width: 15,),
                    GestureDetector(
                      onTap: ((){
                        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                      }),
                      child: Text(
                        'Exit',
                        style:TextStyle(
                          fontFamily: 'MontserratBold',
                          color: Colors.teal,
                          letterSpacing: 1.5,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
  Future<String> createDialog (BuildContext context){
    return showDialog(
        context: context,
        builder: (context) {
          return AboutDialog(
            applicationName: 'Workout Timer',
            applicationVersion: '1.0.0',
          );
        },
    );
  }
}
