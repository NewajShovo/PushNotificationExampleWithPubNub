//
//  AppDelegate.h
//  Test
//
//  Created by Shovo on 18/5/22.
//

#import <UIKit/UIKit.h>


@protocol AppDelegateDelegate <NSObject>
-(void) changeTextofTestPayLoad:(NSString *) message;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic, assign) id<AppDelegateDelegate> appdelegate;
-(void) publishMessage:(NSString *) message;
@end

