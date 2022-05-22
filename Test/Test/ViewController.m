//
//  ViewController.m
//  Test
//
//  Created by Shovo on 18/5/22.
//

#import "ViewController.h"
#import "AppDelegate.h"
@interface ViewController ()<AppDelegateDelegate>
@property (weak, nonatomic) IBOutlet UITextField *publishTextfield;
@property (weak, nonatomic) IBOutlet UITextField *receiveTextField;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    appdelegate.appdelegate = self;
}

- (IBAction)publishMessage:(id)sender {
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    [appdelegate publishMessage:self.publishTextfield.text];
}

-(void) changeTextofTestPayLoad:(NSString *)message{
    self.receiveTextField.text = message;
}


@end
