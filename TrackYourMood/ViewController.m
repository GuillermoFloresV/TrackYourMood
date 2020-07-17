//
//  ViewController.m
//  TrackYourMood
//
//  Created by gfloresv on 7/13/20.
//  Copyright © 2020 gfloresv. All rights reserved.
//

#import "ViewController.h"
#import "SceneDelegate.h"
#import "homeViewController.h"
@import Firebase;
@import FirebaseAuth;
@import GoogleSignIn;
@interface ViewController ()
@property (weak, nonatomic) IBOutlet GIDSignInButton *signInButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      [GIDSignIn sharedInstance].presentingViewController = self;
    
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].delegate = self;
    
}
- (IBAction)onTapScreen:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)loginAction:(id)sender {
    NSString *email = self.emailField.text;
    NSString *password = self.passwordField.text;
    if(email.length==0 || password.length==0){
        // Do any additional setup after loading the view.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:[NSString stringWithFormat:@"Email/Password cannot be left empty"]
        preferredStyle:(UIAlertControllerStyleAlert)];
        // create an OK action
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                         }];
        // add the OK action to the alert controller
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{
            // optional code for what happens after the alert controller has finished presenting
            self.emailField.text = @"";
            self.passwordField.text = @"";
        }];
    }
    else{
        [[FIRAuth auth] signInWithEmail:email
                               password:password
                             completion:^(FIRAuthDataResult * _Nullable authResult,
                                          NSError * _Nullable error) {
          if(error != nil){
              [self performSegueWithIdentifier:@"goHomeNav" sender:nil];
          }
          else{
              // Do any additional setup after loading the view.
              UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                             message:[NSString stringWithFormat:@"Unable to sign in, please try again"]
              preferredStyle:(UIAlertControllerStyleAlert)];
              // create an OK action
              UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                       // handle response here.
                                                               }];
              // add the OK action to the alert controller
              [alert addAction:okAction];
              [self presentViewController:alert animated:YES completion:^{
                  // optional code for what happens after the alert controller has finished presenting
                  self.emailField.text = @"";
                  self.passwordField.text = @"";
              }];
          }
        }];
    }

}


-(void)signIn:(GIDSignIn *) signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error{
    if(error == nil){
        GIDAuthentication *authentication = user.authentication;
        FIRAuthCredential *credential = [FIRGoogleAuthProvider credentialWithIDToken:authentication.idToken accessToken:authentication.accessToken];
        
        [[FIRAuth auth] signInWithCredential:credential completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
            if(user){
                // Do any additional setup after loading the view.
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Firebase"
                                                                               message:[NSString stringWithFormat:@"Welcome to TrackYourMood, %@", user.profile.name]
                preferredStyle:(UIAlertControllerStyleAlert)];
                // create an OK action
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * _Nonnull action) {
                                                                         // handle response here.
                                                                 }];
                // add the OK action to the alert controller
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:^{
                    // optional code for what happens after the alert controller has finished presenting
                    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    homeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
                    sceneDelegate.window.rootViewController = homeViewController;
                }];
            }
        }];
        
    }
}
//


@end
