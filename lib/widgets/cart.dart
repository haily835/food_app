import 'package:flutter/material.dart';
import 'package:food_app/types/types.dart';

class Cart extends StatelessWidget {
  Cart({
    required this.cartItems,
    required this.handleChangeCartItem,
    required this.handleChangeDiscount,
    required this.handleChangeTaxAndFee,
    required this.discount,
    required this.taxAndFee,
  });

  final List<CartItem> cartItems;
  final ChangeCartItemCallBack handleChangeCartItem;
  final ChangeDiscountCallback handleChangeDiscount;
  final ChangeTaxAndFeeCallback handleChangeTaxAndFee;
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

  double _calculateCartTotal() {
    double subTotal = 0;
    for (CartItem cartItem in cartItems) {
      subTotal += cartItem.quantity * cartItem.food.price;
    }
    return subTotal - discount + taxAndFee;
  }

  Widget _buildCartItem(CartItem cartItem) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: ListTile(
          leading: Card(
            child: CircleAvatar(
                child: Image.network(cartItem.food.img,
                    width: 50, height: 50, fit: BoxFit.cover)),
          ),
          title: Text(
            cartItem.food.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("${cartItem.food.price.toString()} \$"),
          trailing: SizedBox(
            width: 120,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                    child: IconButton(
                      onPressed: () => _handleDecreaseQuantity(cartItem),
                      icon: Icon(Icons.remove, size: 16),
                    ),
                  ),
                  Text(cartItem.quantity.toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 30,
                    child: IconButton(
                      onPressed: () => _handleIncreaseQuantity(cartItem),
                      icon: Icon(Icons.add, size: 16),
                    ),
                  ),
                ]),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
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
                                onChanged: (value) => handleChangeDiscount(value),
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
                                onChanged: (value) => handleChangeTaxAndFee(value),
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
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                  Text('${_calculateCartTotal().toStringAsFixed(2)} \$',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                child: FilledButton(
                  onPressed: () {},
                  child: Text('CONTINUE PAYMENT'),
                ),
              )
            ],
          ),
        ));
  }
}
