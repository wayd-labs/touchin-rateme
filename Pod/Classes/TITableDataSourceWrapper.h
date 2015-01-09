//
//  TITableDataSourceWrapper.h
//  touchin-rateme
//
//  Created by Tony Larin on 09/01/15.
//
//

#import <Foundation/Foundation.h>

@interface TITableDataSourceWrapper : NSObject<UITableViewDataSource, UITableViewDelegate>

@property (weak, readonly) id<UITableViewDataSource> wrappedDataSource;
@property (weak, readonly) id<UITableViewDelegate> wrappedDelegate;

- (TITableDataSourceWrapper*) initWithDataSource:(id<UITableViewDataSource>) dataSource delegate:(id<UITableViewDelegate>) delegate;

@end
