//
//  ViewController.h
//  GCD_Example
//
//  Created by Johnson Elangbam on 10/20/15.
//  Copyright © 2015 Johnson Elangbam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *imageTableView;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;


@end

