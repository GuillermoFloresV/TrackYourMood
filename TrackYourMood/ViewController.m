//
//  ViewController.m
//  TrackYourMood
//
//  Created by gfloresv on 7/13/20.
//  Copyright © 2020 gfloresv. All rights reserved.
//

#import "ViewController.h"
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
    [FIRApp configure];
      [GIDSignIn sharedInstance].presentingViewController = self;
    
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].delegate = self;
    
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
                }];
            }
        }];
        
    }
}

@end
