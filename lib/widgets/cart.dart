import 'package:flutter/material.dart';
import 'package:food_app/types/types.dart';

class Cart extends StatelessWidget {
  Cart({
    required this.cartItems,
    required this.handleChangeCartItem,
    required this.handleChangeDiscount,
    required this.handleChangeTaxAndFee,
    required this.handleClearCart,
    required this.discount,
    required this.taxAndFee,
  });

  final List<CartItem> cartItems;
  final ChangeCartItemCallBack handleChangeCartItem;
  final ChangeDiscountCallback handleChangeDiscount;
  final ChangeTaxAndFeeCallback handleChangeTaxAndFee;
  final ClearCartCallback handleClearCart;
  final double discount;
  final double taxAndFee;

  void _handleIncreaseQuantity(CartItem cartItem) {
    cartItem.quantity += 1;
    handleChangeCartItem(cartItem);
  }

  void _handleDecreaseQuantity(CartItem cartItem) {
    cartItem.quantity -= 1;
    handleChangeCartItem(cartItem);
  }

  void _handleDelete(CartItem cartItem) {
    cartItem.quantity = 0;
    handleChangeCartItem(cartItem);
  }

  void _handleClearCart() {
    handleClearCart();
  }

  double _calculateCartTotal() {
    double subTotal = 0;
    for (CartItem cartItem in cartItems) {
      subTotal += cartItem.quantity * cartItem.food.price;
    }
    return subTotal - discount + taxAndFee;
  }

  Widget _buildCartItem(CartItem cartItem) => ListTile(
        leading: Image.network(cartItem.food.img,
            width: 50, height: 50, fit: BoxFit.cover),
        title: Text(
          cartItem.food.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text("${cartItem.food.price.toStringAsFixed(2)} \$"),
        trailing: SizedBox(
          width: 150,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SizedBox(
              height: 30,
              width: 30,
              child: IconButton(
                onPressed: () => _handleDecreaseQuantity(cartItem),
                icon: Icon(Icons.remove, size: 14),
              ),
            ),
            Text(cartItem.quantity.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 30,
              width: 30,
              child: IconButton(
                onPressed: () => _handleIncreaseQuantity(cartItem),
                icon: Icon(Icons.add, size: 14),
              ),
            ),
            SizedBox(
              height: 30,
              width: 30,
              child: IconButton(
                onPressed: () => _handleDelete(cartItem),
                icon: Icon(Icons.delete, size: 14),
              ),
            ),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Current cart',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              Divider(thickness: 1),
              Expanded(
                child: ListView(
                    children: cartItems
                        .map((CartItem cartItem) => _buildCartItem(cartItem))
                        .toList()),
              ),
              Divider(thickness: 1),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[200],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Discount sales:'),
                          SizedBox(
                            width: 150,
                            child: TextField(
                                textAlign: TextAlign.right,
                                onChanged: (value) =>
                                    handleChangeDiscount(value),
                                decoration: InputDecoration(
                                  hintText: '0',
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  border: InputBorder.none,
                                  suffixText: '\$',
                                )),
                          )
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tax and fee:'),
                          SizedBox(
                            width: 150,
                            child: TextField(
                                textAlign: TextAlign.right,
                                onChanged: (value) =>
                                    handleChangeTaxAndFee(value),
                                decoration: InputDecoration(
                                  hintText: '0',
                                  contentPadding:
                                      EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  border: InputBorder.none,
                                  suffixText: '\$',
                                )),
                          )
                        ]),
                  ]),
                ),
              ),
              Divider(thickness: 1, color: Colors.black),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total',
                      style: theme.textTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  Text('${_calculateCartTotal().toStringAsFixed(2)} \$',
                      style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.primaryColor)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                child: FilledButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirm payment'),
                          content: Text('This will clear the current cart.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _handleClearCart();
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('CONTINUE PAYMENT'),
                ),

              )
            ],
          ),
        ));
  }
}
