//
//  profileViewController.m
//  TrackYourMood
//
//  Created by gfloresv on 7/20/20.
//  Copyright © 2020 gfloresv. All rights reserved.
//

#import "profileViewController.h"
#import "SceneDelegate.h"
#import "ViewController.h"
@import Firebase;
@interface profileViewController ()
@property (strong, nonatomic) NSMutableArray *optionsArray;
@end

@implementation profileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.optionsArray addObject:@"Logout"];
}
- (IBAction)logoutAction:(id)sender {
    [[FIRAuth auth] signOut:(nil)];
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
      ViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
      sceneDelegate.window.rootViewController = loginViewController;
}

//creating a popover menu for iPhone:
//https://stackoverflow.com/questions/25319179/uipopoverpresentationcontroller-on-ios-8-iphone/25656733#25656733
-(void) prepareForSegue:(UIStoryboardSegue *) segue sender:(id) sender
{
    if ([segue.identifier isEqualToString:@"PopoverSegue"]) {
        UIViewController *controller = segue.destinationViewController;
        controller.popoverPresentationController.delegate = self;
        controller.preferredContentSize = CGSizeMake(320, 186);
    }
}

// MARK: UIPopoverPresentationControllerDelegate

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    // Return no adaptive presentation style, use default presentation behaviour
    return UIModalPresentationNone;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
