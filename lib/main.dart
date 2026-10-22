
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFFAF5FC),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7041A6),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF7041A6),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7041A6),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF7041A6),
              side: const BorderSide(
                color: Color(0xFFE8B4D8),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
        ),
        home: const CartScreen(),
      ),
    );

class CartItem {
  String name;
  double price;
  int quantity;
  bool gotIt;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
    this.gotIt = false,
  });
}


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final List<CartItem> _items = [];

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _priceController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _items.addAll([
      CartItem(name: 'Rice', price: 60.00, quantity: 2),
      CartItem(name: 'Eggs', price: 8.00, quantity: 12),
      CartItem(name: 'Milk', price: 95.00, quantity: 1),
    ]);
  }


  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _increase(int i) {
    setState(() {
      if (_items[i].quantity < 99) {
        _items[i].quantity++;
      }
    });
  }


  void _decrease(int i) {
    setState(() {
      if (_items[i].quantity > 1) {
        _items[i].quantity--;
      }
    });
  }

  void _toggle(int i) {
    setState(() {
      _items[i].gotIt = !_items[i].gotIt;
    });
  }


  void _addItem() {
    final name = _nameController.text.trim();
    final price = double.tryParse(
      _priceController.text.trim(),
    );

    if (name.isEmpty || price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a valid name and a price greater than 0.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _items.add(
        CartItem(
          name: name,
          price: price,
        ),
      );

      _nameController.clear();
      _priceController.clear();
    });

    FocusScope.of(context).unfocus();
  }

  void _clearChecked() {
    setState(() {
      _items.removeWhere((item) => item.gotIt);
    });
  }

  double get _total {
    return _items.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gotItCount =
        _items.where((item) => item.gotIt).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mini Shopping Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
           
            Expanded(
              child: _items.isEmpty
                  ? const Center(
                      child: Text('Cart is empty'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        10, 8, 10, 8,
                      ),
                      itemCount: _items.length,
                      itemBuilder: (context, i) {
                        return CartItemTile(
                          item: _items[i],
                          onIncrease: () => _increase(i),
                          onDecrease: () => _decrease(i),
                          onToggle: () => _toggle(i),
                        );
                      },
                    ),
            ),

         
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF5E5F2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Items: ${_items.length}  •  Got it: $gotItCount',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF725D75),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Total: PHP ${_total.toStringAsFixed(2)}',
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7041A6),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                12, 8, 12, 4,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Item name',
                        labelStyle: const TextStyle(
                          color: Color(0xFF7041A6),
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _priceController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: const TextStyle(
                          color: Color(0xFF7041A6),
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(7),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                12, 4, 12, 12,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _addItem,
                      child: const Text('Add'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _clearChecked,
                      child: const Text('Clear checked'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onToggle;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF8E5BB7);

    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 6,
        ),
        leading: Checkbox(
          value: item.gotIt,
          activeColor: teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: item.gotIt
                ? Colors.grey
                : Colors.black87,
            decoration: item.gotIt
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        subtitle: Text(
          'PHP ${item.price.toStringAsFixed(2)} each',
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF657575),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.remove_circle_outline,
              ),
              color: teal,
              onPressed:
                  item.quantity > 1 ? onDecrease : null,
            ),
            Text(
              '${item.quantity}',
              style: const TextStyle(fontSize: 13),
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(
                Icons.add_circle_outline,
              ),
              color: teal,
              onPressed:
                  item.quantity < 99 ? onIncrease : null,
            ),
          ],
        ),
      ),
    );
  }
}
