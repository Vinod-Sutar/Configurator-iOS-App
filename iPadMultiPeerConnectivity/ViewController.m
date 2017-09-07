//
//  ViewController.m
//  iPadMultiPeerConnectivity
//
//  Created by BBI-M USER1033 on 14/08/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

#import "ViewController.h"
#import "VSBrowseDevice.h"
#import "CollectionViewCellApp.h"
#import "AppManager.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSArray * availableApps;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [VSBrowseDevice sharedInstance];
    [VSBrowseDevice sharedInstance].currentViewController = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appItemListUpdated:) name:@"AppListUpdated" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appItemPositionUpdated:) name:@"AppPositionUpdated" object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) appItemListUpdated:(NSNotification *) notification {
    
    [appCollectionView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

-(void) appItemPositionUpdated:(NSNotification *) notification  {
    
    NSLog(@"DataObject: %@", notification.object);
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
                   {
                       dispatch_async(dispatch_get_main_queue(), ^(void)
                                      {
                                          
                                          
                                          NSIndexPath *fromIndexPath = [NSIndexPath indexPathForRow:[[notification.object objectForKey:@"from"] integerValue] inSection:0];
                                          NSIndexPath *toIndexPath = [NSIndexPath indexPathForRow:[[notification.object objectForKey:@"to"] integerValue] inSection:0];

                                          
                                          [appCollectionView performBatchUpdates:^{
                                              
                                              [appCollectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
                                              
                                          } completion:^(BOOL finished) {}];
                                      });
                   });
    
}

-(void) appPositionUpdated:(NSNotification *) notification {

}

-(void) connectedDevices:(NSArray *) devices
{
    
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[[AppManager sharedInstance] currentAvailableApps] count];
}

-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCellApp * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellApp" forIndexPath:indexPath];
    
    return cell;
}


@end
