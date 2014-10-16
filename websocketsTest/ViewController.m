//
//  ViewController.m
//  websocketsTest
//
//  Created by Laks Gandikota on 8/24/14.
//  Copyright (c) 2014 Laks Gandikota. All rights reserved.
//

#import "ViewController.h"
#define CC_RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) / (float)M_PI * 180.0f)
#define degrees(x) (180.0 * x / M_PI)

@interface ViewController ()

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];

    //[self connect];
    [self initGyro];
}

//Gyro related

- (void)initGyro {
    
    self.motionManager = [[CMMotionManager alloc] init];
//    self.motionManager.accelerometerUpdateInterval = 1;
//    self.motionManager.gyroUpdateInterval = 1;

    self.motionManager.deviceMotionUpdateInterval = 0.5;
    
//    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
//                                             withHandler:^(CMAccelerometerData  *accelerometerData, NSError *error) {
//                                                 [self outputAccelertionData:accelerometerData.acceleration];
//                                                 if(error){
//                                                     
//                                                     NSLog(@"%@", error);
//                                                 }
//                                             }];
//    
//    [self.motionManager startGyroUpdatesToQueue:[NSOperationQueue currentQueue]
//                                    withHandler:^(CMGyroData *gyroData, NSError *error) {
//                                        [self outputRotationData:gyroData.rotationRate];
//                                    }];
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                            withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                                [self outputDeviceMotionData:motion.attitude];
                                            }];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    NSLog(@"Acceleration x: %@ y:%@", [NSString stringWithFormat:@" %.2f",acceleration.x * 57.29577951f], [NSString stringWithFormat:@" %.2f",acceleration.y * 57.29577951f]);
}
-(void)outputRotationData:(CMRotationRate)rotation
{
    
    NSLog(@"Rotation x: %@ y: %@", [NSString stringWithFormat:@" %.2f",rotation.x * 57.29577951f], [NSString stringWithFormat:@" %.2f",rotation.y * 57.29577951f]);
}

-(void)outputDeviceMotionData:(CMAttitude*)motion
{
    float yawDegrees = degrees(motion.yaw);
    //float yarD = degrees(motion.yaw);
    float pitchDegrees = degrees(motion.pitch);
    float rollDegrees = degrees(motion.roll);
    
    //yawDegrees = newCompassTarget + (yawDegrees - offsetG);
 
//    if(rollDegrees < 0) {
//        rollDegrees = rollDegrees + 220;
//    }
//    if(rollDegrees < 80) {
//        rollDegrees = 80;
//    }
//    if(rollDegrees > 220) {
//        rollDegrees = 220;
//    }

    _yaw.text = [NSString stringWithFormat:@"%.0f", yawDegrees];
    _pitch.text = [NSString stringWithFormat:@"%.0f", pitchDegrees];
    _roll.text = [NSString stringWithFormat:@"%.0f", rollDegrees];
    
    //NSLog(@"%f %f", yawDegrees, pitchDegrees);
    
    //[_socketConnection sendEvent:@"sendXY" withData:@[@150, [NSNumber numberWithFloat:ceil(rollDegrees)]]];
    
    //NSLog(@"Roll: %f Pitch: %f Yaw: %f", (motion.roll*180/M_PI), (motion.pitch*180/M_PI), (motion.yaw*180/M_PI));
}

// Socket related

- (void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"Socket has connected!");
    
    [_socketConnection sendEvent:@"ready" withData:@""];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    //NSLog(@"didReceiveMessage >>> data: %@", packet.data);
}

- (void) connect {
    if(!_socketConnection.isConnected) {
        _socketConnection = [[SocketIO alloc] initWithDelegate:self];
        [_socketConnection connectToHost:@"10.0.1.4"
                              onPort:3000];
    }
}

- (void) disconnect {

    if(_socketConnection.isConnected) {
        NSLog(@"Disconnecting.");
        [_socketConnection disconnect];
    }
}

- (IBAction)sendXY:(id)sender {
    
    NSLog(@"Button Clicked. %@", [sender currentTitle]);
    
    switch ([sender tag]) {
        case 1:
            [_socketConnection sendEvent:@"sendXY" withData:@[@150,@150]];
            break;
        case 2:
            [_socketConnection sendEvent:@"sendXY" withData:@[@90,@150]];
            break;
        case 3:
            [_socketConnection sendEvent:@"sendXY" withData:@[@90,@90]];
            break;
        case 4:
            [_socketConnection sendEvent:@"sendXY" withData:@[@150,@90]];
            break;
        default:
            break;
    }
    
}


@end
