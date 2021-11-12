import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';
import '../functions/api.dart';
import '../functions/copyFileToLibrary.dart';

import '../config.dart' as config;

import '../widgets/slideLeftBackground.widget.dart';

class ImagesList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ImagesListState();
  }
}

class _ImagesListState extends State<ImagesList> {
  List<dynamic> _images = [];
  Api api = new Api(config.apiKey);

  void fetchImages() async {
    var images = await api.fetchImages();
    setState(() {
      _images = images;
      if (_images.length == 0) {
        _images.add("empty");
      }
    });
  }

  void deleteImage(String image) {
    var result = api.deleteImage(image);

    if (result["success"] == true) {
      _getData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Bild konnte nicht gelöscht werden.")));
    }
  }

  int _id(dynamic image) {
    return image['id'];
  }

  String _date(dynamic image) {
    List<String> dateList = image['date'].split("T");
    dateList = dateList[0].split("-");
    return dateList[2] + "." + dateList[1] + "." + dateList[0];
  }

  String _imageURI(Map<dynamic, dynamic> image) {
    return "https://api.flowei.tech/sammy/pictures/" +
        image['id'].toString() +
        "/decoded?token=" +
        config.apiKey;
  }

  Future<String> _findPath(String imageUrl) async {
    final file = await DefaultCacheManager().getSingleFile(imageUrl);
    return file.path;
  }

  void shareImage(path) {
    Share.shareFiles([path.toString()], text: 'Aufgenommen mit SamCam!');
  }

  Widget checkIfEmpty() {
    return _images[0] == "empty"
        ? RefreshIndicator(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Noch keine Einträge vorhanden"),
                  MaterialButton(
                    onPressed: _getData,
                    child: Text("Aktualisieren"),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
            onRefresh: _getData)
        : ListView.builder(
            padding: EdgeInsets.all(8),
            itemCount: _images.length,
            itemBuilder: (BuildContext context, int index) {
              return Dismissible(
                key: Key(_id(_images[index]).toString()),
                onDismissed: (d) {
                  deleteImage(_id(_images[index]).toString());
                },
                background: slideLeftBackground(),
                direction: DismissDirection.endToStart,
                child: Container(
                  height: 285,
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15)),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: new Icon(Icons.calendar_today),
                                      title: new Text(_date(_images[index]),
                                          style: TextStyle(
                                              color: Colors.grey[800])),
                                    ),
                                    Divider(color: Colors.grey),
                                    ListTile(
                                      leading: new Icon(Icons.file_download),
                                      title: new Text('Download'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _findPath(_imageURI(_images[index]))
                                            .then((path) {
                                          copyFileToLibrary(path, context);
                                        });
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.share),
                                      title: new Text('Teilen'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        _findPath(_imageURI(_images[index]))
                                            .then((path) {
                                          shareImage(path);
                                        });
                                      },
                                    ),
                                    ListTile(
                                      leading: new Icon(Icons.delete),
                                      title: new Text('Löschen'),
                                      onTap: () {
                                        deleteImage(
                                            _id(_images[index]).toString());
                                        Navigator.pop(context);
                                        _getData();
                                      },
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: CachedNetworkImage(
                                imageUrl: _imageURI(_images[index]),
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )),
                        ],
                      )),
                ),
              );
            });
  }

  Widget _buildList() {
    return _images.length != 0
        ? RefreshIndicator(
            child: checkIfEmpty(),
            onRefresh: _getData,
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Future<void> _getData() async {
    setState(() {
      fetchImages();
    });
  }

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Fotos')),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Theme.of(context).primaryColor,
                    Theme.of(context).accentColor
                  ])),
        ),
      ),
      body: Container(
        child: _buildList(),
      ),
    );
  }
}
