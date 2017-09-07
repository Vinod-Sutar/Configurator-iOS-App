//
//  AppManager.m
//  AppConfiguratoriOSApp
//
//  Created by BBI-M USER1033 on 06/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

#import "AppManager.h"

@implementation AppManager

static AppManager * instance = nil;

+(AppManager *) sharedInstance;
{
    if (instance == nil)
    {
        instance = [[AppManager alloc] init];
    }
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

-(void) setAvailableApps:(NSArray *) availableApps
{
    currentAvailableApps = availableApps;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AppListUpdated" object:currentAvailableApps];
}

-(NSArray *) currentAvailableApps {
    
    return currentAvailableApps;
}


@end
