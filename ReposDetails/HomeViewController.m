//
//  HomeViewController.m
//  ReposDetails
//
//  Created by Sasikumar P on 03/05/16.
//  Copyright © 2016 Sasikumar P. All rights reserved.
//

#import "HomeViewController.h"
#import <AFNetworking.h>
#import "AboutViewController.h"
#import "IssueViewController.h"

@interface HomeViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tblGitList;
@end
NSMutableDictionary *GitHubDetailsForHomePage;
NSMutableArray *GitHubDetailsForHomeDetails;
@implementation HomeViewController

@synthesize tblGitList;
- (void)viewDidLoad {
    [super viewDidLoad];
    tblGitList.delegate =self;
    tblGitList.dataSource =self;
    GitHubDetailsForHomePage =[[NSMutableDictionary alloc]init];
    GitHubDetailsForHomeDetails = [[NSMutableArray alloc]init];
    [self afnet];
}
-(void)afnet
{
    if ([GitHubDetailsForHomeDetails count] > 0) {
        [GitHubDetailsForHomeDetails removeAllObjects];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *URL = [NSString stringWithFormat:@"https://api.github.com/users/%@/repos?",[[NSUserDefaults standardUserDefaults] valueForKey:@"gitHubUserName"]];
    NSString *path = [NSString stringWithFormat:@"%@",URL];
    NSString *parameters = [NSString stringWithFormat:@"type=owner&username=%@&sort=full_name&page=0",[[NSUserDefaults standardUserDefaults] valueForKey:@"gitHubUserName"]];
    
    [manager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* error = nil;
        GitHubDetailsForHomeDetails = [NSJSONSerialization
                                       JSONObjectWithData:responseObject
                                       
                                       options:kNilOptions
                                       error:&error];
        [tblGitList reloadData];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         }];
}

- (IBAction)btnAboutClicked:(id)sender {
    
    AboutViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewController"];
    [self presentModalViewController:vc animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GitHubDetailsForHomeDetails count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableIdentifier = @"GitHubCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableIdentifier];
        cell.preservesSuperviewLayoutMargins = false;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    UILabel *RepoName = (UILabel *) [cell viewWithTag:1];
    RepoName.text = [[GitHubDetailsForHomeDetails objectAtIndex:indexPath.row] valueForKey:@"name"];
    RepoName.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:24.0f];
    RepoName.textColor = [UIColor colorWithRed:65.0/255.0 green:105.0/255.0 blue:225.0/255.0 alpha:1.0];
    UILabel *RepoDesc = (UILabel *) [cell viewWithTag:2];
    RepoDesc.text = [[GitHubDetailsForHomeDetails objectAtIndex:indexPath.row] valueForKey:@"description"];
    RepoDesc.textColor = [UIColor lightGrayColor];
    RepoDesc.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18.0];
    UILabel *RepoDate = (UILabel *) [cell viewWithTag:3];
    
    
    NSString *createdDate = [[GitHubDetailsForHomeDetails objectAtIndex:indexPath.row] valueForKey:@"updated_at"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [dateFormatter dateFromString:createdDate];
    NSTimeZone *pdt = [NSTimeZone timeZoneWithAbbreviation:@"PDT"];
    [dateFormatter setTimeZone:pdt];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * updated= [dateFormatter stringFromDate:date];
    RepoDate.text =updated;
    RepoDate.textColor = [UIColor lightGrayColor];
    RepoDate.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18.0];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableIdentifier = @"GitHubCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel* myTextLabel = [cell viewWithTag:1];
    [[NSUserDefaults standardUserDefaults] setValue:myTextLabel.text forKey:@"GitHubUserRepoName"];
    IssueViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"IssueViewController"];
    [self presentModalViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
