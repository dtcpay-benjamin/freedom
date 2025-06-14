//
//  SHTMnieViewController.m
//  seaHorseTheater
//
//  Created by 褚红彪 on 2/25/25.
//

#import "SHTMineViewController.h"
#import "SHTDeviceIDManager.h"
#import "SHTStringFormatter.h"

@interface SHTMineViewController ()

@property(nonatomic, strong)NSString *membershipID;

@end

@implementation SHTMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SHT_BACK_COLOR;
    NSLog(@"Member Ship ID:%@", self.membershipID);
}

#pragma mark - 懒加载
- (NSString *)membershipID {
    if (!_membershipID) {
        _membershipID = [SHTStringFormatter formatString:[SHTDeviceIDManager getDeviceID] fromStart:NO length:12 caseOption:StringCaseOptionLowercase];
    }
    return _membershipID;
}
@end
