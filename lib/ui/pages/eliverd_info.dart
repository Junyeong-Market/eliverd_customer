import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:Eliverd/common/color.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/ui/widgets/stock.dart';

class EliverdInfoPage extends StatefulWidget {
  @override
  _EliverdInfoPageState createState() => _EliverdInfoPageState();
}

class _EliverdInfoPageState extends State<EliverdInfoPage> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
        title: Text(
          '오늘의 혜택',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: [
          Container(
            width: width,
            height: height * 0.4,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: eliverdDarkColor,
              borderRadius: BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 4,
                  child: Image(
                    image: AssetImage('assets/images/example.png'),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '요즘 같은 때, 손소독제 어떠세요?',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                      ),
                      Text(
                        '지금 사면 단돈 ₩5,000원에!',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '오늘의 추천 상품',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              Container(
                width: width,
                height: 212.0,
                child: GridView(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 1.8,
                    mainAxisSpacing: 4.0,
                  ),
                  children: [
                    SimplifiedStock(
                      stock: Stock(
                        amount: 2,
                        price: 100,
                        product: Product(
                          name: '끔찍한 손소독제',
                          manufacturer: Manufacturer(
                            name: '아모레퍼시픽',
                          ),
                          category: 'living',
                        ),
                      ),
                    ),
                    SimplifiedStock(
                      stock: Stock(
                        amount: 9,
                        price: 5000,
                        product: Product(
                          name: '평범한 손소독제',
                          manufacturer: Manufacturer(
                            name: '평범한 회사',
                          ),
                          category: 'living',
                        ),
                      ),
                    ),
                    SimplifiedStock(
                      stock: Stock(
                        amount: 100,
                        price: 1000000000,
                        product: Product(
                          name: '비싸보이는 손소독제',
                          manufacturer: Manufacturer(
                            name: '아모레퍼시픽',
                          ),
                          category: 'living',
                        ),
                      ),
                    ),
                    SimplifiedStock(
                      stock: Stock(
                        amount: 2,
                        price: 10000,
                        product: Product(
                          name: '끔찍한 손소독제',
                          manufacturer: Manufacturer(
                            name: '아모레퍼시픽',
                          ),
                          category: 'food',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
