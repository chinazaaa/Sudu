import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starter_project/core/repositories/bookings_repository.dart';
import 'package:starter_project/index.dart';
import 'package:starter_project/models/booking.dart';
import 'package:starter_project/ui_helpers/size_config/size_config.dart';

// import 'more_details.dart';

class SingleOrderScreen extends StatelessWidget {
  final Booking data;

  const SingleOrderScreen({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final models = Provider.of<BookingRepo>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Order Details", style: TextStyle(fontWeight: FontWeight.bold, color:  Color(0xFF333366)),),
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

          Text(
            'Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
                color:  Color(0xFF333366),
            ),
          ),

          ListTile(
              onTap: () async{
                bool success = await models.completeSalonOrders(bookingID: data.id);
                if(success){
                  //show snackbar
                  Get.snackbar(
                    'Success!',
                    'Booking Completed Successfully',
                    margin: EdgeInsets.symmetric(
                        vertical: 30, horizontal: 30),
                    snackStyle: SnackStyle.FLOATING,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black26,
                  );
                }

              },
              title: Text("Complete Order")),
          ListTile(
              onTap: () async{
                bool success = await models.approveOrders(bookingID: data.id);
                if(success){
                  //show snackbar
                  Get.snackbar(
                    'Success!',
                    'Booking Approved Successfully',
                    margin: EdgeInsets.symmetric(
                        vertical: 30, horizontal: 30),
                    snackStyle: SnackStyle.FLOATING,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black26,
                  );
                }

              },
              title: Text("Approve Order")),
          ListTile(
              onTap: () async{
                bool success = await models.rejectOrders(bookingID: data.id);
                if(success){
                  //show snackbar
                  Get.snackbar(
                    'Success!',
                    'Booking Rejected Successfully',
                    margin: EdgeInsets.symmetric(
                        vertical: 30, horizontal: 30),
                    snackStyle: SnackStyle.FLOATING,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.black26,
                  );
                }

              },
              title: Text("Reject Order")),
        ],
      )
    );
  }
}
