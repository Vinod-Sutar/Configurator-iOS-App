//
//  AppManager.h
//  AppConfiguratoriOSApp
//
//  Created by BBI-M USER1033 on 06/09/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppManager : NSObject
{
    NSArray * currentAvailableApps;
}

+(AppManager *) sharedInstance;

-(void) setAvailableApps:(NSArray *) availableApps;

-(NSArray *) currentAvailableApps;

@end
