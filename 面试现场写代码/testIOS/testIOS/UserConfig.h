//
//  userConfig.h
//  testIOS
//
//  Created by alfredking－cmcc on 2021/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserConfig : NSObject
@property(nonatomic,strong)NSMutableString *userName;
@property(nonatomic,strong)NSMutableString *font;
@property(nonatomic,strong)NSMutableString *backGrround;
@property(nonatomic,assign)Boolean isDarkMode;
enum sychronizeStatus;

-(BOOL)writeToDisk;

//上传配置首先要把配置持久化
-(void)sychronize;

//- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

@end

NS_ASSUME_NONNULL_END
