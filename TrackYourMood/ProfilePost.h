//
//  ProfilePost.h
//  TrackYourMood
//
//  Created by gfloresv on 7/29/20.
//  Copyright © 2020 gfloresv. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProfilePost : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *profileUsername;
@property (weak, nonatomic) IBOutlet UILabel *profilePost;
@property (weak, nonatomic) IBOutlet UILabel *emojiLabel;

@end

NS_ASSUME_NONNULL_END
