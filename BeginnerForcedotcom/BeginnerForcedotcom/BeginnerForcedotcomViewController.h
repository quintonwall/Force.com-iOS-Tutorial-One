//
//  BeginnerForcedotcomViewController.h
//  BeginnerForcedotcom
//
//  Created by Quinton Wall on 4/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZKSforce.h"

@interface BeginnerForcedotcomViewController : UIViewController <UITableViewDelegate,UITableViewDataSource> {
    
    IBOutlet UITableView *tableView;
    NSMutableArray *dataRows;
}

@property (nonatomic, retain) NSMutableArray *dataRows;
@property (nonatomic, retain) UITableView *tableView;

@end


