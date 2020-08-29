import 'package:Eliverd/ui/widgets/stock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'package:Eliverd/resources/providers/providers.dart';
import 'package:Eliverd/resources/repositories/repositories.dart';

import 'package:Eliverd/bloc/eventBloc.dart';
import 'package:Eliverd/bloc/events/eventEvent.dart';
import 'package:Eliverd/bloc/states/eventState.dart';

import 'package:Eliverd/models/models.dart';

import 'package:Eliverd/common/color.dart';

class EliverdInfoPage extends StatefulWidget {
  @override
  _EliverdInfoPageState createState() => _EliverdInfoPageState();
}

class _EliverdInfoPageState extends State<EliverdInfoPage> {
  EventBloc _eventBloc;

  @override
  void initState() {
    super.initState();

    _eventBloc = EventBloc(
      storeRepository: StoreRepository(
        storeAPIClient: StoreAPIClient(
          httpClient: http.Client(),
        ),
      ),
    );

    _getCurrentLocation().then((location) {
      _eventBloc.add(FetchEventItem(location));
    });
  }

  @override
  void dispose() {
    _eventBloc.close();

    super.dispose();
  }

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
                child: BlocBuilder<EventBloc, EventState>(
                  cubit: _eventBloc,
                  builder: (context, state) {
                    if (state is EventItemFetched) {
                      if (state.items.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                '오늘의 추천 상품이 없습니다.',
                                style: TextStyle(
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: 1.8,
                          mainAxisSpacing: 4.0,
                        ),
                        itemBuilder: (context, index) {
                          return SimplifiedStock(
                            stock: state.items[index],
                          );
                        },
                        itemCount: state.items.length,
                      );
                    } else if (state is EventError) {
                      return Center(
                        child: Column(
                          children: [
                            ButtonTheme(
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              minWidth: 0,
                              height: 0,
                              child: FlatButton(
                                padding: EdgeInsets.all(0.0),
                                textColor: Colors.black12,
                                child: Text(
                                  '⟳',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 56.0,
                                  ),
                                ),
                                onPressed: () {
                                  _getCurrentLocation().then((location) {
                                    _eventBloc.add(FetchEventItem(location));
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              '유저 프로필을 불러오는 중 오류가 발생했습니다.\n다시 시도해주세요.',
                              style: TextStyle(
                                color: Colors.black26,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    }

                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '추천 상품을 불러오고 있습니다.\n잠시 기다려주세요.',
                            style: TextStyle(
                              color: Colors.black26,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          CupertinoActivityIndicator(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Coordinate> _getCurrentLocation() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);

    return Coordinate(
      lat: position.latitude,
      lng: position.longitude,
    );
  }
}
