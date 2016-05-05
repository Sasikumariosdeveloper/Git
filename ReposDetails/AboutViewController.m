//
//  AboutViewController.m
//  ReposDetails
//
//  Created by Sasikumar P on 03/05/16.
//  Copyright © 2016 Sasikumar P. All rights reserved.
//

#import "AboutViewController.h"
#import "HomeViewController.h"
@interface AboutViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *GitHubUserImage;
@property (strong, nonatomic) IBOutlet UILabel *GitHubUserName;
@property (strong, nonatomic) IBOutlet UILabel *GitHubUserCreatedDate;
@property (strong, nonatomic) IBOutlet UILabel *FollowersCount;
@property (strong, nonatomic) IBOutlet UILabel *StarredCount;
@property (strong, nonatomic) IBOutlet UILabel *FollowingCount;
@end

@implementation AboutViewController
@synthesize GitHubUserImage,GitHubUserName,GitHubUserCreatedDate,FollowingCount,StarredCount,FollowersCount;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL * imageURL = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults ]objectForKey:@"GitHubUserImage"]];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    GitHubUserImage.image = [UIImage imageWithData:imageData];
    GitHubUserImage.layer.cornerRadius = 10;
    GitHubUserImage.layer.borderWidth = 0.0;
    GitHubUserImage.layer.masksToBounds = YES;
    GitHubUserImage.contentMode = UIViewContentModeScaleAspectFit;
    
    GitHubUserName.text = [[NSUserDefaults standardUserDefaults ]objectForKey:@"GitHubUsername"];
    GitHubUserName.textColor = [UIColor darkGrayColor];
    GitHubUserName.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18.0];
    FollowersCount.text = [[[NSUserDefaults standardUserDefaults ]objectForKey:@"GitHubUserFollowers"] stringValue];
    FollowingCount.text = [[[NSUserDefaults standardUserDefaults ]objectForKey:@"GitHubUserFollowings"] stringValue];
    NSString *createdDate = [[NSUserDefaults standardUserDefaults ]objectForKey:@"GitHubUserCreatedDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [dateFormatter dateFromString:createdDate];
    NSTimeZone *pdt = [NSTimeZone timeZoneWithAbbreviation:@"PDT"];
    [dateFormatter setTimeZone:pdt];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * updated= [dateFormatter stringFromDate:date];
    GitHubUserCreatedDate.text = [NSString stringWithFormat:@"Joined on %@",updated];
}

- (IBAction)backAbout:(id)sender {
    HomeViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self presentModalViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
