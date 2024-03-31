import 'package:flutter/material.dart';

class Medicine {
  final String name;
  final double price;
  final String imagePath;

  Medicine(this.name, this.price, this.imagePath);
}

class MedicineListPage extends StatefulWidget {
  const MedicineListPage({Key? key}) : super(key: key);

  @override
  _MedicineListPageState createState() => _MedicineListPageState();
}

class _MedicineListPageState extends State<MedicineListPage> {
  // Dummy list of medicines
  List<Medicine> medicines = [
    Medicine('Calcium blocker', 200, 'assets/calcium blocker.jpeg'),
    Medicine('Diuretic A', 500, 'assets/Diuretic_Ingles_380x380.jpg'),
    Medicine('Diuretic B', 700, 'assets/Diuretic_Ingles_380x380.jpg'),
  ];

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
              leading: Image.asset(
                medicine.imagePath,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(medicine.name),
              subtitle: Text('\$${medicine.price.toStringAsFixed(2)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Implement logic for buying or adding to cart
                      // For now, we'll just display a message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Buying ${medicine.name}'),
                        ),
                      );
                    },
                    child: Text('Buy'),
                  ),
                  SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: () {
                      // Implement logic for adding to cart
                      // For now, we'll just display a message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Adding ${medicine.name} to cart'),
                        ),
                      );
                    },
                    child: Text('Add to Cart'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
