//
//  AppDelegate.h
//  bjsubway
//
//  Created by apple on 14/11/30.
//  Copyright (c) 2014年 bangtech. All rights reserved.
//

#import <UIKit/UIKit.h>
enum APPRATE{
    NOSTATUS,
    ONEWEEKLATER,
    RATED,
    NOTYET,
};
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSNumber *willNotice;
@property (strong, nonatomic) NSNumber *rate;
@property (strong, nonatomic) NSData *graphlist;
@end

