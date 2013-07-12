//
//  MPCLApplication.h
//  MPCLApplication
//
//  Copyright (c) 2013 Matthias Plappert <matthiasplappert@me.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software
//  and associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute,
//  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>


/// This function is called in the \c main entry point to create the application object and
/// the application delegate and set up the run loop.
/// \param argc The count of arguments in \c argv; this usually is the corresponding parameter to
/// \c main.
/// \param argv A variable list of arguments; this usually is the corresponding parameter to \c main.
/// \param principalClassName The name of the \c MPCLApplication class or subclass.
/// If you specify nil, MPCLApplication is assumed.
/// \param delegateClassName The name of the class from which the application delegate is
/// instantiated.
/// The class named \c delegateClassName must conform to the \c MPCLApplicationDelegate protocol.
/// \returns Even though an integer return type is specified, this function never returns.
extern int MPCLApplicationMain(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName);


// Forward declaration.
@protocol MPCLApplicationDelegate;


/// \brief The \c MPCLApplication class provides a centralized point of control and coordination
/// for command line applications.
///
/// Every application must have exactly one instance of \c MPCLApplication (or a subclass). When an
/// application is launched, the \c MPCLApplicationMain function is called; among its other tasks,
/// this function creates a singleton \c MPCLApplication object. Thereafter you can access this
/// object by invoking the \c sharedApplication class method.
///
/// The application object is typically assigned a delegate, an object that the application informs
/// of significant runtime events—for example, application launch and application termination—giving
/// it an opportunity to respond appropriately.
@interface MPCLApplication : NSObject

/// \brief Returns the singleton application instance.
/// \returns The application instance is created in the \c MPCLApplicationMain function.
+ (instancetype)sharedApplication;

/// The delegate of the application object.
@property (nonatomic, assign) id <MPCLApplicationDelegate> delegate;

/// \brief The binary path of an application.
/// This path points to the binary file that is currently running. It is usually part of \c argv and
/// extracted by \c MPCLApplicationMain.
@property (nonatomic, copy, readonly) NSString *binaryPath;

/// \brief Starts the main event loop.
- (void)run;

/// \brief Terminates the application.
/// When invoked, this method performs several steps to process the termination request. First, it
/// calls the delegate's \c applicationShouldTerminate: method. If \c applicationShouldTerminate:
/// returns \c NO, termination process is aborted and control is handed back to the main event loop.
/// If the method returns \c YES, the application calls the delegate's \c applicationWillTerminate:
/// method and terminates the application.
- (void)terminate;

@end


/// The \c MPCLApplicationDelegate protocol declares methods that are implemented by the delegate of
/// the singleton \c MPCLApplication object. These methods provide you with information about key
/// events in an application's execution such as when it finished launching and when it terminates.
/// Implementing these methods gives you a chance to respond to these system events and respond
/// appropriately.
@protocol MPCLApplicationDelegate <NSObject>

/// \brief Tells the delegate that the launch process is almost done and the app is almost ready to run.
/// You should use this method to complete your app’s initialization, to retrieve the launch arguments
/// and to make any final tweaks.
/// \param application The delegating application object.
/// \param arguments The launch arguments represented as an array containing \c NSString elements.
/// The usual path to the binary is not part of this array but can be accessed via the \c binaryPath
/// property.
/// \returns \c NO if the application cannot handle the launch arguments, otherwise return YES.
- (BOOL)application:(MPCLApplication *)application didFinishLaunchingWithArguments:(NSArray *)arguments;

@optional

/// \brief Sent to notify the delegate that the application is about to terminate.
/// This method is called after the \c terminate method has been called. Generally, you should return
/// \c YES to allow the termination to complete, but you can cancel the termination as needed.
/// \param application The delegating application object.
/// \returns \c YES to terminate the application, \c NO to cancel the termination process.
- (BOOL)applicationShouldTerminate:(MPCLApplication *)application;

/// \brief Tells the delegate when the application is about to terminate.
/// \param application The delegating application object.
- (void)applicationWillTerminate:(MPCLApplication *)application;

@end
