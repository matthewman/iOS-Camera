//
//  ViewController.h
//  AVFoundation Test
//
//  Created by Matthew Man on 5/3/2017.
//  Copyright © 2017年 MatthewApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *viewFinder;
- (IBAction)takePic:(id)sender;
- (IBAction)flashSwitch:(id)sender;
- (IBAction)changeCam:(id)sender;

@end

