# PushNotificationExampleWithPubNub
This repo is created to help people to get accustomed to the push notification issue with pubnub

# Findings related configuring pubnub into an iOS application

1. First built an application with a new identifier, while creating new identifier add push notification service available for it.
2. Add push capabilities in the xcode as well. Now at this point, subscribing to a particular channel you would be able to recieve the payload(message) in the pubnub debug console and also can receive payload(message) from pubnub debug console as well. (No certificate needed)
3. Then identifier which we will be using, we will have to add the apple push service(development & production) for that identifier, configure certificate in the keychain and also have to configure pubnub with the  Apple Push Notifications service (APNs) key.


  
# Test_Payload Example
```
{
	"pn_apns": {
		"aps": {
			"alert": {
				"body": "Hello Newaj"
			},
			"badge": 1
		},
		"pn_push": [
			{
				"push_type": "alert",
				"targets": [
					{
						"environment": "development",
						"topic": "com.testNotification.push.Notification"
					}
				],
				"version": "v2"
			}
		]
	}
}
```
# Point to be noted for Test Payload format

1. I have followed exactly this format and got succeeded receiving push notification.
2. Environment has to mentioned accordingly (Production should be used when necessary), topic should match the bundel identifier of the application, and version should be v2 (if pubnub is configured with the new apns2 key)


