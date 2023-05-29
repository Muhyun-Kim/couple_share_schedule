import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

export const deleteUserData = functions.auth.user().onDelete(async (user) => {
  const uid = user.uid;

  try {
    const collectionsPath = "users";
    await admin.firestore().collection(collectionsPath).doc(uid).delete();
    console.log("User data deleted");
  } catch (error) {
    console.log(error);
  }
});
