import 'package:date_format/date_format.dart';
import 'package:den_store_dag/services/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  @override
  Widget build(BuildContext context) {
    var events = Provider.of<List<Event>>(context);

    return Container(
      child: new Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(50, 0, 50, 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(events[index].name,
                    style: Theme.of(context).textTheme.title),
                Column(children: <Widget>[
                  Text(
                      "Kl. " +
                          formatDate(
                              events[index].start.toUtc(), [HH, ':', nn]),
                      style: Theme.of(context).textTheme.subhead),
                ]),
                new Image.network(events[index].image, fit: BoxFit.fill)
              ],
            ),
          );
        },
        itemCount: events.length,
        pagination: new SwiperPagination(
            //margin: new EdgeInsets.all(5.0),
            builder: new DotSwiperPaginationBuilder(
                color: Colors.black12, activeColor: Colors.grey)),
        control: new SwiperControl(),
      ),
    );
  }
}
