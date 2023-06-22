import * as functions from "firebase-functions";

/**
 * firebaseのデータベースを監視する
 * 自分のUIDが追加されたら、追加した人のUIDを取得する
 * 追加した人のUIDを取得したら、それをfirestoreのmyUid/partnerに追加する
 */
export const addPartner = functions.firestore
  .document(`collection/{docId}`)
  .onCreate((snapshot, context) => {
    const newData = snapshot.data();
    console.log("Added data:", newData);
    return newData;
  });
