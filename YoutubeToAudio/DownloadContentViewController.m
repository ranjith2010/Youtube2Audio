//
//  DownloadContentViewController.m
//  YoutubeToAudio
//
//  Created by ranjith on 17/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "DownloadContentViewController.h"
#import "DownloadContentTableViewCell.h"
#import "ZPHttpAPIClient.h"
#import "AFNetworking.h"

#import <UNIRest.h>
#import <AudioToolbox/AudioToolbox.h>
@import AVFoundation;

@interface DownloadContentViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic) NSMutableData *responseData;

@property (weak, nonatomic) IBOutlet UIImageView *videoThumnailView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *channelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *publishedAtLabel;

@property (nonatomic)id<ZPHttpAPIClientProtocol>zphttpClient;

@property (nonatomic,strong) NSArray *dataSource;

@end

@implementation DownloadContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.zphttpClient = [ZPHttpAPIClient sharedInstance];
    
    self.videoThumnailView.image = self.model.videoImage;
    self.channelTitleLabel.text = self.model.channelTitle;
    self.publishedAtLabel.text = self.model.publishedAt;
    self.title = self.model.title;
    
    UINib* cellNib = [UINib nibWithNibName:@"DownloadContentTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"DownloadContentTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self fetchVideoUrl];
}

- (void)fetchVideoUrl {
    self.tableView.hidden = YES;
    
    // These code snippets use an open-source library. http://unirest.io/objective-c
    NSDictionary *headers = @{@"X-Mashape-Key": @"FAhSz7kJnqmshDd5reChMrR30TwEp1BHToijsnUTEqlHEjPMX4", @"Content-Type": @"application/x-www-form-urlencoded", @"Accept": @"application/json"};
    NSDictionary *parameters = @{@"url": [NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",self.model.videoId]};
    UNIUrlConnection *asyncConnection = [[UNIRest post:^(UNISimpleRequest *request) {
        [request setUrl:@"https://savedeo.p.mashape.com/download"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
//        NSInteger code = response.code;
//        NSDictionary *responseHeaders = response.headers;
//        UNIJsonNode *body = response.body;
        NSData *rawBody = response.rawBody;
        
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:rawBody
                                                             options:kNilOptions
                                                               error:&error];
        
        NSArray *items = json[@"formats"];
        
        NSMutableArray *buffer = [NSMutableArray new];
        
        for(NSDictionary *item in items) {
            DownloadDataModel *model = [[DownloadDataModel alloc]initWithServerDictionary:item];
            [buffer addObject:model];
        }
        
        if(!self.dataSource) {
            self.dataSource = [NSArray arrayWithArray:buffer];
        }
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           self.tableView.hidden = NO;
                           [self.tableView reloadData];
                           
                       });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Supported File Formats";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownloadContentTableViewCell *downloadTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"DownloadContentTableViewCell" forIndexPath:indexPath];
    DownloadDataModel *model = [self.dataSource objectAtIndex:indexPath.row];
    
    [downloadTableViewCell feedCellWithObject:model];
    
    [downloadTableViewCell setDidTapButtonBlock:^(id sender) {
        [self buttonActionWithIndexPath:model];
    }];
    
    return downloadTableViewCell;
}

- (void)buttonActionWithIndexPath:(DownloadDataModel *)downloadModel {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:downloadModel.downloadUrl]];
    AFURLConnectionOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
 __block NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",self.model.title,downloadModel.extension]];
    
    NSLog(@"%@",filePath);
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        NSLog(@"%f",(float)totalBytesRead / totalBytesExpectedToRead);
    }];
    
    [operation setCompletionBlock:^{
        NSLog(@"downloadComplete!");
    }];
    [operation start];
    
}

@end
