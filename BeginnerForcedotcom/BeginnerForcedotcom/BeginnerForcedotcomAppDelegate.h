//
//  BeginnerForcedotcomAppDelegate.h
//  BeginnerForcedotcom
//
//  Created by Quinton Wall on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BeginnerForcedotcomViewController;
@class ZKOAuthViewController;

@interface BeginnerForcedotcomAppDelegate : NSObject <UIApplicationDelegate> {
    
    ZKOAuthViewController *oAuthViewController;
    BeginnerForcedotcomViewController *beginningViewController;

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet BeginnerForcedotcomViewController *beginningViewController;

//method to show initial oauth login
- (void)showLogin;
- (void)hideLogin;

@end
