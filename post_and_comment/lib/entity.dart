import 'package:floor/floor.dart';

@Entity(tableName: 'posts')
class Post {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title;

  Post({this.id, required this.title});

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'] as int,
      title: map['title'] as String,
    );
  }
}

@Entity(tableName: 'comments')
class Comment {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String text;

  @ColumnInfo(name: 'postId')
  final int postId;

  Comment({this.id, required this.text, required this.postId});

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'] as int,
      text: map['text'] as String,
      postId: map['postId'] as int,
    );
  }
}