//
//  AppDelegate.m
//  MPCLApplicationExample
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

#import "AppDelegate.h"


@interface AppDelegate () <NSURLConnectionDelegate>

@property (nonatomic, assign) BOOL loading;
@property (nonatomic, strong) NSHTTPURLResponse *response;
@property (nonatomic, strong) NSMutableData *data;

@end


@implementation AppDelegate

- (BOOL)application:(MPCLApplication *)application didFinishLaunchingWithArguments:(NSArray *)arguments;
{
    if ([arguments count] == 0) {
        printf("Too few arguments.\n");
        [application terminate];
        return NO;
    }
    
    NSString *URLString = [arguments objectAtIndex:0];
    NSURL *URL = [NSURL URLWithString:URLString];
    
    printf("Downloading %s...\n\n", [URLString cStringUsingEncoding:NSUTF8StringEncoding]);
    self.loading = YES;
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL:URL] delegate:self];
    
    return YES;
}

- (BOOL)applicationShouldTerminate:(MPCLApplication *)application;
{
    return (!self.loading);
}

- (void)applicationWillTerminate:(MPCLApplication *)application;
{
    printf("Application is terminating...\n");
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response;
{
    self.response = response;
    self.data = [NSMutableData data];
    
    printf("Did receive HTTP response: %li\n", (long)[response statusCode]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    [self.data appendData:data];
    
    printf("Download progress: %.2f%%\n", (float)[self.data length] / (float)[self.response expectedContentLength] * 100.0f);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    printf("\nDid finish download.\n");
    
    self.loading = NO;
    [[MPCLApplication sharedApplication] terminate];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    printf("\nDownload did fail: %s\n", [[error localizedDescription] cStringUsingEncoding:NSUTF8StringEncoding]);
    
    self.loading = NO;
    [[MPCLApplication sharedApplication] terminate];
}

@end
