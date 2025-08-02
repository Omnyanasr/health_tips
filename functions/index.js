// TO-DO get it to work by supscribing to Blaze plan in Firebase to use FCM
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendHealthTipsOnDemand = functions.https.onRequest(async (req, res) => {
  try {
    // Assume userId passed as a query parameter: ?uid=user123
    const uid = req.query.uid;
    if (!uid) {
      return res.status(400).send("Missing uid");
    }

    // Fetch user from Firestore
    const userDoc = await admin.firestore().collection("Users").doc(uid).get();
    if (!userDoc.exists) {
      return res.status(404).send("User not found");
    }

    const user = userDoc.data();

    let tip = "";
    if (user.fitnessGoal === "Weight Loss") {
      tip = "Drink a glass of water before meals to help weight loss.";
    } else if (user.fitnessGoal === "Muscle Gain") {
      tip = "Add extra protein to your breakfast today.";
    } else {
      tip = "Take a 10-minute walk to refresh yourself.";
    }

    if (!user.fcmToken) {
      return res.status(400).send("User has no FCM token");
    }

    // Send notification
    await admin.messaging().send({
      token: user.fcmToken,
      notification: {
        title: "Daily Health Tip",
        body: tip,
      },
    });

    return res.status(200).send("Notification sent");
  } catch (error) {
    console.error("Error sending notification:", error);
    return res.status(500).send("Internal Server Error");
  }
});
