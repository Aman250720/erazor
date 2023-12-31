const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.notifySalon = functions.runWith(
  {
    enforceAppCheck: true
  }
).region('asia-south1').https.onCall(async (data, context) => {
    const message = {
        notification: {
          title: 'Oh, no! Booking cancelled! 🥺🥺',
          body: data.customer + ' has cancelled their booking of ' + data.date + ' at ' + data.time + '!',
        },
        token: data.token,
      };

      try {
        const response = await admin.messaging().send(message);
        console.log('Notification sent:', response);
        return response;
      } catch (error) {
        console.error('Error sending notification:', error);
      }

});

exports.bookSlots = functions.runWith(
  {
    enforceAppCheck: true
  }
).region('asia-south1').https.onCall(async (data, context) => {
    const message = {
        notification: {
          title: 'Oh, yes! New booking received! 🤩🤩',
          body: data.customer + ' has booked slots for ' + data.date + ' at ' + data.time + '!',
        },
        token: data.token,
      };

      try {
        const response = await admin.messaging().send(message);
        console.log('Notification sent:', response);
        return response;
      } catch (error) {
        console.error('Error sending notification:', error);
      }

});




