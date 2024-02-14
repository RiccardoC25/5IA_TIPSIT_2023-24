import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'entity_dao.dart';
import 'entity.dart';

part 'database.g.dart';


@Database(version: 1, entities: [Post, Comment])
abstract class AppDatabase extends FloorDatabase {
  PostDao get postDao;
  CommentDao get commentDao;
}
