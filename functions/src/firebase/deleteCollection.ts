import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

export const deleteUserData = functions.auth.user().onDelete(async (user) => {
  const db = admin.firestore();
  const uid = user.uid;
  const collectionRef = db.collection(uid);

  return collectionRef
    .get()
    .then((snapshot) => {
      const batch = db.batch();
      snapshot.forEach((doc) => {
        batch.delete(doc.ref);
      });
      return batch.commit();
    })
    .catch((error) => {
      console.error("Error deleting collection: ", error);
    });
});
