#import "MSMockReachabilityUtil.h"
#import "MSTestFrameworks.h"

static NSString *kMSNetworkReachabilityChangedNotificationName = @"kMSNetworkReachabilityChangedNotification";

@interface MSMockReachabilityUtil ()

@property(nonatomic) id mockReachabilityUtil;

@end

@implementation MSMockReachabilityUtil

@synthesize currentNetworkStatus = _currentNetworkStatus;

- (instancetype)init {
  self = [super init];
  if (self) {
    
      // Mock MS_Reachability shared method to return this instance.
      _mockReachabilityUtil = OCMClassMock([MS_Reachability class]);
      OCMStub([_mockReachabilityUtil reachabilityForInternetConnection]).andReturn(_mockReachabilityUtil);
      OCMStub([_mockReachabilityUtil currentReachabilityStatus]).andDo(^(NSInvocation *invocation) {
        NetworkStatus status = self->_currentNetworkStatus;
        [invocation setReturnValue:&status];
      });
      OCMStub([_mockReachabilityUtil startNotifier]).andDo(^(__unused NSInvocation *invocation) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kMSNetworkReachabilityChangedNotificationName
                                                            object:self->_mockReachabilityUtil];
      });
  }
  return self;
}

- (void)stopMocking {
  [self.mockReachabilityUtil stopMocking];
}

@end
