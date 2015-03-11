//
//  TMPrivateTrueMoveOnly.h
//  TMTrueMoveOnly
//
//  Created by Jerapong Nampetch on 8/15/54 BE.
//  Copyright 2554 True Digital Content and Media. All rights reserved.
//

// Current version 3.7 build 27-12-2012

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class CTTelephonyNetworkInfo;

@protocol TMODebugKit;

/** @notification TMTrueMoveOnly TMODidReceivedResponseNotification This notification will active when recieved response from server about application service info. 
 
 You can use this notification for check type of response for specify application's action if recieved
 appication service info. eg. stop music player when received block action. remove all data when recieved
 'Not allow for this operator' description info, etc.*/

UIKIT_EXTERN const NSString *TMODidReceivedResponseNotification;

/**
 
 TMOWebsheetActivatedNotification
 
 
 This notification will active when server return action for webview
 such as Charging, Notice from server, etc. This notification attached TMWebSheetViewController's object
 in NSNotification's value. This object is based on UIViewController class. 
 
 You can catch this notification for custom manage WebSheet such as bring to front, change background color,
 force remove, etc as you want.
 */

UIKIT_EXTERN const NSString *TMOWebsheetActivatedNotification;

/**
 
 Shared method for get current phone number. Required network connection as Edge or 3g, WIFI is not work.
 
 @param forceCheck boolean value for force to get phone number form server again even have cache.
 
 @return NSString object of current phone number. It's work for True-H phone number. If is nil, maybe it's from
 other operator (AIS, DTAC, etc) or network connection at that time is over WIFI.
 
 */

UIKIT_EXTERN NSString * currentMSISDN (BOOL forceCheck);

/**
 
 Perform latest action recieved from server (alert, websheet).
 
 */

UIKIT_EXTERN void TMOPerformAccessBlockAction();

/**
 `TMTrueMoveOnly` is a class for automatic perform action on True's application which described on access block server.
 An action such as Alert for block services, message from server or force update, Charging of service, etc.
 
 All action will validate when first time of application launched and credit is lower than 0.
 */

@interface TMTrueMoveOnly : NSObject
{
    NSMutableData *responseData_;
    
@private
    
    UIWindow *appWindow_;
    NSInteger creditCount_;
    NSMutableDictionary *appInfo_;
    
    BOOL isCheckedVersion_;
    BOOL isHasCarrierCase_;
    
    NSString *carrierName_;
    NSString *countryCode_;
    
    NSDictionary *xmlDict_;

    NSMutableArray *actionList_;
}  

UIKIT_EXTERN void removeVerifiedOTP();

///-----------------------------
/// @name Class Methods
///-----------------------------

/** 
 Return version of TMTrueMoveOnly module.
 
 @return TrueMoveOnly version.
 */

+ (NSString *)currentVersion;

/** 
 Singleton object of TMTrueMoveOnly class. All action and response is happen and collected at here.
 
 @return TMTrueMoveOnly class instance.
 */

+ (TMTrueMoveOnly *)sharedInstance;

/** 
 Automatic method for check application services info from server. 
 
 @warning Call this method in your -applicationDidBecomeActive: of appDelegate in your project. No need implement others anymore.
 */

+ (void)startTrueMoveOnlyDaemon                     NS_DEPRECATED_IOS(4_0, 5_0);

/**
 Stop all activity of module and release self. Please do not forget call this method for conserve memory. 
 
 @warning Call this method in your -applicationWillTerminate: of appDelegate in your project.
 */

+ (void)stopTrueMoveOnlyDaemon                      NS_DEPRECATED_IOS(4_0, 5_0);

#pragma mark - Instance method

- (id)initWithApplicationWindow:(UIWindow *)appWindow credit:(NSInteger)credit;

/** Flag value for application is on bypass mode. 
 */

@property (nonatomic, readonly) BOOL isBypassed;

/** Mobile carrier name which mapped on server. Result is Thai mobile operator AIS/TRUE/TRUE-H/DTAC only.
 */
@property (strong, readonly) NSString * mobileOperator;

#pragma mark - Debug Protocol

@property (nonatomic, unsafe_unretained) id <TMODebugKit> debugKitDelegate;

- (void)_validateDeviceForApp;
- (void)_resetValidated;

@end


@protocol TMODebugKit

@optional

- (BOOL)debugEnable;
- (BOOL)addDismissButtonOnAlert;
- (NSString *)carrierNameSimulated;
- (NSString *)carrierNameForUnknownSimCard;
- (NSString *)countryCodeSimulated;
- (NSString *)customHostPath;
- (NSString *)appnameSimulated;

- (void)tmoSendRequestToURL:(NSString *)url;
- (void)actionForError:(NSString *)errorDescription;

@end


#pragma mark - TrueMoveOnly 2.0

@interface TMTrueMoveOnly (tmo20)

/**
 Reverify user grant to use app again after application back from background state. This action is work with asynchronously connect.
 
 @param autoPerform For specify action when received response from server to auto perform action or not.
 */
- (void)verifyOnBecomeForegroundWithAutoPerformAction:(NSNumber *)autoPerform;

/**
 Retrieve latest access blocking response received from server.
 
 @return response dictionary.
 */
- (NSDictionary *)latestVerifyResult;

/**
 Perform action for latest response from server (Alert, Action sheet).
 */
- (void)performBlockAction;

@end


#pragma mark - TrueMoveOnly 2.1

@interface TMTrueMoveOnly (tmo21)

/** 
 Return carrier name of SIM Card using.
 */

+ (NSString *)currentCarrierName;

/**
 Return country code of SIM Card using.
 */

+ (NSString *)currentCountryCode;

/**
 Return MCC Value of SIM Card using.
 */

+ (NSString *)currentMobileCountryCode;

/**
 Return MNC Value of SIM Card using.
*/
+ (NSString *)currentMobileNetworkCode;

@end