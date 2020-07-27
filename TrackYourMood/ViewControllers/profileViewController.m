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
#import "PostCell.h"
@import Firebase;
@import FirebaseFirestore;
@interface profileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *postsTableView;
@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (strong, nonatomic) NSMutableArray *postsArray;
@end
@implementation profileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.postsArray = [[NSMutableArray alloc] init];
    [self.optionsArray addObject:@"Logout"];
    self.postsTableView.delegate = self;
    self.postsTableView.dataSource = self;
    self.postsTableView.rowHeight = 125;
    
    FIRUser *user = [FIRAuth auth].currentUser;
    NSString *currEmail = user.email;
    
    //grabs the specific user's posts
    FIRFirestore *db = [FIRFirestore firestore];
    [[db collectionWithPath:@"posts"]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
          } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                //adds the post data into an array
                NSString *currUser = document.data[@"username"];
                if([currUser isEqualToString:currEmail] ){
                    //if the user matches the curr user then it gets added to the array for showing
                    [self.postsArray addObject:document.data];
                }
            }
          }
                    [self.postsTableView reloadData];
        }];
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    PostCell *cell = [self.postsTableView dequeueReusableCellWithIdentifier:(@"PostCell")];
    NSDictionary *postData = self.postsArray[indexPath.row];
    
    cell.postLabel.text = postData[@"message"];
    cell.usernameLabel.text = postData[@"username"];

    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.postsArray.count;
}

@end
