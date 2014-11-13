//
//  BusinessListView.m
//  MyGooi
//
//  Created by Vijayakumar on 06/10/14.
//  Copyright (c) 2014 Vijayakumar. All rights reserved.
//

#import "BusinessListView.h"
#import "BusinessListCell.h"
#import "LocationSearchViewController.h"
#import "SWRevealViewController.h"
#import "Confic.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+LazyImage.h"
@interface BusinessListView ()
{
    IBOutlet UIActivityIndicatorView *activityIndicator;
    NSString *my_name;
    NSString *my_address;
    NSString *likecount;
    NSString *dislikecount;
    NSString *strImageURL;
    NSArray *resposearry;
    NSMutableArray *respose1arry;
}
@end

@implementation BusinessListView

- (void)viewDidLoad {
    [self getBusinessDetails];
   
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -hideStatusBar
- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    if(_LoadFromProfileView){
        
        CGRect frame=_backBtn.frame;
        frame.size.width=58;
        frame.size.height=23;
        _backBtn.frame=frame;
        
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"Back_button.png"] forState:UIControlStateNormal];
        
    }else{
        CGRect frame=_backBtn.frame;
        frame.size.width=29;
        frame.size.height=21;
        _backBtn.frame=frame;
        [_backBtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setImage:[UIImage imageNamed:@"menu.png"] forState:UIControlStateNormal];
        
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
    }
}
-(void)getBusinessDetails
{
    @try {
        
        NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[Confic getUsername],@"user_name",@"1.0",@"APIVersion", nil];
        activityIndicator.hidden=NO;
        [[Confic getInstance]httpReqquest:[dic mutableCopy] currentWindow:self.view path:@"business/list_of_business" success:^(id responseObject) {
            NSError* error;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject   options:kNilOptions error:&error];
          resposearry =[json valueForKey:@"result"];
            [self.Business_table reloadData];
            if(json!=nil)
            activityIndicator.hidden=YES;
        } failure:^(NSError *error) {
            activityIndicator.hidden=YES;
            if(MYGOOI_DEV)
                NSLog(@"Error %@",error);
        } method:@"GET"];
        
    }
    @catch (NSException *exception) {
        [ErrorReport sendErrorReport:NSStringFromClass([self class]) Method:[NSString stringWithFormat:@"%s",__FUNCTION__] Exception:exception];
        
    }
}


#pragma mark TableView Datasource and Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [resposearry count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *CellIdentifier=@"BusinessListCell";

    BusinessListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[BusinessListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
   [cell.logo setImageWithUrl:[NSURL URLWithString:[[resposearry objectAtIndex:indexPath.row] valueForKey:@"image_url"]]];
    cell.name.text = [[resposearry objectAtIndex:indexPath.row]objectForKey:@"name"];
    cell.address.text=[[resposearry objectAtIndex:indexPath.row]objectForKey:@"address"];
cell.gooi_lbl.text=[[[resposearry objectAtIndex:indexPath.row]objectForKey:@"like_count"] stringValue];
cell.ungooi_lbl.text=[[[resposearry objectAtIndex:indexPath.row]objectForKey:@"dislike_count"] stringValue];
    
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 180;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}

- (IBAction)addBusiness:(id)sender {
    [self performSegueWithIdentifier:@"LocationSearchViewController" sender:self];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"LocationSearchViewController"]) {
        
        LocationSearchViewController *obj = [segue destinationViewController];
        obj.fromBusinessView=YES;
        
    }
}


@end
