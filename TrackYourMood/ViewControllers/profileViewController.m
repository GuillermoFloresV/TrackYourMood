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
#import "ProfilePost.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
@import Firebase;
@import FirebaseFirestore;
@interface profileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) NSMutableArray *optionsArray;
@property (strong, nonatomic) NSMutableArray *postsArray;
@property (weak, nonatomic) IBOutlet UILabel *profileUserLabel;
@property (strong, nonatomic) NSMutableArray *privatePosts;
@property (strong, nonatomic) NSString *currEmail;
@end
@implementation profileViewController

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.postsArray = [[NSMutableArray alloc] init];
    self.privatePosts = [[NSMutableArray alloc] init];
    self.postTableView.delegate = self;
    self.postTableView.dataSource = self;
    self.postTableView.rowHeight = 125;
    
    FIRUser *user = [FIRAuth auth].currentUser;
    self.currEmail = user.email;
    self.profileUserLabel.text = self.currEmail;
    
    //grabs the specific user's public posts
    FIRFirestore *db = [FIRFirestore firestore];
    [[db collectionWithPath:@"posts"]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
          } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                //adds the post data into an array
                NSString *currUser = document.data[@"username"];
                if([currUser isEqualToString:self.currEmail] ){
                    //if the user matches the curr user then it gets added to the array for showing
                    [self.postsArray addObject:document.data];
                    NSLog(@"Added to the profile array!");
                }
            }
          }
                    [self.postTableView reloadData];
        }];
    //grabs users private posts
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Post"];
    self.privatePosts = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    [self.postTableView reloadData];
    
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

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)postTableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ProfilePost *cell = [postTableView dequeueReusableCellWithIdentifier:(@"ProfilePostCell")];
//    NSDictionary *postData = self.postsArray[indexPath.row];
    
//    cell.profilePost.text = postData[@"message"];
//    cell.profileUsername.text = postData[@"username"];
//    NSLog(@"Document Data: %@", postData.description);
//
    NSManagedObject *privatePost = [self.privatePosts objectAtIndex:indexPath.row];
    if([[privatePost valueForKey:@"user" ] isEqualToString:self.currEmail])
    {
        [cell.profileUsername setText:[privatePost valueForKey:@"user"]];
        [cell.profilePost setText:[privatePost valueForKey:@"message"]];
    }
    return cell;

}



- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.privatePosts.count + self.postsArray.count;
}

@end
