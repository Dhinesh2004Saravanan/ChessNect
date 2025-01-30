import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var likeCount = 0.obs;
  var dislikeCount = 0.obs;
  var isLiked = false.obs;
  var isDisliked = false.obs;

  void fetchPostData(String postId, String userId) async {
    DocumentSnapshot postSnapshot =
    await _firestore.collection('NEWSFEED').doc(postId).get();

    if (postSnapshot.exists) {
      final data = postSnapshot.data() as Map<String, dynamic>;
      final likes = (data['likes'] as List<dynamic>?) ?? [];
      final dislikes = (data['dislikes'] as List<dynamic>?) ?? [];

      likeCount.value = likes.length;
      dislikeCount.value = dislikes.length;
      isLiked.value = likes.contains(userId);
      isDisliked.value = dislikes.contains(userId);
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    final postRef = _firestore.collection('posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);
      final data = snapshot.data() as Map<String, dynamic>;

      List<dynamic> likes = (data['likes'] as List<dynamic>?) ?? [];
      if (likes.contains(userId)) {
        likes.remove(userId);
        isLiked.value = false;
      } else {
        likes.add(userId);
        isLiked.value = true;

        // Ensure the user isn't both liking and disliking.
        List<dynamic> dislikes = (data['dislikes'] as List<dynamic>?) ?? [];
        if (dislikes.contains(userId)) {
          dislikes.remove(userId);
          transaction.update(postRef, {'dislikes': dislikes});
          isDisliked.value = false;
        }
      }

      transaction.update(postRef, {'likes': likes});
      likeCount.value = likes.length;
    });
  }

  Future<void> toggleDislike(String postId, String userId) async {
    final postRef = _firestore.collection('posts').doc(postId);

    await _firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(postRef);
      final data = snapshot.data() as Map<String, dynamic>;

      List<dynamic> dislikes = (data['dislikes'] as List<dynamic>?) ?? [];
      if (dislikes.contains(userId)) {
        dislikes.remove(userId);
        isDisliked.value = false;
      } else {
        dislikes.add(userId);
        isDisliked.value = true;

        // Ensure the user isn't both liking and disliking.
        List<dynamic> likes = (data['likes'] as List<dynamic>?) ?? [];
        if (likes.contains(userId)) {
          likes.remove(userId);
          transaction.update(postRef, {'likes': likes});
          isLiked.value = false;
        }
      }

      transaction.update(postRef, {'dislikes': dislikes});
      dislikeCount.value = dislikes.length;
    });
  }
}
