import 'package:Eliverd/ui/widgets/category.dart';
import 'package:Eliverd/ui/widgets/stock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/ui/widgets/shopping_cart_button.dart';

class StoreDisplay extends StatefulWidget {
  final List<Stock> stocks;

  const StoreDisplay({Key key, this.stocks}) : super(key: key);

  @override
  _StoreDisplayState createState() => _StoreDisplayState();
}

class _StoreDisplayState extends State<StoreDisplay> {
  Store store;
  List<Category> categories;

  @override
  void initState() {
    super.initState();

    store = widget.stocks.first.store;
    categories = widget.stocks
        .map((stock) => stock.product.category)
        .map((category) => Categories.listByNetworkPOV[category])
        .toSet()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ButtonTheme(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minWidth: 0,
          height: 0,
          child: FlatButton(
            padding: EdgeInsets.all(0.0),
            textColor: Colors.black,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Text(
              '􀆉',
              style: TextStyle(
                fontWeight: FontWeight.w200,
                fontSize: 24.0,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '상점 살펴보기',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Text(
                    store.name,
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                SizedBox(width: 2.0),
                _buildCategoriesList(),
              ],
            ),
          ],
        ),
        actions: [
          ShoppingCartButton(),
          ButtonTheme(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minWidth: 0,
            height: 0,
            child: FlatButton(
              padding: EdgeInsets.only(
                right: 16.0,
              ),
              textColor: Colors.black,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Text(
                '􀙊',
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 24.0,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: StockList(
          stocks: widget.stocks,
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _buildCategoriesList() => Container(
    width: 80.0,
    height: 16.0,
    child: GridView.builder(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.horizontal,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        return SimplifiedCategoryWidget(
          categoryId: categories[index].id,
        );
      },
      itemCount: categories.length,
    ),
  );

}
