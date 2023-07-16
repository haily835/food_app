import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class Category {
  const Category({required this.name});
  final String name;
}

class Food {
  const Food(
      {required this.name,
      required this.price,
      required this.img,
      required this.category});
  final String name;
  final int price;
  final String img;
  final String category;
}

class CartItem {
  CartItem({required this.food, required this.quantity});
  final Food food;
  int quantity = 0;
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
                price: 10,
                img:
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/9/99/Ph%E1%BB%9F_b%C3%B2%2C_C%E1%BA%A7u_Gi%E1%BA%A5y%2C_H%C3%A0_N%E1%BB%99i.jpg/1599px-Ph%E1%BB%9F_b%C3%B2%2C_C%E1%BA%A7u_Gi%E1%BA%A5y%2C_H%C3%A0_N%E1%BB%99i.jpg',
                category: 'Do an'),
            Food(
                name: 'Bun bo',
                price: 10,
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: FoodSelect(
                    categories: widget.categories,
                    foods: widget.foods,
                    handleTapFood: handleTapFood),
              ),
              Expanded(
                flex: 1,
                child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Cart(
                        cartItems: items,
                        handleChangeCartItem: handleChangeCartItem)),
              )
            ],
          ),
        ),
      );
    });
  }
}

typedef ChangeCartItemCallBack = Function(CartItem cartItem);

class Cart extends StatelessWidget {
  Cart({required this.cartItems, required this.handleChangeCartItem});
  final List<CartItem> cartItems;
  final ChangeCartItemCallBack handleChangeCartItem;

  void _handleIncreaseQuantity(CartItem cartItem) {
    cartItem.quantity += 1;
    handleChangeCartItem(cartItem);
  }

  void _handleDecreaseQuantity(CartItem cartItem) {
    cartItem.quantity -= 1;
    handleChangeCartItem(cartItem);
  }

  Widget _buildCartItem(CartItem cartItem) => Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(cartItem.food.name),
          Text(cartItem.food.price.toString()),
          GestureDetector(
              child: Icon(Icons.remove_circle),
              onTap: () => _handleDecreaseQuantity(cartItem)),
          Text(cartItem.quantity.toString()),
          GestureDetector(
            child: Icon(Icons.add_circle),
            onTap: () => _handleIncreaseQuantity(cartItem),
          ),
          Text((cartItem.quantity * cartItem.food.price).toString())
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(
      children: [
        Text('Current cart', style: Theme.of(context).textTheme.headlineMedium),
        Expanded(
          child: Column(
              children: cartItems
                  .map((CartItem cartItem) => _buildCartItem(cartItem))
                  .toList()),
        ),
        Divider(thickness: 1),
        Column(children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Subtotal: '), Text('1000\$')]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Discount sales: '), Text('1000\$')]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Tax and fee: '), Text('1000\$')]),
        ]),
        Divider(thickness: 1, color: Colors.black),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: Theme.of(context).textTheme.titleMedium),
            Text('10000\$', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: TextButton(onPressed: () {}, child: Text('CONTINUE PAYMENT')),
        )
        
      ],
    ));
  }
}

typedef TapFoodCallback = Function(Food food);
typedef ChangeSearchKeyCallback = Function(String newSearchKey);

class FoodHeader extends StatelessWidget {
  FoodHeader({
    required this.searchKey,
    required this.handleChangeSearchKey,
  });

  final String searchKey;
  final ChangeSearchKeyCallback handleChangeSearchKey;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Point of sales', style: Theme.of(context).textTheme.headlineMedium),
      SizedBox(width: 30),
      Expanded(
        child: TextField(
          onSubmitted: (value) => handleChangeSearchKey(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            labelText: 'Search product...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
      )
    ]);
  }
}

class FoodSelect extends StatefulWidget {
  FoodSelect(
      {required this.categories,
      required this.foods,
      required this.handleTapFood});

  final List<Category> categories;
  final List<Food> foods;
  final TapFoodCallback handleTapFood;

  @override
  State<FoodSelect> createState() => _FoodSelectState();
}

class _FoodSelectState extends State<FoodSelect> {
  Category selectedCategory = Category(name: 'All');
  String searchKey = "";

  void handleSelectCategory(Category category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void handleChangeSearchKey(String newSearchKey) {
    setState(() {
      searchKey = newSearchKey;
    });
  }

  Widget _buildCategorySelector() => Row(
        children: widget.categories.map((Category category) {
          return GestureDetector(
            onTap: () => handleSelectCategory(category),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category.name,
                  style: TextStyle(
                      fontWeight: selectedCategory.name == category.name
                          ? FontWeight.bold
                          : FontWeight.normal),
                ),
              ),
            ),
          );
        }).toList(),
      );

  Widget _buildFoodList() => Expanded(
        child: GridView.extent(
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            padding: const EdgeInsets.all(4),
            maxCrossAxisExtent: 300,
            children: widget.foods
                .where((Food food) =>
                    selectedCategory.name == 'All' ||
                    food.category == selectedCategory.name)
                .where((Food food) =>
                    food.name.toLowerCase().contains(searchKey.toLowerCase()))
                .map((Food food) =>
                    FoodCard(food: food, handleTapFood: widget.handleTapFood))
                .toList()),
      );

  Widget _buildFoodHeader() => FoodHeader(
      searchKey: searchKey, handleChangeSearchKey: handleChangeSearchKey);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildFoodHeader(),
      _buildCategorySelector(),
      _buildFoodList(),
    ]);
  }
}

class FoodCard extends StatelessWidget {
  const FoodCard({
    super.key,
    required this.food,
    required this.handleTapFood,
  });

  final Food food;
  final TapFoodCallback handleTapFood;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => handleTapFood(food),
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Image.network(food.img, width: 150, height: 150, fit: BoxFit.fill),
          Text(food.name),
          Text(food.price.toString())
        ]),
      )),
    );
  }
}
