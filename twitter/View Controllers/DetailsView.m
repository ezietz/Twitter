//
//  DetailsView.m
//  twitter
//
//  Created by ezietz on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "DetailsView.h"
#import "Tweet.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface DetailsView ()
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *authorView;
@property (weak, nonatomic) IBOutlet UILabel *userView;
@property (weak, nonatomic) IBOutlet UILabel *textView;
@property (weak, nonatomic) IBOutlet UILabel *dateView;
@property (weak, nonatomic) IBOutlet UIButton *favorIcon;
@property (weak, nonatomic) IBOutlet UIButton *retweetIcon;

@end


@implementation DetailsView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self refreshData];
    
}

- (void)refreshData {
    User *user = self.tweet.user;
    
    self.userView.text = user.screenName;
    self.authorView.text = user.name;
    self.textView.text = self.tweet.text;
    self.dateView.text = self.tweet.createdAtString;
    
    [self.favorIcon setTitle:[NSString stringWithFormat:@"%d",self.tweet.favoriteCount] forState:UIControlStateNormal];
    [self.retweetIcon setTitle:[NSString stringWithFormat:@"%d",self.tweet.retweetCount] forState:UIControlStateNormal];
    self.rtCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.heartCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    NSString *profileImg = user.profileImage;
    NSURL *profileURL = [NSURL URLWithString:profileImg];
    self.profileView.image = nil;
    [self.profileView setImageWithURL:profileURL];
    
    [self.favorIcon setImage: [UIImage imageNamed:@"favor-icon"]
                    forState: UIControlStateNormal];
    [self.favorIcon setImage: [UIImage imageNamed:@"favor-icon-red"]
                    forState: UIControlStateSelected];
    [self.retweetIcon setImage: [UIImage imageNamed:@"retweet-icon"]
                      forState: UIControlStateNormal];
    [self.retweetIcon setImage: [UIImage imageNamed:@"retweet-icon-green"]
                      forState: UIControlStateSelected];
}

- (IBAction)didTapHeart:(id)sender {
    [[APIManager shared] favoriteTweet:self.tweet withState:self.tweet.favorited andCompletion:^(Tweet *tweet, BOOL hasRetweeted, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            if (hasRetweeted) {
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;
                [self.favorIcon setSelected:NO];
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
            else {
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
                [self.favorIcon setSelected:YES];
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
            [self refreshData];
        }
    }];
}

- (IBAction)didTapRetweet:(id)sender {
    [[APIManager shared] retweet:self.tweet withState:self.tweet.retweeted andCompletion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            if (self.tweet.retweeted) {
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
                [self.retweetIcon setSelected:NO];
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
            else {
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                [self.retweetIcon setSelected:YES];
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
            [self refreshData];
        }
    }];
}
@end

