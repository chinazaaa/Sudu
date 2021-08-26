import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:starter_project/Customer/pages/screens/customer_single_order.dart';
//import 'package:starter_project/Salon/pages/screens/single_order_screen.dart';
import 'package:starter_project/core/repositories/bookings_repository.dart';
import 'package:starter_project/models/booking.dart';
//import 'package:starter_project/models/api_response_variants/bookings_response.dart';
import 'package:starter_project/ui_helpers/responsive_state/responsive_state.dart';
import 'package:starter_project/ui_helpers/size_config/size_config.dart';
import 'package:starter_project/ui_helpers/widgets/error_retry_widget.dart';

class CustomerUncompletedOrders extends StatefulWidget {
  @override
  _CustomerUncompletedOrdersState createState() => _CustomerUncompletedOrdersState();
}

class _CustomerUncompletedOrdersState extends State<CustomerUncompletedOrders> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<BookingRepo>(context, listen: false)
          .getCustomerUnCompletedBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<BookingRepo>(context);
    return ResponsiveState(
      state: model.state,
      busyWidget: Center(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.widthOf(10)),
          child: CircularProgressIndicator(
            strokeWidth: 6,
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ),
      errorWidget: Center(
          child: Padding(
        padding: EdgeInsets.all(SizeConfig.widthOf(10)),
        child: ErrorRetryWidget(
          errorMessage: model.error,
          onTap: () => model.getCustomerUnCompletedBookings,
        ),
      )),
      idleWidget: Center(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.widthOf(10)),
          child: CircularProgressIndicator(
            strokeWidth: 6,
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          ),
        ),
      ),
      noDataAvailableWidget: Center(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.widthOf(10)),
          child: Text(
            'No Uncompleted orders',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      // dataFetchedWidget: SingleChildScrollView(
      //   child: SingleChildScrollView(
      //     scrollDirection: Axis.horizontal,
      //     child: DataTable(
      //         showBottomBorder: true,
      //         dataRowHeight: 60,
      //         headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
      //         columns: <DataColumn>[
      //           DataColumn(
      //             label: Text('Customer'),
      //           ),
      //           // DataColumn(
      //           //   label: Text('Price'),
      //           // ),
      //           // DataColumn(
      //           //   label: Text('Phone No.'),
      //           // ),
      //           DataColumn(
      //             label: Text('Services'),
      //           ),
      //           DataColumn(
      //             label: Text('Booking Date'),
      //           ),
      //           //  DataColumn(
      //           //   label: Text('Approved?'),
      //           // ),
      //           DataColumn(
      //             label: Text('Actions'),
      //           ),
      //         ],
      //         rows: [
      //           ...model.salonUncompletedOrders
      //               .map(
      //                 (e) {
      //                   // int totalPrice = 0;
      //                   // List<int> prices = e.servicePrice.map((e) => double.tryParse(e).round()).toList();
      //                   // for(int i=0; i<prices.length; i++)
      //                   //   totalPrice = totalPrice + (prices[i] ??0);
      //                   return DataRow(cells: [
      //                   DataCell(Text(e.customerName ?? 'Unknown')),
      //                   //DataCell(Text(totalPrice.toString())),
      //                   //DataCell(Text(e.customerPhone.toString())),
      //                   DataCell(Text(e.serviceName.join(", "))),
      //                   DataCell(Text(e.bookingDate)),
      //                   //DataCell(Text(e.approved.toString())),
      //                   DataCell(
      //                     PopupOptionMenu(e),
      //                   )
      //                 ]);
      //                 },
      //               )
      //               .toList(),
      //         ]),
      //   ),
      // ),
      dataFetchedWidget: ListView(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.widthOf(6), vertical: 20),
        children: [
          ...model.customerUncompletedOrders.map((e) {
            double totalPrice = 0;
            for(String price in e.servicePrice){
              totalPrice = totalPrice + (double.tryParse(price) ?? 0);
            }
            return InkWell(
              onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> CustomerSingleOrderScreen(data: e,))),
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xff9477cb),
                                  borderRadius: BorderRadius.circular(5),
                  // border: Border.all(color: Colors.pink),
                  // color: Colors.white.withOpacity(.3),
                ),
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                         'Salon: ${e.salonName}',
                        style: TextStyle(
                          color: Color(0xFF333366),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Services selected: ${e.serviceName.join(", ")}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Total Price: N$totalPrice',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
            );
          }
          ).toList(),
        ],
      ),
    );
  }
}

enum MenuOption { Complete }

class PopupOptionMenu extends StatelessWidget {
  final Booking data;
  const PopupOptionMenu(this.data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final models = Provider.of<BookingRepo>(context);
    return PopupMenuButton<MenuOption>(
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<MenuOption>>[
          PopupMenuItem(
            //child: Icon(Icons.edit, color: Colors.black, size: 28.0),
            child: ListTile(
               onTap: () async{
                  bool success = await models.completeCustomerOrders(bookingID: data.id);
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
            value: MenuOption.Complete,
          ),
        
        //   PopupMenuItem(
        //     //child: Icon(Icons.edit, color: Colors.black, size: 28.0),
        //     child: ListTile(
        //        onTap: () {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => UncompletedMoreDetailsPage()));
        // },
            
        //       title: Text("More Details")),
        //     value: MenuOption.MoreDetails,
        //   ),
        ];
      },
    );
  }
}
