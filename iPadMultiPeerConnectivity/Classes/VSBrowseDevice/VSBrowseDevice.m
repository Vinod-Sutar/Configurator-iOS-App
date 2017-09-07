//
//  VSBrowseDevice.m
//  CollectionView
//
//  Created by BBI-M USER1033 on 14/08/17.
//  Copyright © 2017 BBI-M USER1033. All rights reserved.
//

#import "VSBrowseDevice.h"
#import "AppManager.h"

@interface VSBrowseDevice()
{
    MCPeerID * currentPeerID;
    MCSession * currentSession;
    MCNearbyServiceAdvertiser * serviceAdvertiser;
}

@end

@implementation VSBrowseDevice

static VSBrowseDevice * instance = nil;

+ (VSBrowseDevice *) sharedInstance {
    
    if (instance == nil) {
        
        instance = [[VSBrowseDevice alloc] init];
    }
    
    return instance;
}

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        
        currentPeerID = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
        currentSession = [[MCSession alloc] initWithPeer:currentPeerID];
        currentSession.delegate = self;
        
        serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:currentPeerID
                                                              discoveryInfo:nil
                                                                serviceType:@"bb-app-config"];
        serviceAdvertiser.delegate = self;
        [serviceAdvertiser startAdvertisingPeer];
    }
    return self;
}


-(void) showWithDelegate:(id) delegate {
    
    self.delegate = delegate;
}

#pragma mark - MCBrowserViewControllerDelegate method implementation

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController {
    
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MCSessionDelegate method implementation

-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state {
    
}


-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID {
        
    id receivedData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    if ([receivedData isKindOfClass:[NSDictionary class]])
    {
        NSDictionary * receivedDictionary = receivedData;
        
        NSString * wrapperType = [receivedDictionary valueForKey:@"wrapperType"];
        
        if ([wrapperType isEqualToString:@"apps"])
        {
            [[AppManager sharedInstance] setAvailableApps:[receivedDictionary valueForKey:@"results"]];
        }
        else if ([wrapperType isEqualToString:@"apps-position"])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AppPositionUpdated" object:[receivedDictionary valueForKey:@"position"]];
        }
    }
}


-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress{
    
    NSDictionary *dict = @{@"resourceName"  :   resourceName,
                           @"peerID"        :   peerID,
                           @"progress"      :   progress
                           };
    
    NSLog(@"didStartReceivingResourceWithName: %@", dict);
}


-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error {
    
    //UIImage * image = [[UIImage alloc] initWithData:[[NSData alloc] initWithContentsOfURL:localURL]];
}

-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID{
    
}


# pragma mark - MCNearbyServiceAdvertiserDelegate


- (void)        session:(MCSession *)session
  didReceiveCertificate:(nullable NSArray *)certificate
               fromPeer:(MCPeerID *)peerID
     certificateHandler:(void (^)(BOOL accept))certificateHandler;
{
    certificateHandler(YES);
}

- (void) advertiser:(MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error {
    
    NSLog(@"Failed to advertise Vibereel: %@", [error localizedDescription]);
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:    (MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
    invitationHandler(YES, currentSession);
}

@end
