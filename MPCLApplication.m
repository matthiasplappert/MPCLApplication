//
//  MPCLApplication.m
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

#import "MPCLApplication.h"


@interface MPCLApplication ()

@property (nonatomic, copy, readwrite) NSString *binaryPath;
@property (nonatomic, copy, readwrite) NSArray *arguments;

- (id)_init;

@end


@implementation MPCLApplication

+ (instancetype)sharedApplication;
{
    static MPCLApplication *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MPCLApplication alloc] _init];
    });
    return sharedInstance;
}

- (id)init;
{
    [NSException raise:NSInternalInconsistencyException format:@"Do not instanciate an MPCLApplication directly. Use +sharedApplication instead."];
    return nil;
}

- (id)_init;
{
    self = [super init];
    return self;
}

#pragma mark - Running and Terminating

- (void)run;
{
    // Launch the application.
    [self.delegate application:self didFinishLaunchingWithArguments:self.arguments];
    
    // Configure run loop. Add a timer that will never fire to the current run loop. This will
    // serve as a first run loop source.
    NSRunLoop *runLoop = [NSRunLoop mainRunLoop];
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:[NSDate distantFuture] interval:0.0f target:nil selector:NULL userInfo:nil repeats:NO];
    [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    
    // Run it.
    [runLoop run];
}

- (void)terminate;
{
    // Check if we are allowed to terminate at this point.
    if ([self.delegate respondsToSelector:@selector(applicationShouldTerminate:)]) {
        if (![self.delegate applicationShouldTerminate:self]) {
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(applicationWillTerminate:)]) {
        [self.delegate applicationWillTerminate:self];
    }
    exit(0);
}

@end


int MPCLApplicationMain(int argc, char *argv[], NSString *principalClassName, NSString *delegateClassName)
{
    // Figure out principal class.
    Class principalClass = NSClassFromString(principalClassName);
    if (!principalClass) {
        principalClass = [MPCLApplication class];
    }
    NSCAssert([principalClass isSubclassOfClass:[MPCLApplication class]], @"principalClassName must reference a subclass of MPCLApplication.");
    
    // Figure out delegate class.
    Class delegateClass = NSClassFromString(delegateClassName);
    NSCAssert(delegateClass, @"delegateClassName must reference an existing class.");
    NSCAssert([delegateClass conformsToProtocol:@protocol(MPCLApplicationDelegate)], @"delegateClassName must reference a class that conforms to <MPCLApplicationDelegate>.");
    
    // Parse the command line arguments.
    NSCAssert(argc >= 1, @"Expected at least one argument, which should be the path to the application binary.");
    
    // Transform arguments into NSStrings.
    NSString *binaryPath = [NSString stringWithCString:argv[0] encoding:NSUTF8StringEncoding];
    NSArray *arguments = nil;
    if (argc > 1) {
        NSString *strings[argc - 1];
        for (NSUInteger i = 1; i < argc; i++) {
            strings[i - 1] = [NSString stringWithCString:argv[i] encoding:NSUTF8StringEncoding];
        }
        arguments = [NSArray arrayWithObjects:strings count:argc];
    }
    
    // Create delegate.
    id <MPCLApplicationDelegate> delegate = [[delegateClass alloc] init];
    NSCAssert(delegate, @"Couldn't instanciate delegate.");
    
    // Create and launch the application.
    MPCLApplication *application = [principalClass sharedApplication];
    application.delegate = delegate;
    application.arguments = arguments;
    application.binaryPath = binaryPath;
    [application run];
    
    return 0;
}
