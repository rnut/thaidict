//
//  TMSpashScreen.h
//  TMTrueMoveOnly
//
//  Created by Jerapong Nampetch on 9/20/54 BE.
//  Copyright (c) 2554 True Digial and Media Content. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Current version 1.0
// update By Mon build xcode 6
typedef void (^TMBasicBlock)();

@protocol TMSplashScreenDelegate;

/**
 The TMSplashScreen is helper for display TrueLife+ splash screen when application launch in easy way for all apple device platforms (iPhone3+, iPad).
 
 @warning Don't forget add "SplashScreen.bundle" to your project and do not change file name inside. It's have effect for display.
 */

@interface TMSplashScreen : NSObject

/// ================
/// @name Properties
/// ================

/**
 State of playing animation finished or not.
 
 @return Boolean value of display state.
 */

@property (nonatomic, readonly) BOOL isPlayingAnimation;

/// ===================
/// @name Class methods
/// ===================

/**
 Version number of TMSplashScreen.
 
 @return string of version number.
 */

+ (NSString *)currentVersion;

/**
 Instance of class method.
 
 @return object of class method.
 */

+ (TMSplashScreen *)sharedInstance;

/** 
 Method for animate official splash screen when application launch.
 
 @param window Key & visible window of application.
 @param delegate Object implemented delegate method.
 
 @warning Call this method after you set application key window.
 */

+ (void)animateSplashScreenOnWindow:(UIWindow *)window delegate:(id <TMSplashScreenDelegate> )delegate;

/** 
 Method for animate official True's splash screen at application launch for block supported project.
 
 @param window Application's window.
 @param block Operation block for do action when animation finished.
 
 @warning window must been key and visible window.
 */

+ (void)animateSplashScreenOnWindow:(UIWindow *)window withOperationBlock:(void (^)(BOOL finished))block;

/**
 Method for animate official True's splash screen when application launch with support loading state and complete state in version 2.0
 
 @param window Application's window to temporary render splashscreen on.
 @param loadBlock TMBasicBlock implemented when splashscreen becoming to loading state.
 @param completeBlock TMBasicBlock implemented when splashscreen finished.
 
 */

+ (void)animateSplashScreenOnWindow:(UIWindow *)window loadingStateBlock:(TMBasicBlock)loadBlock completeBlock:(TMBasicBlock)completeBlock;

@end

/**
 TMSplashScreen defined for support to perform action for each working state.
 */

@protocol TMSplashScreenDelegate

@optional

/**
 Addition implementation when splash screen becoming to loading state except from access blocking module.
 
 You should not initailize too much in this phrase, It's cause of application launch slow. It's should be
 'important initialize or request' only.
 
 @warning If have connection in this phrase, MUST use 'synchronous' request and not custom thread or any GCD queue.
*/

- (void)splashScreenBecomeLoadingState;

/**
 Action after splashScreen play finished.
*/

- (void)splashScreenDidPlayFinished;

/**
 Custom splash screen orientation.
 */

- (UIInterfaceOrientation)splashScreenOrientation;

@end



@interface TMSplashScreen (tmo20)

@end