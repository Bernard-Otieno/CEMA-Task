import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task/logic/models/sales_record.dart';
import 'package:task/logic/models/stock_records.dart';
import 'dart:convert';

class Medicine {
  final String name;
  final double price;
  final String imagePath;

  Medicine(this.name, this.price, this.imagePath);
}

class CartItem {
  final Medicine medicine;
  int quantity;

  CartItem(this.medicine, this.quantity);
}

class MedicineListPage extends StatefulWidget {
  const MedicineListPage({Key? key}) : super(key: key);

  @override
  _MedicineListPageState createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  List<CartItem> cartItems = [];
  double totalAmount = 0.0;

  List<Medicine> medicines = [
    Medicine('Calcium blocker', 200, 'assets/calcium blocker.jpeg'),
    Medicine('Diuretic A', 500, 'assets/Diuretic_Ingles_380x380.jpg'),
    Medicine('Diuretic B', 700, 'assets/Diuretic_Ingles_380x380.jpg'),
  ];
  void addToCart(Medicine medicine) {
    setState(() {
      // Check if the medicine is already in the cart
      var existingItemIndex =
          cartItems.indexWhere((item) => item.medicine == medicine);

      if (existingItemIndex != -1) {
        // If the medicine is already in the cart, increase the quantity
        cartItems[existingItemIndex].quantity++;
      } else {
        // If the medicine is not in the cart, add it with quantity 1
        cartItems.add(CartItem(medicine, 1));
      }

      // Update the total amount
      totalAmount += medicine.price;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine List'),
      ),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          Medicine medicine = medicines[index];
          return Card(
            child: ListTile(
              leading: Image.asset(medicine.imagePath),
              title: Text(medicines[index].name),
              subtitle: Text('\$${medicines[index].price.toStringAsFixed(2)}'),
              trailing: ElevatedButton(
                onPressed: () {
                  addToCart(medicine);
                },
                child: const Text('Add to Cart'),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Check if cartItems is not empty before navigating to the checkout page
          if (cartItems.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CheckoutPage(cartItems: cartItems)),
            );
          } else {
            // Show a message or handle the case where cartItems is empty
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Empty Cart'),
                  content: const Text('Your cart is empty.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: const Icon(Icons.shopping_cart),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class CheckoutPage extends StatefulWidget {
  final List<CartItem> cartItems;

  const CheckoutPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? _deliveryOption; // Variable to store the selected delivery option

  @override
  Widget build(BuildContext context) {
    // Calculate the total price by summing up the prices of all cart items
    double totalPrice = widget.cartItems.fold(
      0.0,
      (previousValue, cartItem) =>
          previousValue + (cartItem.medicine.price * cartItem.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = widget.cartItems[index];
                return ListTile(
                  title: Text(cartItem.medicine.name),
                  subtitle: Text(
                      '\$${(cartItem.medicine.price * cartItem.quantity).toStringAsFixed(2)}'),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Select delivery option:'),
                Row(
                  children: [
                    Radio<String>(
                      value: 'delivery',
                      groupValue: _deliveryOption,
                      onChanged: (value) {
                        setState(() {
                          _deliveryOption = value;
                        });
                      },
                    ),
                    const Text('Delivery'),
                  ],
                ),
                Row(
                  children: [
                    Radio<String>(
                      value: 'pickup',
                      groupValue: _deliveryOption,
                      onChanged: (value) {
                        setState(() {
                          _deliveryOption = value;
                        });
                      },
                    ),
                    const Text('Pickup'),
                  ],
                ),
                ElevatedButton(
                  onPressed: () async {
                    // Get the currently authenticated user
                    User? user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      // Get the user's email
                      String buyerEmail = user.email ?? '';

                      // Place your logic for finalizing the purchase here
                      if (_deliveryOption == 'delivery') {
                        try {
                          // Get a reference to the Firestore collection for deliveries
                          CollectionReference deliveryCollection =
                              FirebaseFirestore.instance
                                  .collection('sales')
                                  .doc('Medicines')
                                  .collection('For delivery');

                          // Loop through each cart item and write data to Firestore
                          for (CartItem cartItem in widget.cartItems) {
                            await deliveryCollection.add({
                              'buyer': buyerEmail,
                              'product_name': cartItem.medicine.name,
                              'quantity': cartItem.quantity,
                              'total_price':
                                  cartItem.medicine.price * cartItem.quantity,
                            });

                            // Update stock quantity
                            await updateStock(cartItem);
                          }

                          // Navigate to the next screen or show a success message
                        } catch (e) {
                          // Handle any errors that occur during the Firestore operation
                          print('Error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occurred')),
                          );
                        }
                      } else if (_deliveryOption == 'pickup') {
                        try {
                          // Get a reference to the Firestore collection for deliveries
                          CollectionReference deliveryCollection =
                              FirebaseFirestore.instance
                                  .collection('sales')
                                  .doc('Medicines')
                                  .collection('For pick up');

                          // Loop through each cart item and write data to Firestore
                          for (CartItem cartItem in widget.cartItems) {
                            await deliveryCollection.add({
                              'buyer': buyerEmail,
                              'product_name': cartItem.medicine.name,
                              'quantity': cartItem.quantity,
                              'total_price':
                                  cartItem.medicine.price * cartItem.quantity,
                            });

                            // Update stock quantity
                            await updateStock(cartItem);
                          }

                          // Navigate to the next screen or show a success message
                        } catch (e) {
                          // Handle any errors that occur during the Firestore operation
                          print('Error: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('An error occurred')),
                          );
                        }
                      }
                    } else {
                      // User is not authenticated
                      SnackBar(content: Text('Login please'));
                    }
                  },
                  child: const Text('Buy Now'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Navigate back to the previous screen when cancel button is pressed
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> updateStock(CartItem cartItem) async {
  try {
    String subCollectionName = cartItem.medicine.name; // Sub-collection name

    // Reference to the stock document for the given product
    DocumentReference stockRef = FirebaseFirestore.instance
        .collection('stock')
        .doc(cartItem.medicine.name) // Use cartItem.medicine.name as the sub-collection name
        .collection(cartItem.medicine.name)
        .doc('quantity_available'); // Replace with the appropriate document ID

    // Get the current stock data
    DocumentSnapshot stockSnapshot = await stockRef.get();

    if (stockSnapshot.exists) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('stock').doc('quantity_available').get();

      int currentQuantity = stockSnapshot.data() != null ? stockSnapshot.get('available_quantity') ?? 0 : 0;

      int quantitySold = cartItem.quantity;
      // Update the available quantity by subtracting the quantity sold
      int newQuantity = currentQuantity - quantitySold;

      // Update only the available_quantity field in the stock document
      await stockRef.update({'available_quantity': newQuantity});
    } else {
      print(
          'Stock document does not exist for product: ${cartItem.medicine.name}');
    }
  } catch (e) {
    // Handle any errors
    print('Error updating stock quantity: $e');
  }
}
