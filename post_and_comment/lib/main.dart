import 'package:flutter/material.dart';
import 'package:floor/floor.dart';
import 'dart:async';

// Importiamo le entità e i dao
import 'entity.dart';
import 'entity_dao.dart';
import 'database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inizializziamo il database
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  MyApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(database: database),
    );
  }
}

class HomePage extends StatefulWidget {
  final AppDatabase database;

  HomePage({required this.database});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController postTitleController = TextEditingController();
  TextEditingController commentTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: FutureBuilder<List<Post>>(
        future: widget.database.postDao.findAllPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(post.title),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await widget.database.postDao.deletePost(post.id!);
                          setState(() {});
                        },
                      ),
                    ),
                    // Visualizziamo i commenti di ogni post
                    FutureBuilder<List<Comment>>(
                      future: widget.database.commentDao.findCommentsForPost(post.id!),
                      builder: (context, commentSnapshot) {
                        if (commentSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (commentSnapshot.hasData) {
                          final comments = commentSnapshot.data!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: comments.map((comment) => ListTile(
                              title: Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(comment.text),
                              ),
                              // Aggiungiamo un pulsante per eliminare il commento
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await widget.database.commentDao.deleteComment(comment.id!);
                                  setState(() {});
                                },
                              ),
                            )).toList(),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    // Pulsante per aggiungere un commento
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('New Comment'),
                                content: TextField(
                                  controller: commentTextController,
                                  decoration: InputDecoration(hintText: 'Enter your comment'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final newComment = Comment(text: commentTextController.text, postId: post.id!);
                                      await widget.database.commentDao.insertComment(newComment);
                                      setState(() {
                                        commentTextController.clear();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text('Add Comment'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text('Add Comment'),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                  ],
                );
              },
            );
          } else {
            return Center(
              child: Text('No posts found'),
            );
          }
        },
      ),
      // Pulsante per aggiungere un nuovo post
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('New Post'),
                content: TextField(
                  controller: postTitleController,
                  decoration: InputDecoration(hintText: 'Enter the title'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final newPost = Post(title: postTitleController.text);
                      await widget.database.postDao.insertPost(newPost);
                      setState(() {
                        postTitleController.clear();
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Add Post'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
