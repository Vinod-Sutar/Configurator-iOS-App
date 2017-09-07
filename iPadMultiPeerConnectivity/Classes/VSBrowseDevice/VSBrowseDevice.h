//
//  VSBrowseDevice.h
//  CollectionView
//
//  Created by BBI-M USER1033 on 14/08/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#import "ViewController.h"

@protocol VSBrowseDeviceDelegate <NSObject>

@required
-(void) didAvailableAppsUpdated:(NSArray *) apps;

@end

@interface VSBrowseDevice : NSObject <MCBrowserViewControllerDelegate, MCSessionDelegate, MCNearbyServiceAdvertiserDelegate>

+ (VSBrowseDevice *) sharedInstance;

-(void) showWithDelegate:(id) delegate;

@property (nonatomic, weak) id<VSBrowseDeviceDelegate> delegate;

@property (nonatomic, weak) ViewController * currentViewController;

@end
