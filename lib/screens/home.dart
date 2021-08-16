import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:movieish/backend/authentication.dart';
import 'package:movieish/backend/database.dart';
import 'package:movieish/common/constant/size_constants.dart';
import 'package:movieish/common/extensions/size_extensions.dart';
import 'package:movieish/screens/login/login_swithcer.dart';
import 'package:movieish/screens/movieInfo.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController movieNameTEC = new TextEditingController();
  TextEditingController directorTEC = new TextEditingController();
  File _image;
  String imgStr = "";
  MovieDatabase _movieDatabase = MovieDatabase();
  AuthenticationMethods authenticationMethods = new AuthenticationMethods();
  Future<List<MovieInfo>> _movie;

  @override
  void initState() {
    _movieDatabase.initializeDatabase().then((value) {
      print("------database initialised------");
    });
    loadMovies();
    super.initState();
  }

  void loadMovies() {
    _movie = _movieDatabase.getMovies();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movieish"),
        actions: [
          GestureDetector(
            onTap: () {
              authenticationMethods.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginSwitcher()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: Container(child: movieList()),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        child: Icon(Icons.add),
        onPressed: () {
          openAddMoviePopUp(context);
        },
      ),
    );
  }

  openAddMoviePopUp(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Add Movie'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                        controller: movieNameTEC,
                        validator: (input) {
                          return input.isEmpty
                              ? "Please Enter a movie name"
                              : null;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "Movie name",
                          labelStyle: new TextStyle(
                            color: Colors.black,
                          ),
                          enabledBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: directorTEC,
                        validator: (input) {
                          return input.isEmpty
                              ? "Please Enter director name"
                              : null;
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "Director name",
                          labelStyle: new TextStyle(
                            color: Colors.black,
                          ),
                          enabledBorder: new OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.black)),
                          focusedBorder: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text("Upload poster"),
                        IconButton(
                          icon: Icon(Icons.file_upload),
                          onPressed: () {
                            pickerOptions(context);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            actions: [
              RaisedButton(
                  child: Text("Add"),
                  onPressed: () {
                    onSaveMovie();
                  })
            ],
          );
        });
  }

  onSaveMovie() {
    if (formKey.currentState.validate()) {
      List<int> bytes = _image.readAsBytesSync();
      imgStr = base64Encode(bytes);

      var movieInfo = MovieInfo(
          movieName: movieNameTEC.text,
          directorName: directorTEC.text,
          photo: imgStr);

      _movieDatabase.insertMovie(movieInfo);
      movieNameTEC.clear();
      directorTEC.clear();
      Navigator.pop(context);
      loadMovies();
    }
  }

  Future _imgFromCamera() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  Future _imgFromGallery() async {
    // ignore: deprecated_member_use
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  pickerOptions(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget movieList() {
    return FutureBuilder<List<MovieInfo>>(
      future: _movie,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView(
              children: snapshot.data.map<Widget>((movies) {
            return Container(
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, right: 15.0, top: 15),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [
                            const Color(0xFF9FA4C4),
                            const Color(0xFFB3CDD1)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20)),
                            child: Image.memory(base64Decode(movies.photo))
                        ),
                        Text(
                          "Movie: " + movies.movieName,
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        Divider(
                          height: 0,
                          color: Colors.black,
                        ),
                        Text(
                          "Director: " + movies.directorName,
                          style: TextStyle(
                              color: Colors.black,
                            fontSize: 20
                          ),
                        ),
                        Divider(
                          height: 0,
                          color: Colors.black,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.mode_edit,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          scrollable: true,
                                          title: Text('Update Movie'),
                                          content: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Form(
                                              key: formKey,
                                              child: Column(
                                                children: <Widget>[
                                                  TextFormField(
                                                      controller: movieNameTEC,
                                                      validator: (input) {
                                                        return input.isEmpty
                                                            ? "Please Enter a movie name"
                                                            : null;
                                                      },
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: "Movie name",
                                                        labelStyle:
                                                            new TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                        enabledBorder:
                                                            new OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                        focusedBorder:
                                                            new OutlineInputBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  8.0),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextFormField(
                                                      controller: directorTEC,
                                                      validator: (input) {
                                                        return input.isEmpty
                                                            ? "Please Enter director name"
                                                            : null;
                                                      },
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                      decoration:
                                                          InputDecoration(
                                                        labelText:
                                                            "Director name",
                                                        labelStyle:
                                                            new TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                        enabledBorder:
                                                            new OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8.0),
                                                                borderSide: BorderSide(
                                                                    color: Colors
                                                                        .black)),
                                                        focusedBorder:
                                                            new OutlineInputBorder(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  8.0),
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                      )),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Upload poster"),
                                                      IconButton(
                                                        icon: Icon(
                                                            Icons.file_upload),
                                                        onPressed: () {
                                                          pickerOptions(
                                                              context);
                                                        },
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          actions: [
                                            RaisedButton(
                                                child: Text("Update"),
                                                onPressed: () {
                                                  editMovie(movies.id);
                                                })
                                          ],
                                        );
                                      });
                                },
                              ),
                              VerticalDivider(
                                color: Colors.black,
                                width: 10,
                                indent: 5,
                                endIndent: 5,
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  deleteMovie(movies.id);
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList());
        }
        return Center(
          child: Text(
            "Press below + icon to add movies",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      },
    );
  }

  void editMovie(int id) {
    if (formKey.currentState.validate()) {
      List<int> bytes = _image.readAsBytesSync();
      imgStr = base64Encode(bytes);

      var updatedMovie = MovieInfo(
          id: id,
          movieName: movieNameTEC.text,
          directorName: directorTEC.text,
          photo: imgStr);

      _movieDatabase.updateMovie(updatedMovie, id);
      movieNameTEC.clear();
      directorTEC.clear();
      Navigator.pop(context);
      loadMovies();
    }
  }

  void deleteMovie(int id) {
    _movieDatabase.delete(id);
    loadMovies();
  }
}
