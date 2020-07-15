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
@property (strong, nonatomic) FIRDatabaseReference *ref;
@end

@implementation signUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ref = [[FIRDatabase database] reference];

}
- (IBAction)signUpWithEmailAndPassword:(id)sender {
    //grabs the text from the text fields
    NSString *email= self.emailTextField.text;
    NSString *password = self.passwordTextField.text;
    [[FIRAuth auth] createUserWithEmail:email password:password completion:^(FIRAuthDataResult * _Nullable authResult, NSError * _Nullable error) {
        if(error!=nil){
            //signs the user in with the newly created account
            if(email.length==0 || password.length==0){
                [[[self.ref child:@"users"] child:authResult.user.uid]
                setValue:@{@"email": email}];
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
                    self.emailTextField.text = @"";
                    self.passwordTextField.text = @"";
                }];
            }
            else{
                [[FIRAuth auth] signInWithEmail:email
                                       password:password
                                     completion:^(FIRAuthDataResult * _Nullable authResult,
                                                  NSError * _Nullable error) {
                  if(error != nil){
                      SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
                      UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                      homeViewController *homeViewController = [storyboard instantiateViewControllerWithIdentifier:@"homeViewController"];
                      sceneDelegate.window.rootViewController = homeViewController;
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
                          self.emailTextField.text = @"";
                          self.passwordTextField.text = @"";
                      }];
                  }
                }];
            }
        }
        else{
            // Do any additional setup after loading the view.
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:[NSString stringWithFormat:@"Unable to sign up, please try again"]
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
                self.emailTextField.text = @"";
                self.passwordTextField.text = @"";
            }];
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
