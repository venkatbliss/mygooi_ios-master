//
//  CommonFunctions.h
//  TTW_Mizer
//
//  Created by Administrator on 03/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
extern id navObj;

@interface CommonFunctions : NSObject{
    
}
+(void)showServerNotFoundError;
-(void)showAlertWithTitleAndMessage :(NSDictionary*)dic;
+(UIImage*)getCachedImage:(NSString*)imageUrl;
+(NSMutableArray *)GetRandomCases;
+(void)setRandomCases:(NSArray *)arr;
@end
