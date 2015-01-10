//
//  TITableDataSourceWrapper.h
//  touchin-rateme
//
//  Created by Tony Larin on 09/01/15.
//
//

#import <Foundation/Foundation.h>

@protocol TIRateMeDelegate
- (void) finished;
@end

@interface TIRateMeTableWrapper : NSObject<UITableViewDataSource, UITableViewDelegate, TIRateMeDelegate>

@property (weak, readonly) id<UITableViewDataSource> wrappedDataSource;
@property (weak, readonly) id<UITableViewDelegate> wrappedDelegate;

- (TIRateMeTableWrapper*) initWithDataSource:(id<UITableViewDataSource>) dataSource
                      tableDelegate:(id<UITableViewDelegate>) delegate
                         shouldShow:(bool (^)(void))shouldShow;

@end
