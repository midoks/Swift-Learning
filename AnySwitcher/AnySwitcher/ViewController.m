#import "ViewController.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setRepresentedObject:(id)representedObject
{
    [super setRepresentedObject:representedObject];
}

- (IBAction)onOpenAnySourceButtonHandler:(id)sender
{
    [self runProcessAsAdmin:@"/usr/sbin/spctl" arguments:[NSArray arrayWithObjects:@"--master-disable", nil]];
}

- (IBAction)onCloseAnySourceButtonHandler:(id)sender
{
    [self runProcessAsAdmin:@"/usr/sbin/spctl" arguments:[NSArray arrayWithObjects:@"--master-enable", nil]];
}

- (IBAction)onStartApacheButtonHandler:(id)sender
{
    [self runProcessAsAdmin:@"/usr/sbin/apachectl" arguments:[NSArray arrayWithObjects:@"-k", @"start", nil]];
}

- (IBAction)onRestartApacheButtonHandler:(id)sender
{
    [self runProcessAsAdmin:@"/usr/sbin/apachectl" arguments:[NSArray arrayWithObjects:@"-k", @"restart", nil]];
}

- (IBAction)onStopApacheButtonHandler:(id)sender
{
    [self runProcessAsAdmin:@"/usr/sbin/apachectl" arguments:[NSArray arrayWithObjects:@"-k", @"stop", nil]];
}

- (IBAction)onResetOpenwithButtonHandler:(id)sender
{
    [self runProcess:@"/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister"
           arguments:[NSArray arrayWithObjects:@"-kill", @"-r", @"-domain", @"local", @"-domain", @"user", nil]];
    [self runProcess:@"/usr/bin/killall" arguments:[NSArray arrayWithObjects:@"Finder", nil]];
}

- (IBAction)onFlushDnsCacheButtonHandler:(id)sender
{
    [self runProcess:@"/usr/bin/dscacheutil" arguments:[NSArray arrayWithObjects:@"-flushcache", nil]];
}

- (void)runProcess:(NSString* )path arguments:(NSArray* )arguments
{
    NSTask* task = [[NSTask alloc] init];
    [task setLaunchPath:path];
    [task setArguments:arguments];
    [task launch];
}

- (void)runProcessAsAdmin:(NSString* )path arguments:(NSArray* )arguments
{
    NSString* args = [arguments componentsJoinedByString:@" "];
    NSString* script = [NSString stringWithFormat:@"%@ %@", path, args];
    NSString* fullScript = [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", script];
    
    NSAppleScript* appleScript = [[NSAppleScript new] initWithSource:fullScript];
    [appleScript executeAndReturnError:nil];
}

@end
