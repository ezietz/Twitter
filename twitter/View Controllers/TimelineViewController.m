//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, ComposeViewControllerDelegate>

@property (strong, nonatomic) NSMutableArray *tweetsArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // view controller becomes table view's dataSource and delegate in viewDidLoad
    self.tableView.dataSource = self; // data Source for tableview is the object that gives the table view the thing it'll display
    self.tableView.delegate = self; // delegate responds to touch events, how many things to make
    
    [self fetchTweets];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    // Get timeline
    
    
}

- (void) fetchTweets {
    // [APIManager shared] grabs an instance of the API Manager
    // make an API request
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        // API manager calls the completion handler passing back data
        if (tweets) {
             // numberOfRowsInSection returns the number of items returned from the API
            
            // View controller stores that data passed into the completion handler
            self.tweetsArray = tweets;
            // Reload the table view
            [self.tableView reloadData];
            /*
             NSLog(@"😎😎😎 Successfully loaded home timeline");
             for (NSDictionary *dictionary in tweets) {
             NSString *text = dictionary[@"text"];
             NSLog(@"%@", text);
             }
             
             }
             */
        }
        else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        
    }];
}

// table view asks its dataSource for numberOfRowsInSection and cellForRowAtIndexPath
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    // cellForRowAtIndexPath returns an instance of the custom cell with that reuse identifier with its elements populated with data at the index asked for
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweetsArray[indexPath.row];
    cell.tweet = tweet;
    User *tweetUser = tweet.user;
    
    [cell refreshData];    
    return cell;
}

 // numberOfRowsInSection returns the number of items returned from the API
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweetsArray.count;
}
- (IBAction)clickedLogout:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// #pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = [segue destinationViewController];
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
}


- (void)didTweet:(nonnull Tweet *)tweet {
    [self.tweetsArray addObject:tweet];
    [self.tableView reloadData];
}


@end
