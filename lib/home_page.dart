import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _homePage();
  }
}

class _homePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: episodes(),
    );
  }

  Widget episodes(){
    return FutureBuilder(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.done && projectSnap.hasData) {
          var raw_list = projectSnap.data;
          return ListView.builder(
              itemCount: raw_list.length,
              itemBuilder: (context, index) {
                final item = raw_list[index];
                return ListTile(
                  title: Text(item.title),
                );
              }
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
      future: this.getXML(),
    );


  }

  Future<List> getXML() async {
    var jre = "http://www.joeroganexp.joerogan.libsynpro.com/rss";
    Response uriResponse = await get(jre);
    var xmlString = uriResponse.body;

    var rssFeed = RssFeed.parse(xmlString); // for parsing RSS feed
    // var atomFeed = AtomFeed.parse(xmlString); // for parsing Atom feed
    return rssFeed.items;
  }

}
