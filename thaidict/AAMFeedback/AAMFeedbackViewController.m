//
//  AAMFeedbackViewController.m
//  AAMFeedbackViewController
//
//  Created by 深津 貴之 on 11/11/30.
//  Copyright (c) 2011年 Art & Mobile. All rights reserved.
//

#import "AAMFeedbackViewController.h"
#import "AAMFeedbackTopicsViewController.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

#import <SystemConfiguration/SystemConfiguration.h>
#import "MyAlert.h"

@interface AAMFeedbackViewController(private)
    - (NSString *) _platform;
    - (NSString *) _platformString;
    - (NSString*)_feedbackSubject;
    - (NSString*)_feedbackBody;
    - (NSString*)_appName;
    - (NSString*)_appBundleName;
    - (NSString*)_appVersion;
    - (NSString*)_selectedTopic;
    - (NSString*)_selectedTopicToSend;
    - (void)_updatePlaceholder;
    - (NSString*)_carrierName;
    - (NSString *) _networkinfo;
@end

@implementation AAMFeedbackViewController

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

+ (BOOL)isAvailable
{
    if([MFMailComposeViewController class]){
        return YES;
    }
    return NO;
}

- (void)awakeFromNib
{
//    self = [super initWithStyle:UITableViewStyleGrouped];
//    if(self){
        self.topics = [[NSArray alloc]initWithObjects:
                       @"AAMFeedbackTopicsQuestion",
                       @"AAMFeedbackTopicsRequest",
                       @"AAMFeedbackTopicsBugReport",
                       @"AAMFeedbackTopicsMedia",
                       @"AAMFeedbackTopicsBusiness",
                       @"AAMFeedbackTopicsOther", nil];
        
        self.topicsToSend = [[NSArray alloc]initWithObjects:
                             @"Question",
                             @"Request",
                             @"Bug Report",
                             @"Media",
                             @"Business",
                             @"Other", nil];
//    }
//    return self;
}

- (id)initWithTopics:(NSArray*)theIssues
{
    self = [self init];
    if(self){
        self.topics = theIssues;
        self.topicsToSend = theIssues;
    }
    return self;
}

- (id) initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}
#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
//    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
//        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationController.navigationBar.translucent = NO;
    
    
    
    self.title = NSLocalizedString(@"AAMFeedbackTitle", nil);

    UIBarButtonItem *cancelBarBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
    self.navigationItem.leftBarButtonItem = cancelBarBtn;
    
    UIBarButtonItem *sendBarBtn =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"AAMFeedbackButtonMail", nil) style:UIBarButtonItemStylePlain target:self action:@selector(nextDidPress:)];
    

    self.navigationItem.rightBarButtonItem = sendBarBtn;
    

    
    NSDictionary *dict1     = [NSDictionary dictionaryWithObjectsAndKeys:@"Topic",@"title",
                                @"Question",@"description",@"",@"placeholder",nil];
    NSDictionary *dict2     = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"title",
                                @"",@"description",@"",@"placeholder",nil];
    NSDictionary *dict3     = [NSDictionary dictionaryWithObjectsAndKeys:@"Device",@"title",
                                [self _platformString],@"description",@"",@"placeholder",nil];
    NSDictionary *dict4     = [NSDictionary dictionaryWithObjectsAndKeys:@"iOS Version",@"title",
                                [UIDevice currentDevice].systemVersion,@"description",@"",@"placeholder",nil];
    NSDictionary *dict5     = [NSDictionary dictionaryWithObjectsAndKeys:@"App Name",@"title",
                                [self _appName],@"description",@"",@"placeholder",nil];
    NSDictionary *dict6     = [NSDictionary dictionaryWithObjectsAndKeys:@"App Version",@"title",
                                [self _appVersion],@"description",@"",@"placeholder",nil];
    NSDictionary *dict7     = [NSDictionary dictionaryWithObjectsAndKeys:@"Carrier",@"title",
                                [self _carrierName],@"description",@"",@"placeholder",nil];
    NSDictionary *dict8     = [NSDictionary dictionaryWithObjectsAndKeys:@"Network",@"title",
                                [self _networkinfo],@"description",@"",@"placeholder",nil];
    NSDictionary *dict9     = [NSDictionary dictionaryWithObjectsAndKeys:@"ID",@"title",
                                self.currentSSOID,@"description",@"",@"placeholder",nil];
    NSDictionary *dict10    = [NSDictionary dictionaryWithObjectsAndKeys:@"Account",@"title",
                                self.currentUserName,@"description",@"",@"placeholder",nil];

    self.array = [[NSMutableArray alloc] initWithCapacity:3];
    
    NSArray *array1 = [NSArray arrayWithObjects:dict1, dict2,nil];
    NSArray *array2 = [NSArray arrayWithObjects:dict3, dict4,dict5, dict6, dict7, dict8, nil];
    NSArray *array3 = [NSArray arrayWithObjects:dict9, dict10,nil];
    
    NSDictionary *secitionDic1 = [NSDictionary dictionaryWithObject:array1 forKey:@"section"];
    NSDictionary *secitionDic2 = [NSDictionary dictionaryWithObject:array2 forKey:@"section"];
    NSDictionary *secitionDic3 = [NSDictionary dictionaryWithObject:array3 forKey:@"section"];
    
    [self.array addObject:secitionDic1];
    [self.array addObject:secitionDic2];
    [self.array addObject:secitionDic3];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    _descriptionPlaceHolder = nil;
    _descriptionTextView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self _updatePlaceholder];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(_isFeedbackSent){
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.array count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSDictionary *dictionary = [self.array objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"section"];
    return [array count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==1){
        return MAX(88, _descriptionTextView.contentSize.height);
    }
    
    return 44;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return NSLocalizedString(@"AAMFeedbackTableHeaderTopics", nil);
            break;
        case 1:
            return NSLocalizedString(@"AAMFeedbackTableHeaderBasicInfo", nil);
            break;
        case 2:
            return @"Your Account Information";
            break;
            
        default:
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil) {
            if(indexPath.row==0 && indexPath.section == 0){
                //Topics
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.row == 1 && indexPath.section == 0){
                //Topics Description
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                _descriptionTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, 300, 88)];
                _descriptionTextView.backgroundColor = [UIColor clearColor];
                _descriptionTextView.font = [UIFont systemFontOfSize:16];
                _descriptionTextView.delegate = self;
                _descriptionTextView.scrollEnabled = NO;
                _descriptionTextView.tag = 12345;
                _descriptionTextView.text = self.descriptionText;
                [cell.contentView addSubview:_descriptionTextView];
                
                _descriptionPlaceHolder = [[UITextField alloc]initWithFrame:CGRectMake(16, 8, 300, 20)];
                _descriptionPlaceHolder.font = [UIFont systemFontOfSize:16];
                _descriptionPlaceHolder.placeholder = NSLocalizedString(@"AAMFeedbackDescriptionPlaceholder", nil);
                _descriptionPlaceHolder.userInteractionEnabled = NO;
                [cell.contentView addSubview:_descriptionPlaceHolder];
                
                [self _updatePlaceholder];
            }
        	else
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
                cell.accessoryType = UITableViewCellAccessoryNone;
            
            }
        }
    
    
    NSDictionary *dictionary = [self.array objectAtIndex:indexPath.section];
    NSArray *array = [dictionary objectForKey:@"section"];
    
    if (indexPath.row == 0 && indexPath.section == 0)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = NSLocalizedString(@"AAMFeedbackTopicsTitle", nil);
        cell.detailTextLabel.text = NSLocalizedString([self _selectedTopic],nil);

    }
    if (indexPath.row == 1 && indexPath.section == 0)
    {
        [self _updatePlaceholder];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell.textLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.detailTextLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"description"];

    }
    else if (indexPath.row >= 0 && indexPath.section == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        cell.textLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.detailTextLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"description"];
    }else if (indexPath.row >= 0 && indexPath.section == 2){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.textLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.detailTextLabel.text = [[array objectAtIndex:indexPath.row] objectForKey:@"description"];
    }
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0 && indexPath.row==0){
        [_descriptionTextView resignFirstResponder];
        
        AAMFeedbackTopicsViewController *vc = [[AAMFeedbackTopicsViewController alloc]initWithStyle:UITableViewStyleGrouped];
        vc.delegate = self;
        vc.selectedIndex = _selectedTopicsIndex;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


-(void)cancelAction{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)cancelDidPress1:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)nextDidPress:(id)sender
{
    if ([_descriptionTextView.text length] >= 10)
    {
        MyAlertWithActivityIndicatorShowWihtMessage(@"Sending...", @"Please Wait");
        [_descriptionTextView resignFirstResponder];
        
        NSString *latString = [[NSUserDefaults standardUserDefaults] objectForKey:@"latKey"];
        NSString *lonString = [[NSUserDefaults standardUserDefaults] objectForKey:@"lonKey"];

        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [self _selectedTopicToSend]						,@"topic",
                              _descriptionTextView.text					,@"comment",
                              [self _platformString]					,@"device",
                              @"ios"									,@"os",
                              [UIDevice currentDevice].systemVersion	,@"os_version",
                              [self _appBundleName]						,@"appname",
                              [self _appName]							,@"displayname",
                              [self _appVersion]						,@"version",
                              [self _carrierName]						,@"cn",
                              [self _networkinfo]						,@"network",
                              self.currentSSOID                         ,@"user_id",
                              self.currentUserName						,@"account",
                              latString									,@"lat",
                              lonString									,@"lon",
                              nil];
        
        NSLog(@"dict = %@",dict);
        
        /*[apiService sendFeedbackBy:dict completeBlock:^(BOOL success, NSDictionary *data) {
            
            if(success){
                MyAlertWithActivityIndicatorStop();
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self _appName] message:@"ส่งข้อมูลเรียบร้อยแล้ว ขอบคุณค่ะ" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }else{
                MyAlertWithActivityIndicatorStop();
            }
        }];*/
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
        
        NSString *theURL = [NSString stringWithFormat:@"http://widget4.truelife.com/feedback/rest/?method=feedback&format=json"];
        NSURL *url = [NSURL URLWithString:theURL];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [request setTimeoutInterval:30.0f];
        
        if ([[NSURLConnection class] respondsToSelector:@selector(sendAsynchronousRequest:queue:completionHandler:)]) {
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
                                   completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
                                       
                                       if (error)
                                       {
                                           MyAlertWithActivityIndicatorStop();
                                       }
                                       else
                                       {
                                           MyAlertWithActivityIndicatorStop();
                                           
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[self _appName] message:@"ส่งข้อมูลเรียบร้อยแล้ว ขอบคุณค่ะ" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                           [alertView show];
                                       }
                                       
                                   }];
        }
        
        
        
        
        
    } else
    {
        [_descriptionTextView becomeFirstResponder];
	    MyAlertWithMessage(@"กรุณาใส่รายละเอียดที่ต้องการ 10 ตัวอักษรขึ้นไป ก่อนแจ้งค่ะ");

    }

}


- (void)textViewDidChange:(UITextView *)textView
{
    CGRect f = _descriptionTextView.frame;
    f.size.height = _descriptionTextView.contentSize.height;
    _descriptionTextView.frame = f;
    [self _updatePlaceholder];
    self.descriptionText = _descriptionTextView.text;
    
    //Magic for updating Cell height
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if(result==MFMailComposeResultCancelled){
    }else if(result==MFMailComposeResultSent){
        _isFeedbackSent = YES;
    }else if(result==MFMailComposeResultFailed){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
                                                        message:@"AAMFeedbackMailDidFinishWithError"
                                                       delegate:nil 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    [controller dismissViewControllerAnimated:YES completion:^{}];
}


- (void)feedbackTopicsViewController:(AAMFeedbackTopicsViewController *)feedbackTopicsViewController didSelectTopicAtIndex:(NSInteger)selectedIndex {
    _selectedTopicsIndex = selectedIndex;
}

#pragma mark - Internal Info

- (NSString *) _networkinfo
{
        SCNetworkReachabilityRef reach = SCNetworkReachabilityCreateWithName(kCFAllocatorSystemDefault, "google.com"); // Attempt to ping google.com
                                                                         SCNetworkConnectionFlags flags;
                                                                         SCNetworkReachabilityGetFlags(reach, &flags); // Store reachability flags in the variable, flags.
                                                                         
     if(kSCNetworkReachabilityFlagsReachable & flags) {
         // Can be reached using current connection.
     }
     
     if(kSCNetworkReachabilityFlagsConnectionAutomatic & flags) {
         // Can be reached using current connection, but a connection must be established. (Any traffic to the specific node will initiate the connection)
         
     }
     
     if(kSCNetworkReachabilityFlagsIsWWAN & flags) {
         // Can be reached via the carrier network
     } else {
         // Cannot be reached using the carrier network
     }
     
     if((kSCNetworkReachabilityFlagsReachable & flags) && !(kSCNetworkReachabilityFlagsIsWWAN & flags)) {
         // Cannot be reached using the carrier network, but it can be reached. (Therefore the device is using wifi)
         return @"WiFi";
     } else if (kSCNetworkReachabilityFlagsIsWWAN & flags) {
         // Using the carrier network
         return @"Edge/3G";
     } else {
         // No connection available.
         return @"";
     }

}

- (NSString *) _carrierName
{
    CTTelephonyNetworkInfo *myNetworkInfo = [[CTTelephonyNetworkInfo alloc] init];
    NSString *theString = myNetworkInfo.subscriberCellularProvider.carrierName;
    if (theString == nil) theString = @"N/A";
    return theString;
}
- (void)_updatePlaceholder
{
    if([_descriptionTextView.text length]>0){
        _descriptionPlaceHolder.hidden = YES;
    }else{
        _descriptionPlaceHolder.hidden = NO;
    }
}

- (NSString*)_feedbackSubject
{
    return [NSString stringWithFormat:@"%@: %@", [self _appName],[self _selectedTopicToSend], nil];
}
   
- (NSString*)_feedbackBody
{
     NSString *body;
        if ((![self.currentUserName isEqualToString:@""]) && (![self.currentSSOID isEqualToString:@""]))
    {
        body = [NSString stringWithFormat:@"%@\n\nMy Environment\nDevice: %@\niOS: %@\nApp: %@ %@\nCarrier: %@\nNetwork: %@\nAccount: %@\nAccount ID: %@",
              _descriptionTextView.text,
              [self _platformString],
              [UIDevice currentDevice].systemVersion, 
              [self _appName],
              [self _appVersion],
              [self _carrierName],
              [self _networkinfo],
              self.currentUserName,
              self.currentSSOID,
              nil];

    } else
    {
        body = [NSString stringWithFormat:@"%@\n\nMy Environment\nDevice: %@\niOS: %@\nApp: %@ %@\nCarrier: %@\nNetwork: %@",
                      _descriptionTextView.text,
                      [self _platformString],
                      [UIDevice currentDevice].systemVersion, 
                      [self _appName],
                      [self _appVersion],
                      [self _carrierName],
                      [self _networkinfo],
                      nil];

    
    }
    return body;
}

- (NSString*)_selectedTopic
{

    return [_topics objectAtIndex:_selectedTopicsIndex];
}

- (NSString*)_selectedTopicToSend
{
    return [_topicsToSend objectAtIndex:_selectedTopicsIndex];
}

- (NSString*)_appBundleName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:
            @"CFBundleName"];
}

- (NSString*)_appName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:
            @"CFBundleDisplayName"];
}

- (NSString*)_appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

// Codes are from 
// http://stackoverflow.com/questions/448162/determine-device-iphone-ipod-touch-with-iphone-sdk
// Thanks for sss and UIBuilder
- (NSString *) _platform
{
    int mib[2];
    size_t len;
    char *machine;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    machine = malloc(len);
    sysctl(mib, 2, machine, &len, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSASCIIStringEncoding];
    free(machine);
    return platform;
}

- (NSString *) _platformString
{
    NSString *platform = [self _platform];
    NSLog(@"%@",platform);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
   
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5";
    
    //Beau
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,3"]) return @"iPhone 5S";

    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad 4 (CDMA)";
    if ([platform isEqualToString:@"i386"])   return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])   return @"iPhone Simulator";

    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini";
    
    return platform;
}

#pragma mark - Block Rotate Device

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)shouldAutorotate
{
    return NO;
}


//UIApplicationInvalidInterfaceOrientation', reason: 'preferredInterfaceOrientationForPresentation must return a supported interface orientation

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

// Tell the system which initial orientation we want to have
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return 1;
}


@end
