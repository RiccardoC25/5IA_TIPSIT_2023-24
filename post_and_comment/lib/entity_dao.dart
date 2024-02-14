import 'package:floor/floor.dart';
import 'package:post_and_comment/entity.dart';

@dao
abstract class PostDao {
  @Query('SELECT * FROM posts')
  Future<List<Post>> findAllPosts();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPost(Post post);

  @Query('DELETE FROM posts WHERE id = :id')
  Future<void> deletePost(int id);
}

@dao
abstract class CommentDao {
  @Query('SELECT * FROM comments WHERE postId = :postId')
  Future<List<Comment>> findCommentsForPost(int postId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertComment(Comment comment);

  @Query('DELETE FROM comments WHERE id = :id')
  Future<void> deleteComment(int id);
}