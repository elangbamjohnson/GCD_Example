//
//  ViewController.m
//  GCD_Example
//
//  Created by Johnson Elangbam on 10/20/15.
//  Copyright © 2015 Johnson Elangbam. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong)NSString *weatherUrl;
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
    self.weatherUrl = @"http://api.wunderground.com/api/39c6d95e30243c4b/conditions/q/CA/San_Francisco.json";
    
    self.imageArray = @[@"https://www.gstatic.com/webp/gallery3/1.png",
                        @"https://www.gstatic.com/webp/gallery3/2.png",
                        @"https://www.gstatic.com/webp/gallery3/3.png",
                        @"https://www.gstatic.com/webp/gallery3/5.png"];
    [self getWeatherData];

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
    dispatch_queue_t backgroudThread = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(backgroudThread, ^{
        
        NSURL *imgUrl = [NSURL URLWithString:urlString];
        NSData *imgData = [NSData dataWithContentsOfURL:imgUrl];
        UIImage *image = [UIImage imageWithData:imgData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageView setImage:image];
            [cell setNeedsLayout];
            //NSLog(@"%@",json);
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


-(void)getWeatherData{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:@"http://api.wunderground.com/api/39c6d95e30243c4b/forecast10day/q/CA/San_Francisco.json"];
        NSString *json = [NSString stringWithContentsOfURL:url
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
        NSLog(@"\nJSON: %@ \n Error: %@", json, error);
        if(!error) {
            NSData *jsonData = [json dataUsingEncoding:NSASCIIStringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:kNilOptions
                                                                       error:&error];
            NSLog(@"JSON: %@", jsonDict);
        }
        
    });
    
   
    
    
}

@end
