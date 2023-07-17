import 'package:flutter/material.dart';
import 'package:food_app/types/types.dart';

class FoodHeader extends StatelessWidget {
  FoodHeader({
    required this.searchKey,
    required this.handleChangeSearchKey,
  });

  final String searchKey;
  final ChangeSearchKeyCallback handleChangeSearchKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('Point of sales',
            style: Theme.of(context)
                .textTheme
                .headlineMedium!
                .copyWith(fontWeight: FontWeight.bold)),
        SizedBox(width: 100),
        Expanded(
          child: SizedBox(
            height: 40,
            width: 200,
            child: TextField(
              onSubmitted: (value) => handleChangeSearchKey(value),
              style: TextStyle(fontSize: 14, height: 1),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                labelText: 'Search meal...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        )
      ]),
    );
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
    ThemeData theme = Theme.of(context);

    return GestureDetector(
        onTap: () => handleTapFood(food),
        child: Card(
          elevation: 0,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: Image.network(food.img, fit: BoxFit.fill)),
                  SizedBox(height: 10),
                  Text(
                    food.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "${food.price.toStringAsFixed(2)} \$",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: theme.primaryColor),
                  )
                ]),
          ),
        ));
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

  Widget _buildCategorySelector(BuildContext context) => Row(
        children: widget.categories.map((Category category) {
          final theme = Theme.of(context);

          return GestureDetector(
            onTap: () => handleSelectCategory(category),
            child: Card(
              elevation: 1,
              color: selectedCategory.name == category.name
                  ? theme.colorScheme.primary
                  : null,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  category.name,
                  style: selectedCategory.name == category.name
                      ? theme.textTheme.bodyMedium!
                          .copyWith(color: theme.colorScheme.onPrimary)
                      : null,
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
      _buildCategorySelector(context),
      _buildFoodList(),
    ]);
  }
}
