import 'package:provider/provider.dart';
import 'package:starter_project/Customer/pages/screens/orders.dart';
import 'package:starter_project/Salon/pages/screens/uncompleted_more_details.dart';
import 'package:starter_project/Salon/pages/screens/utils/app_properties.dart';
// import 'package:ecommerce_int2/screens/rating/rating_page.dart';
// import 'package:ecommerce_int2/screens/tracking_page.dart';
import 'package:flutter/material.dart';
import 'package:starter_project/core/repositories/bookings_repository.dart';
import 'package:starter_project/ui_helpers/responsive_state/responsive_state.dart';
import 'package:starter_project/ui_helpers/size_config/size_config.dart';

class UncompletedMoreDetailsPage extends StatefulWidget {
  @override
  _UncompletedMoreDetailsState createState() => _UncompletedMoreDetailsState();
}

class _UncompletedMoreDetailsState extends State<UncompletedMoreDetailsPage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<BookingRepo>(context, listen: false)
          .getSalonUnCompletedBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<BookingRepo>(context);
    return Material(
      color: Colors.grey[100],
      child: SafeArea(
        child: Container(
            margin: const EdgeInsets.only(top: kToolbarHeight),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'More Details',
                    style: TextStyle(
                      color: darkGrey,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SalonUncompletedMoreDetails()
                ],
              ),
        
            ])),
      ),
    );
  }
}