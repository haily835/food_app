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
  final double price;
  final String img;
  final String category;
}

class CartItem {
  CartItem({required this.food, required this.quantity});
  final Food food;
  int quantity = 0;
}


typedef ChangeCartItemCallBack = Function(CartItem cartItem);
typedef TapFoodCallback = Function(Food food);
typedef ChangeSearchKeyCallback = Function(String newSearchKey);
typedef ChangeDiscountCallback = Function(String discount);
typedef ChangeTaxAndFeeCallback = Function(String taxAndFee);
typedef ClearCartCallback = Function();