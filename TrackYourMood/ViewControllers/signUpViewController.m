//
//  signUpViewController.m
//  TrackYourMood
//
//  Created by gfloresv on 7/13/20.
//  Copyright © 2020 gfloresv. All rights reserved.
//

#import "signUpViewController.h"
#import "SceneDelegate.h"
#import "ViewController.h"
#import "homeViewController.h"
@import Firebase;
@interface signUpViewController ()

@end

@implementation signUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}
- (IBAction)signUpWithEmailAndPassword:(id)sender {
    NSString *email= self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if(error!=nil){
            SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            homeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
            sceneDelegate.window.rootViewController = homeViewController;
        }
        else{
            
        }
    }];
}
- (IBAction)onTapScreen:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)onTapSignIn:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    sceneDelegate.window.rootViewController = loginViewController;
    
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
