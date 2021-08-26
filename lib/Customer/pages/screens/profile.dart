import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starter_project/Customer/pages/password/change_password.dart';
import 'package:starter_project/Customer/pages/screens/edit_profile.dart';
import 'package:starter_project/Customer/pages/screens/home.dart';
import 'package:starter_project/Customer/pages/screens/notifications.dart';
import 'package:starter_project/Customer/pages/screens/widgets/badge.dart';
import 'package:starter_project/core/repositories/authentication_repository.dart';
import 'package:starter_project/core/routes/route_names.dart';
import 'package:starter_project/index.dart';
//import 'package:starter_project/models/api_response_variants/customer_login_response.dart';
import 'package:starter_project/models/customer.dart';

import '../../../locator.dart';

class CustomerProfile extends StatefulWidget {
  @override
  _CustomerProfileState createState() => _CustomerProfileState();
}

class _CustomerProfileState extends State<CustomerProfile> {
  final Customer user = locator<UserInfoCache>().customer.data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
         appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Color(0xff9477cb),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: ()=>Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text(
          "Profile",
        ),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: IconBadge(
              icon: Icons.notifications,
              size: 22.0,
            ),
           onPressed: ()=>     Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                    CustomerNotifications()))
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(10.0,0,10.0,0),

        child: ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: user.avatar == null ? Image.asset(
                    "assets/1.png",
                    fit: BoxFit.cover,
                    width: 100.0,
                    height: 100.0,
                  ) : Image.network(
                    user.avatar,
                    fit: BoxFit.cover,
                    width: 100.0,
                    height: 100.0,
                  ),
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            user.userName,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 5.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          InkWell(
                            onTap: () async {
                              bool s =  await Provider.of<AuthRepository>(context, listen: false).logout();
                              if(s){
                                Navigator.of(context).pushNamedAndRemoveUntil(RouteNames.introPage, (route) => false);
                              }
                            },
                            child: Text("Logout",
                              style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff9477cb),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                          ),

                              
                        ],
                      ),

                    ],
                  ),
                  flex: 3,
                ),
              ],
            ),

            Divider(),
            Container(height: 15.0),

            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Account Information".toUpperCase(),
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ListTile(
              title: Text(
                "Username",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              subtitle: Text(
                user.userName,
              ),

              trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20.0,
                ),
               onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                      EditCustomerProfilePage()));
                                          },
                tooltip: "Edit",
              ),
            ),

            ListTile(
              title: Text(
                "Email",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              subtitle: Text(
                user.email,
              ),
            ),

            ListTile(
              title: Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              subtitle: Text(
                user.phone.toString(),
              ),
            ),

            // ListTile(
            //   title: Text(
            //     "Address",
            //     style: TextStyle(
            //       fontSize: 17,
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),

            //   subtitle: Text(
            //     "1347 Bog, NGN",
            //   ),
            // ),
 Divider(),
            Container(height: 15.0),
             ListTile(
              title: Text(
                "Password",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
           
            trailing: IconButton(
                icon: Icon(
                  Icons.edit,
                  size: 20.0,
                ),
               onPressed: () {
                                            Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                      CustomerChangePasswordPage()));
                                          },
                tooltip: "Edit",
              ),
               ),

              // InkWell(
              //             onTap: () {
              //               Navigator.push(
              //                   context,
              //                   MaterialPageRoute(
              //                       builder: (context) => CustomerResetPage()));
              //             },
              //             child: Text("Click here to Change your Password".toUpperCase(),
              //                 style: TextStyle(
              //                     fontWeight: FontWeight.bold, fontSize: 16.0)),
              //           ),
            // ListTile(
            //   title: Text(
            //     "Gender",
            //     style: TextStyle(
            //       fontSize: 17,
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),

            //   subtitle: Text(
            //     "Female",
            //   ),
            // ),

            // ListTile(
            //   title: Text(
            //     "Date of Birth",
            //     style: TextStyle(
            //       fontSize: 17,
            //       fontWeight: FontWeight.w700,
            //     ),
            //   ),

            //   subtitle: Text(
            //     "April 9, 1995",
            //   ),
            // ),

          
  
          ],
        ),
      ),
    );
  }
}