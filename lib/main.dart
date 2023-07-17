import 'package:flutter/material.dart';
import 'types/types.dart';
import 'widgets/cart.dart';
import 'widgets/food_select.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<Category> categories = [
    Category(name: 'All'),
    Category(name: 'Seafood'),
    Category(name: 'Chicken'),
    Category(name: 'Beef'),
    Category(name: 'Pasta'),
    Category(name: 'Dessert'),
  ];

  List<Food> foods = [];

  Future<void> fetchData() async {
    List<Food> foodData = [];

    for (Category category in categories) {
      if (category.name == 'All') continue;

      final response = await http.get(Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/filter.php?c=${category.name}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          for (var meal in data['meals']) {
            foodData.add(Food(
                category: category.name,
                img: meal['strMealThumb'],
                name: meal['strMeal'],
                price: Random().nextDouble() * 20));
          }
        }
      }
    }

    setState(() {
      foods = foodData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food App',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
      ),
      home: OrderPage(
        foods: foods,
        categories: categories,
      ),
    );
  }
}

class OrderPage extends StatefulWidget {
  const OrderPage({required this.foods, required this.categories});
  final List<Food> foods;
  final List<Category> categories;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List<CartItem> items = [];
  double discount = 0;
  double taxAndFee = 0;

  void handleTapFood(Food food) {
    setState(() {
      var itemIndex =
          items.indexWhere((CartItem item) => item.food.name == food.name);
      if (itemIndex == -1) {
        // Add new item to cart
        items.add(CartItem(food: food, quantity: 1));
      } else {
        items[itemIndex].quantity += 1;
      }
    });
  }

  void handleChangeCartItem(CartItem cartItem) {
    setState(() {
      var itemIndex = items
          .indexWhere((CartItem item) => item.food.name == cartItem.food.name);
      if (cartItem.quantity <= 0) {
        items.removeAt(itemIndex);
      } else {
        items[itemIndex] = cartItem;
      }
    });
  }

  void handleChangeDiscount(String newDiscount) {
    setState(() {
      try {
        discount = double.parse(newDiscount);
      } catch (e) {
        discount = 0;
      }
    });
  }

  void handleChangeTaxAndFee(String newTaxAndFee) {
    setState(() {
      try {
        taxAndFee = double.parse(newTaxAndFee);
      } catch (e) {
        taxAndFee = 0;
      }
    });
  }

  void handleClearCart() {
    setState(() {
      items = [];
      taxAndFee = 0;
      discount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          color: Theme.of(context).colorScheme.primaryContainer.withAlpha(70),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: FoodSelect(
                    categories: widget.categories,
                    foods: widget.foods,
                    handleTapFood: handleTapFood),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 3,
                child: Cart(
                  cartItems: items,
                  discount: discount,
                  taxAndFee: taxAndFee,
                  handleChangeCartItem: handleChangeCartItem,
                  handleChangeDiscount: handleChangeDiscount,
                  handleChangeTaxAndFee: handleChangeTaxAndFee,
                  handleClearCart: handleClearCart,
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
