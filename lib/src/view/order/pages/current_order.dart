import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:menu_log/commons/controls/custom_text.dart';
import 'package:menu_log/src/repository/cart/cart_cubit.dart';
import 'package:menu_log/src/view/order/pages/order_detail_page.dart';

class CurrentOrderPage extends StatefulWidget {
  const CurrentOrderPage({super.key});

  @override
  State<CurrentOrderPage> createState() => _CurrentOrderPageState();
}

class _CurrentOrderPageState extends State<CurrentOrderPage> {
  @override
  void initState() {
    context.read<CartCubit>().getOrderHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        return context.read<CartCubit>().getOrderHistory();
      },
      child: Scaffold(
        appBar: AppBar(
          title: CustomText(text: 'Current Orders'),
        ),
        body: BlocBuilder<CartCubit, CartState>(
          builder: (context, state) {
            var orderData = context.read<CartCubit>().orderHistoryModel;
            var orderIds = context.read<CartCubit>().docIds;

            return ListView.builder(
              itemCount: orderData.length,
              itemBuilder: (BuildContext context, int index) {
                return orderData[index].orderStatus != 'Paid'
                    ? ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailPage(
                                    orderData[index], orderIds[index]),
                              ));
                        },
                        title: CustomText(
                            text:
                                "Table Number : ${orderData[index].tableNumber ?? ''}"),
                        trailing: CustomText(
                            text:
                                "Status : ${orderData[index].orderStatus ?? ''}"),
                      )
                    : SizedBox.shrink();
              },
            );
          },
        ),
      ),
    );
  }
}
