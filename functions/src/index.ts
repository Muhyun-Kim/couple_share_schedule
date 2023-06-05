import * as admin from "firebase-admin";

admin.initializeApp();

import { deleteUserData } from "./firebase/deleteCollection";

export { deleteUserData };
