//
//  IssueViewController.m
//  ReposDetails
//
//  Created by Sasikumar P on 05/05/16.
//  Copyright © 2016 Sasikumar P. All rights reserved.
//

#import "IssueViewController.h"
#import <AFNetworking.h>
#import "HomeViewController.h"
@interface IssueViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end
NSMutableArray *GitHubDetailsForIssueDetails;

@implementation IssueViewController
@synthesize tblView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GitHubDetailsForIssueDetails = [[NSMutableArray alloc]init];
    [self afnet];
    tblView.delegate = self;
    tblView.dataSource = self;
}
- (IBAction)IssueBack:(id)sender {
    HomeViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self presentModalViewController:controller animated:YES];
}


-(void)afnet
{
    if ([GitHubDetailsForIssueDetails count] > 0) {
        [GitHubDetailsForIssueDetails removeAllObjects];
    }
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    manager.responseSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *URL = [NSString stringWithFormat:@"https://api.github.com/repos/%@/%@/issues?",[[NSUserDefaults standardUserDefaults] valueForKey:@"gitHubUserName"],[[NSUserDefaults standardUserDefaults] valueForKey:@"GitHubUserRepoName"]];
    NSString *path = [NSString stringWithFormat:@"%@",URL];
    NSString *parameters = [NSString stringWithFormat:@"sort=updated&owner=%@&name=%@&all=assigned",[[NSUserDefaults standardUserDefaults] valueForKey:@"gitHubUserName"],[[NSUserDefaults standardUserDefaults] valueForKey:@"GitHubUserRepoName"]];
    
    [manager GET:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError* error = nil;
        GitHubDetailsForIssueDetails = [NSJSONSerialization
                                        JSONObjectWithData:responseObject
                                        
                                        options:kNilOptions
                                        error:&error];
        [tblView reloadData];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [GitHubDetailsForIssueDetails count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *TableIdentifier = @"GitHubCellForIssue";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:TableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableIdentifier];
        cell.preservesSuperviewLayoutMargins = false;
        cell.separatorInset = UIEdgeInsetsZero;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    UILabel *IssueName = (UILabel *) [cell viewWithTag:1];
    IssueName.text = [[GitHubDetailsForIssueDetails objectAtIndex:indexPath.row] valueForKey:@"title"];
    IssueName.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:24.0f];
    IssueName.textColor = [UIColor colorWithRed:65.0/255.0 green:105.0/255.0 blue:225.0/255.0 alpha:1.0];
    UILabel *IssueDesc = (UILabel *) [cell viewWithTag:2];
    IssueDesc.text = [[GitHubDetailsForIssueDetails objectAtIndex:indexPath.row] valueForKey:@"body"];
    IssueDesc.textColor = [UIColor lightGrayColor];
    IssueDesc.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18.0];
    UILabel *IssueDate = (UILabel *) [cell viewWithTag:3];
    
    
    NSString *createdDate = [[GitHubDetailsForIssueDetails objectAtIndex:indexPath.row] valueForKey:@"updated_at"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [dateFormatter dateFromString:createdDate];
    NSTimeZone *pdt = [NSTimeZone timeZoneWithAbbreviation:@"PDT"];
    [dateFormatter setTimeZone:pdt];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * updated= [dateFormatter stringFromDate:date];
    IssueDate.text =updated;
    IssueDate.textColor = [UIColor lightGrayColor];
    IssueDate.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:18.0];
    
    return cell;
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
