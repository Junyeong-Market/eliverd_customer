import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/ui/pages/product_info.dart';
import 'package:Eliverd/ui/widgets/category.dart';

class StockList extends StatelessWidget {
  final List<Stock> stocks;

  const StockList({Key key, @required this.stocks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(0.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.51,
      ),
      itemBuilder: (context, index) => SimplifiedStock(
        stock: stocks[index],
      ),
      itemCount: stocks.length,
    );
  }
}

class StockListOnCart extends StatelessWidget {
  final List<Stock> stocks;
  final ValueNotifier<List<int>> amounts;
  final Function removeHandler;

  const StockListOnCart(
      {Key key,
      @required this.stocks,
      @required this.amounts,
      @required this.removeHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8.0),
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, index) => SimplifiedStockOnCart(
        stock: stocks[index],
        onAmountChange: (int newAmount) {
          List<int> newAmounts = List.of(amounts.value);

          newAmounts[index] = newAmount;

          amounts.value = newAmounts;
        },
        onRemove: () {
          removeHandler(stocks[index]);
        },
        previousAmount: amounts.value.isEmpty ? 1 : amounts.value[index],
      ),
      itemCount: stocks.length,
    );
  }
}

class StockListOnOrder extends StatelessWidget {
  final List<OrderedStock> orderedStocks;

  const StockListOnOrder({Key key, @required this.orderedStocks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) =>
          StockOnOrder(orderedStock: orderedStocks[index]),
      itemCount: orderedStocks.length,
    );
  }
}

class SimplifiedStock extends StatelessWidget {
  final Stock stock;

  const SimplifiedStock({Key key, @required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductInfoPage(
              stock: stock,
            ),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0.0,
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: width * 0.33,
                height: width * 0.33,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    '사진 없음',
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 12.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                stock.product.manufacturer.name,
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black45,
                  fontSize: 11.0,
                ),
              ),
              Text(
                stock.product.name,
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 13.0,
                ),
              ),
              Text(
                formattedPrice(stock.price),
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17.0,
                ),
              ),
              SizedBox(height: 1.6),
              CategoryWidget(
                categoryId: stock.product.category,
                fontSize: 9.0,
                padding: 2.0,
              ),
              SizedBox(height: 1.6),
              Visibility(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius:
                    BorderRadius.all(Radius.circular(5.0)),
                  ),
                  padding: EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        '􀋙 ${stock.amount}개 남음!',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 9.0,
                        ),
                      ),
                    ],
                  ),
                ),
                visible: stock.amount <= 3,
                maintainSize: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formattedPrice(int price) {
    if (price >= 100000000) {
      return '₩' +
          (price / 100000000).toStringAsFixed(price % 100000000 == 0 ? 0 : 1) +
          '억';
    } else if (price >= 10000000) {
      return '₩' +
          (price / 10000).toStringAsFixed(price % 10000 == 0 ? 0 : 1) +
          '만';
    }

    return NumberFormat.currency(
      locale: 'ko',
      symbol: '₩',
    )?.format(price);
  }
}

class SpecifiedStock extends StatelessWidget {
  final Stock stock;

  const SpecifiedStock({Key key, @required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          fit: FlexFit.loose,
          child: Container(
            width: width,
            height: width,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Center(
              child: Text(
                '누가 봐도 이 상품에 대한 사진',
                style: const TextStyle(
                  color: Colors.black45,
                  fontSize: 14.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4.0),
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 4.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                stock.product.manufacturer.name,
                maxLines: 1,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.0,
                ),
              ),
              Text(
                stock.product.name,
                maxLines: 2,
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w400,
                  fontSize: 19.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formattedPrice(stock.price),
                    maxLines: 1,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24.0,
                    ),
                  ),
                  Row(
                    children: [
                      CategoryWidget(
                        categoryId: stock.product.category,
                      ),
                      SizedBox(width: 4.0),
                      Visibility(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                          ),
                          padding: EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                '􀋙 ${stock.amount}개 남음!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        visible: stock.amount <= 3,
                        maintainSize: false,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String formattedPrice(int price) {
    return NumberFormat.currency(
      locale: 'ko',
      symbol: '₩',
    )?.format(price);
  }
}

class SimplifiedStockOnCart extends StatefulWidget {
  final Stock stock;
  final Function onAmountChange;
  final Function onRemove;
  final int previousAmount;

  const SimplifiedStockOnCart(
      {Key key,
      @required this.stock,
      @required this.onAmountChange,
      @required this.onRemove,
      this.previousAmount})
      : super(key: key);

  @override
  _SimplifiedStockOnCartState createState() => _SimplifiedStockOnCartState();
}

class _SimplifiedStockOnCartState extends State<SimplifiedStockOnCart> {
  FixedExtentScrollController amountScrollController;

  int price;
  int amount;

  @override
  void initState() {
    super.initState();

    amount = widget.previousAmount ?? 1;
    price = widget.stock.price * amount;
    amountScrollController =
        FixedExtentScrollController(initialItem: amount - 1);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: 0.0,
        right: 8.0,
        top: 8.0,
        bottom: 0.0,
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(
                height: width * 0.25,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    '사진 없음',
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 4.0),
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.stock.product.manufacturer.name,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                              fontSize: 13.0,
                            ),
                          ),
                          Text(
                            widget.stock.product.name,
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.0,
                            ),
                          ),
                          SizedBox(height: 1.6),
                          CategoryWidget(
                            categoryId: widget.stock.product.category,
                            fontSize: 9.0,
                            padding: 2.0,
                          ),
                        ],
                      ),
                    ),
                    ButtonTheme(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minWidth: 0,
                      height: 0,
                      child: FlatButton(
                        padding: EdgeInsets.all(0.0),
                        textColor: Colors.black,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        child: Text(
                          '􀆄',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18.0,
                          ),
                        ),
                        onPressed: widget.onRemove,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          '수량',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Container(
                          width: 32.0,
                          height: 24.0,
                          child: CupertinoPicker.builder(
                            scrollController: amountScrollController,
                            itemExtent: 24.0,
                            onSelectedItemChanged: (index) {
                              setState(() {
                                amount = index + 1;

                                widget.onAmountChange(amount);

                                price = widget.stock.price * amount;
                              });
                            },
                            itemBuilder: (context, index) {
                              return Text(
                                (index + 1).toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 17.0,
                                ),
                              );
                            },
                            childCount: widget.stock.amount + 1,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Text(
                        formattedPrice(price),
                        maxLines: 1,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 19.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formattedPrice(int price) {
    if (price >= 100000000) {
      return '₩' +
          (price / 100000000).toStringAsFixed(price % 100000000 == 0 ? 0 : 1) +
          '억';
    } else if (price >= 10000000) {
      return '₩' +
          (price / 10000).toStringAsFixed(price % 10000 == 0 ? 0 : 1) +
          '만';
    }

    return NumberFormat.currency(
      locale: 'ko',
      symbol: '₩',
    )?.format(price);
  }
}

class StockOnOrder extends StatelessWidget {
  final OrderedStock orderedStock;

  const StockOnOrder({Key key, this.orderedStock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: 0.0,
        right: 0.0,
        top: 8.0,
        bottom: 0.0,
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(
                height: width * 0.25,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    '사진 없음',
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 4.0),
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderedStock.stock.product.manufacturer.name,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                      ),
                    ),
                    Text(
                      orderedStock.stock.product.name,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 17.0,
                      ),
                    ),
                    SizedBox(height: 1.6),
                    CategoryWidget(
                      categoryId: orderedStock.stock.product.category,
                      fontSize: 9.0,
                      padding: 2.0,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          '수량 ${orderedStock.amount}개',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${formattedPrice(orderedStock.stock.price)} * ${orderedStock.amount}',
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w500,
                              fontSize: 10.0,
                            ),
                          ),
                          Text(
                            formattedPrice(
                                orderedStock.stock.price * orderedStock.amount),
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 19.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formattedPrice(int price) {
    if (price >= 100000000) {
      return '₩' +
          (price / 100000000).toStringAsFixed(price % 100000000 == 0 ? 0 : 1) +
          '억';
    } else if (price >= 10000000) {
      return '₩' +
          (price / 10000).toStringAsFixed(price % 10000 == 0 ? 0 : 1) +
          '만';
    }

    return NumberFormat.currency(
      locale: 'ko',
      symbol: '₩',
    )?.format(price);
  }
}

class StockOnDelivery extends StatelessWidget {
  final OrderedStock orderedStock;

  const StockOnDelivery({Key key, this.orderedStock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(
        left: 0.0,
        right: 0.0,
        top: 8.0,
        bottom: 0.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: ConstrainedBox(
              constraints: BoxConstraints.expand(
                height: width * 0.25,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: Text(
                    '사진 없음',
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 12.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 4.0),
          Flexible(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  orderedStock.stock.product.manufacturer.name,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                    fontSize: 13.0,
                  ),
                ),
                Text(
                  orderedStock.stock.product.name,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                ),
                SizedBox(height: 1.6),
                CategoryWidget(
                  categoryId: orderedStock.stock.product.category,
                  fontSize: 9.0,
                  padding: 2.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formattedPrice(int price) {
    return NumberFormat.currency(
      locale: 'ko',
      symbol: '₩',
    )?.format(price);
  }
}