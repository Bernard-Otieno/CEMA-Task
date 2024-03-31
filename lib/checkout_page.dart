import 'package:flutter/material.dart';

import 'medicine_list_page.dart';


class CheckoutPage extends StatelessWidget {
  final List<CartItem> cartItems;

  const CheckoutPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems[index];
          return ListTile(
            title: Text(cartItem.medicine.name),
            subtitle: Text('\$${cartItem.medicine.price.toStringAsFixed(2)}'),
            trailing: Text('Quantity: ${cartItem.quantity}'),
          );
        },
      ),
    );
  }
}