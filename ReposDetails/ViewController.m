//
//  ViewController.m
//  ReposDetails
//
//  Created by Sasikumar P on 02/05/16.
//  Copyright © 2016 Sasikumar P. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking.h>
#import "HomeViewController.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *GitHubUserName;
@property (strong, nonatomic) IBOutlet UITextField *GitHubPassword;
@end
@implementation ViewController
@synthesize GitHubPassword,GitHubUserName;
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)GitHubLogin:(id)sender {
    if(GitHubUserName.text.length == 0 && GitHubPassword.text.length != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Invalid Username" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        GitHubPassword.text =@"";
    }
    else if(GitHubPassword.text.length == 0 && GitHubUserName.text.length != 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Invalid Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        GitHubUserName.text =@"";
    }
    else if(GitHubPassword.text.length == 0 && GitHubUserName.text.length == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Invalid Username and Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:GitHubUserName.text forKey:@"gitHubUserName"];
        NSString *urlString = [NSString stringWithFormat:@"https://api.github.com/user"];
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSString *baseStr = [NSString stringWithFormat:@"%@%s%@", GitHubUserName.text, ":", GitHubPassword.text];
        NSData *nsdata = [baseStr
                          dataUsingEncoding:NSUTF8StringEncoding];
        NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
        NSString *someText = [NSString stringWithFormat: @"Basic %@",base64Encoded];
        [request setValue:someText forHTTPHeaderField:@"Authorization"];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError)
         {
             if (data)
             {
                 NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                 @try {
                     dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                     if ([[dic valueForKey:@"message"]isEqualToString:@"Bad credentials"])
                     {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bad credentials" message:@"Invalid Username and Password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                         [alert show];
                         GitHubPassword.text = @"";
                         GitHubUserName.text = @"";
                     }
                     else{
                         
                         NSString *myImage = [dic valueForKey:@"avatar_url"];
                         NSString *myUser = [dic valueForKey:@"login"];
                         NSString *myCreatedDate = [dic valueForKey:@"created_at"];
                         NSString *GitHubUserFollowings = [dic valueForKey:@"following"];
                         NSString *GitHubUserFollowers = [dic valueForKey:@"followers"];
                         [[NSUserDefaults standardUserDefaults] setObject:myImage forKey:@"GitHubUserImage"];
                         [[NSUserDefaults standardUserDefaults] setObject:myUser forKey:@"GitHubUsername"];
                         [[NSUserDefaults standardUserDefaults] setObject:myCreatedDate forKey:@"GitHubUserCreatedDate"];
                         [[NSUserDefaults standardUserDefaults] setObject:GitHubUserFollowings forKey:@"GitHubUserFollowings"];
                         [[NSUserDefaults standardUserDefaults] setObject:GitHubUserFollowers forKey:@"GitHubUserFollowers"];
                         HomeViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
                         [self presentModalViewController:vc animated:YES];
                     }
                 }
                 @catch (NSException *exception)
                 {
                 }
                 @finally {
                 }
             }
         }];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
