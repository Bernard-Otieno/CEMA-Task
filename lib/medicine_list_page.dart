import 'package:flutter/material.dart';

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
        var existingItemIndex = cartItems.indexWhere((item) => item.medicine == medicine);


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
        MaterialPageRoute(builder: (context) => CheckoutPage(cartItems: cartItems)),
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
class CheckoutPage extends StatelessWidget {
  final List<CartItem> cartItems;

  const CheckoutPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate the total price by summing up the prices of all cart items
    double totalPrice = cartItems.fold(
      0.0,
      (previousValue, cartItem) => previousValue + (cartItem.medicine.price * cartItem.quantity),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final cartItem = cartItems[index];
                return ListTile(
                  title: Text(cartItem.medicine.name),
                  subtitle: Text('\$${(cartItem.medicine.price * cartItem.quantity).toStringAsFixed(2)}'),
                  trailing: const Row(
                    mainAxisSize: MainAxisSize.min,
 
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Place your logic for finalizing the purchase here
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
