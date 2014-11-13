//
//  CommonFunctions.m
//  TTW_Mizer
//
//  Created by Administrator on 03/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CommonFunctions.h"
#import "ImgCache.h"

id navObj;
static NSMutableArray *arrRandomCases;
@implementation CommonFunctions
+(void)showServerNotFoundError{
    
	NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:@"Server not responding", @"title", @"System can't connect to internet. Please check connectivity.\n Thank You",@"msg", nil];
    [[[CommonFunctions  alloc] init] performSelectorOnMainThread:@selector(showAlertWithTitleAndMessage:) withObject:dic waitUntilDone:TRUE];
}
-(void)showAlertWithTitleAndMessage :(NSDictionary*)dic{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:[dic valueForKey:@"title"] message:[dic valueForKey:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alert show];
}

+(UIImage*)getCachedImage:(NSString*)imageUrl
{
    ImgCache *ic = [[ImgCache alloc] init];
	UIImage *img = [ic getCachedImage:imageUrl];
	return img;
}

+(NSMutableArray *)GetRandomCases
{
    if (!arrRandomCases) {
        arrRandomCases = [[NSMutableArray alloc]init];
    }
    return arrRandomCases;
}

+(void)setRandomCases:(NSArray *)arr
{
    arrRandomCases = [arr mutableCopy];
}
@end
