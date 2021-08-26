import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starter_project/core/repositories/bookings_repository.dart';
import 'package:starter_project/index.dart';
import 'package:starter_project/models/booking.dart';
import 'package:starter_project/ui_helpers/size_config/size_config.dart';

import 'more_details.dart';

class CompletedSingleOrderScreen extends StatelessWidget {
  final Booking data;

  const CompletedSingleOrderScreen({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final models = Provider.of<BookingRepo>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Order Details", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF333366)),),
        leading: BackButton(
          color: Colors.black, onPressed: ()=> Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(6), vertical: 20),
        children: [
          Text(
              'Customer Information',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                   color:  Color(0xFF333366),
              ),
          ),
          SizedBox(height: 10),
          Text(
            "Customer: " + data.customerName,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
           SizedBox(height: 10),
          Text(
            "Phone: " + data.customerPhone,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          
          SizedBox(height: 50),

          Text(
            'Order Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
               color:  Color(0xFF333366),
            ),
          ),
          SizedBox(height: 10),
          for(int i = 0; i< data.serviceName.length; i++)
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      "Service Booked: " +   data.serviceName[i],
                      style: TextStyle(
                          fontSize: 14,
                      ),
                  ),
                   SizedBox(height: 10),
                  Text(
                    "Price: " +    data.servicePrice[i],
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                   SizedBox(height: 10),
          Text(
            "Date Booked: " + data.bookingDate,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
           SizedBox(height: 10),
          Text(
            "Completed: " + data.completedBySalon.toString(),
            style: TextStyle(
              fontSize: 14,
            ),
          ),

                ],
              ),
            ),
          SizedBox(height: 50),

        ],
      )
    );
  }
}
