//
//  ViewController.h
//  websocketsTest
//
//  Created by Laks Gandikota on 8/24/14.
//  Copyright (c) 2014 Laks Gandikota. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController <SocketIODelegate> {
    
    float               offsetG;
    float               newCompassTarget;
    
}

@property (strong, nonatomic) SocketIO *socketConnection;
@property (strong, nonatomic) CMMotionManager *motionManager;

@property (strong, nonatomic) IBOutlet UILabel *pitch;
@property (strong, nonatomic) IBOutlet UILabel *yaw;
@property (strong, nonatomic) IBOutlet UILabel *roll;

- (IBAction)sendXY:(id)sender;

- (void) connect;
- (void) disconnect;

@end

