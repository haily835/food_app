import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'types/types.dart';
import 'widgets/cart.dart';
import 'widgets/food_select.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Food App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: OrderPage(
          foods: [
            Food(
                name: 'Pho',
                price: 10.1,
                img:
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Ph%E1%BB%9F_b%C3%B2%2C_C%E1%BA%A7u_Gi%E1%BA%A5y%2C_H%C3%A0_N%E1%BB%99i.jpg/1599px-Ph%E1%BB%9F_b%C3%B2%2C_C%E1%BA%A7u_Gi%E1%BA%A5y%2C_H%C3%A0_N%E1%BB%99i.jpg',
                category: 'Do an'),
            Food(
                name: 'Bun bo',
                price: 10.3,
                img:
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/0/00/Bun-Bo-Hue-from-Huong-Giang-2011.jpg/1200px-Bun-Bo-Hue-from-Huong-Giang-2011.jpg',
                category: 'Do an'),
            Food(
                name: 'Sting',
                price: 10,
                img:
                    'https://cdn.tgdd.vn/Products/Images/3226/76519/bhx/nuoc-tang-luc-sting-sleek-huong-dau-320ml-202211041423237135.jpg',
                category: 'Thuc uong'),
            Food(
                name: 'Cam',
                price: 10,
                img:
                    'https://suckhoedoisong.qltns.mediacdn.vn/324455921873985536/2022/2/19/cach-lam-nuoc-cam-ep-ngon-va-thom-ket-hop-voi-le-va-gung-5-1645248090817401855254.jpg',
                category: 'Thuc uong'),
          ],
          categories: [
            Category(name: 'All'),
            Category(name: 'Do an'),
            Category(name: 'Thuc uong'),
            Category(name: 'Snack'),
          ],
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
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
  final List<CartItem> items = [];
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
      if (newDiscount == "") discount = 0;
      discount = double.parse(newDiscount);
    });
  }

  void handleChangeTaxAndFee(String newTaxAndFee) {
    setState(() {
      if (newTaxAndFee == "") taxAndFee = 0;
      taxAndFee = double.parse(newTaxAndFee);
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
                flex: 2,
                child: FoodSelect(
                    categories: widget.categories,
                    foods: widget.foods,
                    handleTapFood: handleTapFood
                ),
              ),
              SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Cart(
                    cartItems: items,
                    discount: discount,
                    taxAndFee: taxAndFee,
                    handleChangeCartItem: handleChangeCartItem,
                    handleChangeDiscount: handleChangeDiscount,
                    handleChangeTaxAndFee: handleChangeTaxAndFee,
                  ),
              )
            ],
          ),
        ),
      );
    });
  }
}


