# MPCLApplication
MPCLApplication is a simple framework that makes bootstrapping command line applications on OS X a one-liner and just
as easy as bootstrapping an AppKit or UIKit application. Here's how your main.m will look like:

    @autoreleasepool {
        return MPCLApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }

All that's left to do is to implement your AppDelegate, like you would with any AppKit or UIKit application.

# How To Get Started
1. [Download MPCLApplication](https://github.com/matthiasplappert/MPCLApplication/archive/master.zip).
2. Add MPCLApplication.h and MPCLApplication.m to your project.
3. Implement MPCLApplicationMain as shown above.
4. Implement your AppDelegate.
5. Compile and run your application.

This repository also comes with a small example project that should be self-explanatory.

# Why Do I Need This?
First of all: a lot of small command line scripts won't need this. However, if your CL application implements
asynchronous features, needs a run loop (e.g. if you use NSStream) or simply shouldn't terminate immediately after
executing main, this framework is for you.

# License
MPCLApplication is available under the MIT license. See the LICENSE file for more info.
