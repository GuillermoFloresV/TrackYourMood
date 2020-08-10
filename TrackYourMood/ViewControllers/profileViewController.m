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
@import FirebaseStorage;
@interface profileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *profileImage;
@property (weak, nonatomic) IBOutlet UITableView *postTableView;
@property (strong, nonatomic) NSMutableArray *combinedArray;
@property (strong, nonatomic) NSMutableArray *postsArray;
@property (weak, nonatomic) IBOutlet UILabel *profileUserLabel;
@property (strong, nonatomic) NSMutableArray *privatePosts;
@property (strong, nonatomic) NSMutableArray *convertedPosts;
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
    self.combinedArray = [[NSMutableArray alloc] init];
    self.convertedPosts = [[NSMutableArray alloc] init];
    self.postTableView.delegate = self;
    self.postTableView.dataSource = self;
    self.postTableView.rowHeight = 125;
    


    FIRUser *user = [FIRAuth auth].currentUser;
    self.currEmail = user.email;
    self.profileUserLabel.text = self.currEmail;
    // Get a reference to the storage service using the default Firebase App
    FIRStorage *storage = [FIRStorage storage];

    // Create a storage reference from our storage service
    FIRStorageReference *storageRef = [storage reference];
    NSLog(@"curruser: %@", self.currEmail);
    NSString *path = [@"profilepictures/" stringByAppendingString :self.currEmail];
    FIRStorageReference *currPFP = [storageRef child: path];
    if(currPFP ==nil)
    {
        NSLog(@"user does not have a custom pfp");
    }
    else{

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        [currPFP dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error){
          if (error != nil) {
            // Uh-oh, an error occurred!
              NSLog(@"error occured: %ld", (long)error.code);
          } else {
              NSLog(@"changing pfp");
            // Data for "images/curruser.jpg" is returned
            UIImage *pfp = [UIImage imageWithData:data];
            [self.profileImage setImage:pfp forState:UIControlStateNormal];
          }
        }];
    }
    //grabs the specific user's public posts
    FIRFirestore *db = [FIRFirestore firestore];
    [[db collectionWithPath:@"posts"]
     getDocumentsWithCompletion:^(FIRQuerySnapshot *snapshot, NSError *error) {
          if (error != nil) {
            NSLog(@"Error getting documents: %@", error);
          } else {
            for (FIRDocumentSnapshot *document in snapshot.documents) {
                //adds the post data into an array
                NSString *currUser = document.data[@"user"];
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
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Post" ];
    [fetchRequest setReturnsObjectsAsFaults:NO];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"user == %@",_currEmail]];

    NSLog(@"Entity name: %@", fetchRequest.entityName);
    self.privatePosts = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    
//    [self.postTableView reloadData];
    
    
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
    //this ensures that the private posts are the only ones that are converted

    NSDictionary *postData = self.combinedArray[indexPath.row];
    
    cell.profilePost.text = postData[@"message"];
    cell.profileUsername.text = postData[@"user"];
    NSLog(@"Document Data: %@", postData.description);
    
    // Get a reference to the storage service using the default Firebase App
    FIRStorage *storage = [FIRStorage storage];

    // Create a storage reference from our storage service
    FIRStorageReference *storageRef = [storage reference];

    NSString *path = [@"profilepictures/" stringByAppendingString :self.currEmail];
    FIRStorageReference *currPFP = [storageRef child: path];

    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
    [currPFP dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error){
      if (error != nil) {
        // Uh-oh, an error occurred!
          NSLog(@"error occured: %ld", (long)error.code);
          //here (if there is no pfp, then the user will not have a personalized image)
      } else {
          NSLog(@"changing pfp");
        // Data for "images/curruser.jpg" is returned
        UIImage *pfp = [UIImage imageWithData:data];
          [cell.profilePicture setImage:pfp ];
      }
    }];

    return cell;

}
- (IBAction)changePFP:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else {
        NSLog(@"Camera 🚫 available so we will use photo library instead");
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    //Or you can get the image url from AssetsLibrary
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);

    [picker dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"finish choosing image.");
    NSLog(@"image data: %@", imageData);
    // Create the file metadata
    FIRStorageMetadata *metadata = [[FIRStorageMetadata alloc] init];
    metadata.contentType = @"image/jpeg";

    // Get a reference to the storage service using the default Firebase App
    FIRStorage *storage = [FIRStorage storage];

    // Create a storage reference from our storage service
    FIRStorageReference *storageRef = [storage reference];

    NSString *fullFirebasePath = [@"profilepictures/" stringByAppendingString: self.currEmail];
    FIRStorageReference *pfp = [storageRef child:fullFirebasePath];
    // Upload file and metadata to the object 'images/mountains.jpg'
    FIRStorageUploadTask *uploadTask = [pfp putData:imageData metadata:metadata];


    // Listen for state changes, errors, and comp letion of the upload.
    [uploadTask observeStatus:FIRStorageTaskStatusResume handler:^(FIRStorageTaskSnapshot *snapshot) {
        NSLog(@"file upload resumed / started");
        // Upload resumed, also fires when the upload starts
    }];

    [uploadTask observeStatus:FIRStorageTaskStatusPause handler:^(FIRStorageTaskSnapshot *snapshot) {
        // Upload paused
        NSLog(@"file upload paused");
    }];

    [uploadTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot *snapshot) {
        // Upload reported progress
        double percentComplete = 100.0 * (snapshot.progress.completedUnitCount) / (snapshot.progress.totalUnitCount);
    }];

    [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot *snapshot) {
        // Upload completed successfully
        NSLog(@"upload completed successfully");
        //sets the current image to the one just uploaded
        // Create a reference to the file you want to download
        NSString *path = [@"profilepictures/" stringByAppendingString :self.currEmail];
        FIRStorageReference *currPFP = [storageRef child: path];

        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        [currPFP dataWithMaxSize:1 * 1024 * 1024 completion:^(NSData *data, NSError *error){
          if (error != nil) {
            // Uh-oh, an error occurred!
              NSLog(@"error occured: %ld", (long)error.code);
          } else {
              NSLog(@"changing pfp");
            // Data for "images/curruser.jpg" is returned
            UIImage *pfp = [UIImage imageWithData:data];
              [self.profileImage setImage:pfp forState:UIControlStateNormal];
          }
        }];
    }];

    // Errors only occur in the "Failure" case
    [uploadTask observeStatus:FIRStorageTaskStatusFailure handler:^(FIRStorageTaskSnapshot *snapshot) {
        if (snapshot.error != nil) {
            switch (snapshot.error.code) {
                case FIRStorageErrorCodeObjectNotFound:
                    // File doesn't exist
                    NSLog(@"file does not exist");
                    break;

                case FIRStorageErrorCodeUnauthorized:
                    // User doesn't have permission to access file
                    NSLog(@"permission denied");
                    break;

                case FIRStorageErrorCodeCancelled:
                    NSLog(@"file upload cancelled");
                    // User canceled the upload
                    break;

                case FIRStorageErrorCodeUnknown:
                    NSLog(@"error: %@", snapshot.error);
                    // Unknown error occurred, inspect the server response
                    break;
            }
        }
    }];
}



- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"Length of the private array: %lu", self.convertedPosts.count);
    NSLog(@"Length of the public array: %lu", (unsigned long)self.postsArray.count);
    
    self.combinedArray = [NSMutableArray arrayWithArray:self.convertedPosts];
    [self.combinedArray addObjectsFromArray:self.postsArray];
    
    NSLog(@"Length of ACTUAL COMBINED array: %lu", self.combinedArray.count);
    int i=0;
    for(NSObject *object in self.privatePosts)
    {
        //this takes the NSManagedObject and converts it into a dict in order to comply with our NSDictionary
        NSManagedObject *privatePost = [self.privatePosts objectAtIndex:i];
        NSArray *myKeys = [[[privatePost entity] attributesByName]allKeys];
        NSDictionary *myDict = [privatePost dictionaryWithValuesForKeys:myKeys];
        NSLog(@"Current dict being made: %@", myDict);
        [self.combinedArray addObject:myDict];
        i+=1;
    }
    return self.combinedArray.count;

}

@end
