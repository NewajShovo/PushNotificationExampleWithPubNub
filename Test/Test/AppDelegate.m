//
//  AppDelegate.m
//  Test
//
//  Created by Shovo on 18/5/22.
//

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>
#import <PubNub/PubNub.h>
#import "ViewController.h"

@interface AppDelegate () <UNUserNotificationCenterDelegate, PNEventsListener,viewControllerPublishMessageDelegate>
@property(nonatomic, strong) PubNub *client;
@property(nonatomic, strong) PNConfiguration *myConfig;
@property(nonatomic, strong) NSString *subKey;
@property(nonatomic, strong) NSString *pubKey;
@property(nonatomic, strong) NSString *channelName;
@property(nonatomic, strong) ViewController *viewControllerObject;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _viewControllerObject.viewControllerdelgate = self;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate                  = self;
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge)
                          completionHandler:^(BOOL granted, NSError *_Nullable error) {
                              if (!error) {
                                  // required to get the app to do anything at all about push notifications
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [[UIApplication sharedApplication] registerForRemoteNotifications];
                                  });
                                  NSLog(@"Push registration success.");
                              } else {
                                  NSLog(@"Push registration FAILED");
                                  NSLog(@"ERROR: %@ - %@", error.localizedFailureReason, error.localizedDescription);
                                  NSLog(@"SUGGESTIONS: %@ - %@", error.localizedRecoveryOptions, error.localizedRecoverySuggestion);
                              }
                          }];
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    self.pubKey = @"dummy_publish_key";
    self.subKey = @"dummy_subcription_key";
    self.myConfig = [PNConfiguration configurationWithPublishKey:self.pubKey subscribeKey:self.subKey];
    self.client = [PubNub clientWithConfiguration:self.myConfig];
    self.channelName = @"TestChannel";
    self.client.logger.enabled = YES;
    self.client.logger.writeToFile = YES;
    self.client.logger.maximumLogFileSize = (10 * 1024 * 1024);
    self.client.logger.maximumNumberOfLogFiles = 10;
    [self.client.logger setLogLevel:PNVerboseLogLevel];
    [self.client subscribeToChannels:@[_channelName] withPresence:YES];
//    [self.client isSubscribedOn:_channelName];

    NSLog(@"%d",[self.client isSubscribedOn:_channelName]);
    
    
//    [self.client removePushNotificationsFromChannels:@[_channelName] withDevicePushToken:deviceToken andCompletion:^(PNAcknowledgmentStatus * _Nonnull status) {
//        NSLog(@"Output: %d",status.isError);
//    }];
//
    
//    [self.client addPushNotificationsOnChannels:@[_channelName] withDevicePushToken:deviceToken andCompletion:^(PNAcknowledgmentStatus * _Nonnull status) {
//        NSLog(@"Output: %d",status.isError);
//    }];
    
    
    
    [self.client addPushNotificationsOnChannels:@[_channelName]  withDevicePushToken:deviceToken pushType:PNAPNS2Push andCompletion:^(PNAcknowledgmentStatus * _Nonnull status) {
        NSLog(@"Output: %d",status.isError);
    }];

    [self.client addListener:self];
}

#pragma mark - Streaming Data didReceiveMessage Listener

- (void)client:(PubNub *)client didReceiveMessage:(PNMessageResult *)message {
    
    if (![message.data.channel isEqualToString:message.data.subscription]) {
        
        // Message has been received on channel group stored in message.data.subscription.
    }
    else {
        
        // Message has been received on channel stored in message.data.channel.
    }
    
    if (message) {
        NSDictionary *dictionary = message.data.message;
        if(![dictionary isKindOfClass:[NSString class]]){
            NSDictionary *dictionary = message.data.message;
            dictionary = dictionary[@"pn_apns"][@"aps"][@"alert"];
            
            
            [self.appdelegate  changeTextofTestPayLoad:dictionary[@"body"]];
            NSLog(@"Received message from '%@': %@ on channel %@ at %@", message.data.publisher,
                  message.data.message, message.data.channel, message.data.timetoken);
        }
        
    }
}

#pragma mark - Streaming Data didReceivePresenceEvent Listener

- (void)client:(PubNub *)client didReceivePresenceEvent:(PNPresenceEventResult *)event {
    
    if (![event.data.channel isEqualToString:event.data.subscription]) {
        
        // Presence event has been received on channel group stored in event.data.subscription.
    }
    else {
        
        // Presence event has been received on channel stored in event.data.channel.
    }
    
    if (![event.data.presenceEvent isEqualToString:@"state-change"]) {
        
        NSLog(@"%@ \"%@'ed\"\nat: %@ on %@ (Occupancy: %@)", event.data.presence.uuid,
              event.data.presenceEvent, event.data.presence.timetoken, event.data.channel,
              event.data.presence.occupancy);
    }
    else {
        
        NSLog(@"%@ changed state at: %@ on %@ to: %@", event.data.presence.uuid,
              event.data.presence.timetoken, event.data.channel, event.data.presence.state);
    }
}

#pragma mark - Streaming Data didReceiveStatus Listener

- (void)client:(PubNub *)client didReceiveStatus:(PNStatus *)status {
    
    // This is where we'll find ongoing status events from our subscribe loop
    // Results (messages) from our subscribe loop will be found in didReceiveMessage
    // Results (presence events) from our subscribe loop will be found in didReceiveStatus
    NSLog(@"Did ReceiveStatus");

}

-(void) publishMessage:(NSString *) message{
    [self.client publish:message toChannel:_channelName
          withCompletion:^(PNPublishStatus *status) {
        NSLog(@"%@",status);
    }];
}



@end
