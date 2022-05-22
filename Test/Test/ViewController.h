//
//  ViewController.h
//  Test
//
//  Created by Shovo on 18/5/22.
//

#import <UIKit/UIKit.h>

@protocol viewControllerPublishMessageDelegate <NSObject>
-(void) publishMessage;
@end

@interface ViewController : UIViewController
@property (nonatomic, assign) id <viewControllerPublishMessageDelegate> viewControllerdelgate;
@end

