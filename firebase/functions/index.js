const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.onFollowUser = functions.firestore
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onCreate(async (_, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // Increment followed user's followers count.
    const followedUserRef = admin.firestore().collection("users").doc(userId);
    const followedUserDoc = await followedUserRef.get();
    if (followedUserDoc.get("followers") !== undefined) {
      followedUserRef.update({
        followers: followedUserDoc.get("followers") + 1,
      });
    } else {
      followedUserRef.update({ followers: 1 });
    }

    // Increment user's following count.
    const userRef = admin.firestore().collection("users").doc(followerId);
    const userDoc = await userRef.get();
    if (userDoc.get("following") !== undefined) {
      userRef.update({ following: userDoc.get("following") + 1 });
    } else {
      userRef.update({ following: 1 });
    }

    // Ajouter les posts de l'utilisateur suivi au flux de l'utilisateur suiveur
    const followedUserPostsRef = admin
      .firestore()
      .collection("posts")
      .where("author", "==", followedUserRef);
    const userFeedRef = admin
      .firestore()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed");
    const followedUserPostsSnapshot = await followedUserPostsRef.get();

    followedUserPostsSnapshot.forEach((doc) => {
      if (doc.exists) {
        const postRef = admin.firestore().doc(`posts/${doc.id}`); // Crée une référence au post

        const postData = {
          post_ref: postRef, // Référence au post dans la collection 'posts'
          date: doc.data().date, // Utilisation de la date du post original
          author_ref: admin.firestore().doc(`users/${userId}`), // Référence à l'auteur du post
        };

        userFeedRef.doc(doc.id).set(postData);
      }
    });
  });

exports.onUnfollowUser = functions.firestore
  .document("/followers/{userId}/userFollowers/{followerId}")
  .onDelete(async (_, context) => {
    const userId = context.params.userId;
    const followerId = context.params.followerId;

    // Decrement unfollowed user's followers count.
    const followedUserRef = admin.firestore().collection("users").doc(userId);
    const followedUserDoc = await followedUserRef.get();
    if (followedUserDoc.get("followers") !== undefined) {
      followedUserRef.update({
        followers: followedUserDoc.get("followers") - 1,
      });
    } else {
      followedUserRef.update({ followers: 0 });
    }

    // Decrement user's following count.
    const userRef = admin.firestore().collection("users").doc(followerId);
    const userDoc = await userRef.get();
    if (userDoc.get("following") !== undefined) {
      userRef.update({ following: userDoc.get("following") - 1 });
    } else {
      userRef.update({ following: 0 });
    }

    // Remove unfollowed user's posts from user's post feed.
    const userFeedRef = admin
      .firestore()
      .collection("feeds")
      .doc(followerId)
      .collection("userFeed")
      .where("author_ref", "==", followedUserRef);
    const userPostsSnapshot = await userFeedRef.get();
    userPostsSnapshot.forEach((doc) => {
      if (doc.exists) {
        doc.ref.delete();
      }
    });
  });

exports.onCreatePost = functions.firestore
  .document("/posts/{postId}")
  .onCreate(async (snapshot, context) => {
    const postId = context.params.postId;

    // Créer une référence au post
    const postRef = admin.firestore().doc(`posts/${postId}`);

    // Obtenir la date et la référence de l'auteur du post
    const postDate = snapshot.get("date");
    const authorRef = snapshot.get("author");

    // Obtenir l'auteur du post
    const authorId = authorRef.path.split("/")[1];

    // Ajouter le post aux feeds de tous les abonnés
    const userFollowersRef = admin
      .firestore()
      .collection("followers")
      .doc(authorId)
      .collection("userFollowers");
    const userFollowersSnapshot = await userFollowersRef.get();

    userFollowersSnapshot.forEach((doc) => {
      const feedEntry = {
        post_ref: postRef,
        date: postDate,
        author: authorRef, // Ajouter la référence de l'auteur
      };

      admin
        .firestore()
        .collection("feeds")
        .doc(doc.id)
        .collection("userFeed")
        .doc(postId)
        .set(feedEntry);
    });
  });

exports.onUpdatePost = functions.firestore
  .document("/posts/{postId}")
  .onUpdate(async (snapshot, context) => {
    const postId = context.params.postId;

    // Get author id.
    const authorRef = snapshot.after.get("author");
    const authorId = authorRef.path.split("/")[1];

    // Update post data in each follower's feed.
    const updatedPostData = snapshot.after.data();
    const userFollowersRef = admin
      .firestore()
      .collection("followers")
      .doc(authorId)
      .collection("userFollowers");
    const userFollowersSnapshot = await userFollowersRef.get();
    userFollowersSnapshot.forEach(async (doc) => {
      const postRef = admin
        .firestore()
        .collection("feeds")
        .doc(doc.id)
        .collection("userFeed");
      const postDoc = await postRef.doc(postId).get();
      if (postDoc.exists) {
        postDoc.ref.update(updatedPostData);
      }
    });
  });

exports.onCreateUser = functions.firestore
  .document("/users/{userId}")
  .onCreate(async (snap, context) => {
    // Récupérer les données du nouvel utilisateur
    const newUser = snap.data();

    // Vérifier si le champ 'username' existe
    if (newUser.username) {
      // Créer le champ 'username_lowercase'
      const usernameLowercase = newUser.username.toLowerCase();

      // Mettre à jour le document avec le nouveau champ
      return snap.ref.update({ username_lowercase: usernameLowercase });
    } else {
      console.log("Username not found for user: ", context.params.userId);
      return null;
    }
  });
