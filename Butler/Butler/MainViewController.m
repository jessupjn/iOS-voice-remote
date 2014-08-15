//
//  MainViewController.m
//  Butler
//
//  Created by Jackson on 4/15/14.
//  Copyright (c) 2014 Jackson. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController () <WitDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation MainViewController


-(IBAction)btnaction:(id)sender
{
    NSLog(@"MakeRequest");
    [self.connectionDoctor makeAPIRequest:@"hi"];
}

// ================================================================================
//                            WIT METHODS
// ================================================================================

- (void)witDidGraspIntent:(NSString *)intent entities:(NSDictionary *)entities body:(NSString *)body error:(NSError *)e
{
    [spinner stopAnimating];
    
    if (e) {
        NSLog(@"[Wit] error: %@", [e localizedDescription]);
        return;
    }
    
    NSLog(@"%@", [NSString stringWithFormat:@"intent = %@", intent]);
    NSString *str = [NSString stringWithFormat:@"Intent: %@", intent];
    if([intent isEqualToString:@"devices"] )
    {
        str = [str stringByAppendingString:[NSString stringWithFormat:@"\nDevice: %@", entities[@"device"][@"value"]]];
    }
    if( [entities[@"device"][@"value"] isEqualToString:@"comcast_cable"] )
        str = [str stringByAppendingString:[NSString stringWithFormat:@"\nValue: %@", entities[@"desired_value"][@"value"]]];
    
    [outputString setText:str];
    
    
}
-(void)witDidStopRecording
{
    [spinner startAnimating];
}






// ================================================================================
//                            UITABLEVIEW DELEGATE METHODS
// ================================================================================
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listOfDevices count];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.frame.size.width, 13)];
    [label setFont:[UIFont boldSystemFontOfSize:15]];
    [label setText:@"Status of Devices"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(addDeviceButton) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Add" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    button.frame = CGRectMake(tableView.frame.size.width-35, 5, 30, 13);
    
    [view addSubview:button];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        [cell setBackgroundColor:[UIColor clearColor]];
        
        UIView *status = [[UIView alloc] initWithFrame:CGRectMake(180, 17, 10, 10)];
        [status setBackgroundColor:[UIColor redColor]];
        [status.layer setCornerRadius:5];
        [status.layer setBorderColor:[UIColor blackColor].CGColor];
        [status.layer setBorderWidth:1];
        [status setTag:90+indexPath.row];
        [cell addSubview:status];
    }
    return cell;
}
// ================================================================================









// ================================================================================
//                              ViewDidLoad
// ================================================================================

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Wit sharedInstance].delegate = self;
    
    self.connectionDoctor = [[ConnectionDoctor alloc] init];
    
    // create the button
    CGRect screen = [UIScreen mainScreen].bounds;
    CGFloat w = 100;
    CGRect rect = CGRectMake(screen.size.width/2 - w/2, screen.size.height/2 - w/2, w, w);
    
    WITMicButton* witButton = [[WITMicButton alloc] initWithFrame:rect];
    [[self.view viewWithTag:1] addSubview:witButton];
    [[self.view viewWithTag:1] bringSubviewToFront:[self.view viewWithTag:2]];
    [[self.view viewWithTag:2].layer setBorderWidth:1];
    [[self.view viewWithTag:2].layer setBorderColor:[UIColor blackColor].CGColor];
    
    [outputString setText:@""];
    
    
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(swipeLeft)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [[self.view viewWithTag:1] addGestureRecognizer:swipeGesture];
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                             action:@selector(swipeRight)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
    [[self.view viewWithTag:2] addGestureRecognizer:swipeGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(swipeRight)];
    [[self.view viewWithTag:2] addGestureRecognizer:tapGesture];
    
}










// =============================================================================
//                           Swipe Gestures
// =============================================================================

- (void) swipeLeft
{
    [[self.view viewWithTag:2] setHidden:false];
    
    CGRect newFrame = [self.view viewWithTag:1].frame;
    newFrame.origin.x = -200;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view viewWithTag:1].frame = newFrame;
        [self.view viewWithTag:2].alpha = 0.7;
    }];
}

- (void) swipeRight
{
    CGRect newFrame = [self.view viewWithTag:1].frame;
    newFrame.origin.x = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view viewWithTag:1].frame = newFrame;
        [self.view viewWithTag:2].alpha = 0;
    } completion:^(BOOL finished) {
        [[self.view viewWithTag:2] setHidden:true];
    }];
}


-(void)addDeviceButton
{
    ConnectionDoctor *doc = [[ConnectionDoctor alloc] init];
    [doc makeAPIRequest:@"HI"];
}
@end
