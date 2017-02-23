//
//  ViewController.m
//  GCD_Example
//
//  Created by Johnson Elangbam on 10/20/15.
//  Copyright © 2015 Johnson Elangbam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)NSArray *imageArray;
@property (nonatomic, strong)NSOperationQueue *imgQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageTableView.delegate = self;
    self.imageTableView.dataSource = self;
    self.imgQueue = [[NSOperationQueue alloc]init];
    self.imgQueue.maxConcurrentOperationCount = NSOperationQueueDefaultMaxConcurrentOperationCount;
    
    self.imageArray = @[@"https://www.gstatic.com/webp/gallery3/1.png",
                        @"https://www.gstatic.com/webp/gallery3/2.png",
                        @"https://www.gstatic.com/webp/gallery3/3.png",
                        @"https://www.gstatic.com/webp/gallery3/5.png"];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
    }

    NSString *urlString = [self.imageArray objectAtIndex:indexPath.row];

    
    //Implement using GCD
    dispatch_queue_t backgroudThread = dispatch_queue_create("Image queue", NULL);
    
    dispatch_async(backgroudThread, ^{
        NSURL *imgUrl = [NSURL URLWithString:urlString];
        NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
        UIImage *image = [UIImage imageWithData:imgData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageView setImage:image];
            [cell setNeedsLayout];
        });
                          
    });
    
    
    //Implement using NSOperationQueue
    
//    [self.imgQueue addOperationWithBlock:^{
//        NSURL *imgUrl = [NSURL URLWithString:urlString];
//        NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
//        UIImage *image = [UIImage imageWithData:imgData];
//        
//        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//            [cell.imageView setImage:image];
//            [cell setNeedsLayout];
//        }];
//        
//    }];
    
    return cell;
    
}


@end
