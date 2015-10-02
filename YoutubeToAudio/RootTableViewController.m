//
//  RootTableViewController.m
//  YoutubeToAudio
//
//  Created by ranjith on 17/09/15.
//  Copyright © 2015 ranjith. All rights reserved.
//

#import "RootTableViewController.h"
#import "VideoTableViewCell.h"
#import "MBProgressHUD.h"
#import "DownloadContentViewController.h"
#import "ZPHttpAPIClient.h"
#import "ZPHttpClientAF.h"

#import "RKNetworkClient.h"
#import "RKNeworkEngine.h"


@interface RootTableViewController ()<NSURLConnectionDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic) NSMutableData *responseData;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,strong) NSMutableArray *dataShown;
@property (nonatomic) int fetchCount;

@property (nonatomic)BOOL needToAppend;
@property (nonatomic,weak)id<ZPHttpAPIClientProtocol> ZPHttpClient;

@property (nonatomic)BOOL isPopularSearch;


@property (nonatomic,weak)id<RKHTTPClientProtocol> RKHttpClient;

@end

@implementation RootTableViewController
@synthesize pendingOperations = _pendingOperations;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fetchCount = 10;
    
    UINib* cellNib = [UINib nibWithNibName:@"VideoTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"VideoTableViewCell"];
    self.searchBar.delegate = self;
    
    // add some data regarding popular videos
    [self pr_initialDataSetup];
    
//MARK:: add it later.
//    [self addLongPressGesture];
    
}

- (void)pr_initialDataSetup {
    if(!self.RKHttpClient) {
        self.RKHttpClient = [RKNetworkClient sharedInstance];
    }
    id requestOperation = [self.RKHttpClient fetchMostPopularVideosWithFetchCount:self.fetchCount isFreshQuery:YES :^(NSArray *models, NSError *error) {
        self.dataSource = [NSMutableArray arrayWithArray:models];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isPopularSearch = YES;
            [self.tableView reloadData];
        });
    }];
    [self.pendingOperations.downloadQueue addOperation:requestOperation];
}

- (void)viewDidUnload {
//    [self setPhotos:nil];
    [self setPendingOperations:nil];
    [super viewDidUnload];
}


// If app receive memory warning, cancel all operations
- (void)didReceiveMemoryWarning {
    [self cancelAllOperations];
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kCellIdentifier = @"VideoTableViewCell";
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];

    if (!cell) {
        cell = [[VideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        cell.accessoryView = activityIndicatorView;
        
    }
    
    DataModel *aRecord = [self.dataSource objectAtIndex:indexPath.row];
    
    if (aRecord.hasImage) {
        
        [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cell.thumbnailImage.image = aRecord.videoImage;
        cell.title.text = aRecord.title;
    }
    else if (aRecord.isFailed) {
        [((UIActivityIndicatorView *)cell.accessoryView) stopAnimating];
        cell.thumbnailImage.image = [UIImage imageNamed:@"Failed.png"];
        cell.title.text = @"Failed to load";
        
    }
    else {
        
        [((UIActivityIndicatorView *)cell.accessoryView) startAnimating];
        cell.thumbnailImage.image = [UIImage imageNamed:@"default_image.png"];
        cell.title.text = @"";
//        [self startOperationsForPhotoRecord:aRecord atIndexPath:indexPath];
        if (!tableView.dragging && !tableView.decelerating) {
            [self startOperationsForPhotoRecord:aRecord atIndexPath:indexPath];
        }
    }
    [cell.mediaIndexLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
    cell.mediaIndexLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    cell.DescriptionLabel.text = aRecord.videoDescription;
    if(aRecord.videoDuration){
        cell.mediaDurationLabel.text = aRecord.videoDuration;
    }
    else {
        [cell.mediaDurationLabel setHidden:YES];
        id downloadRequestOperation = [self.RKHttpClient fetchVideoDetails:aRecord :^(DataModel *dataModel, NSError *error) {
            [cell.mediaDurationLabel setHidden:NO];
            cell.mediaDurationLabel.text = dataModel.videoDuration;
            aRecord.videoDuration = dataModel.videoDuration;
            
        }];
        [self.pendingOperations.downloadQueue addOperation:downloadRequestOperation];
    }
    if(indexPath.row==self.dataSource.count-1) {
        // It except more data. Fetch some more data.
        self.needToAppend = YES;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        if(self.isPopularSearch) {
          id requestOperation  = [self.RKHttpClient fetchMostPopularVideosWithFetchCount:self.fetchCount isFreshQuery:NO  :^(NSArray *models, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self loadData:models];
            }];
            [self.pendingOperations.downloadQueue addOperation:requestOperation];
        }
        else {
       id requestOperation = [self.RKHttpClient fetchYoutubeVideosWithSearchQuery:nil isFreshQuery:NO fetchCount:self.fetchCount :^(NSArray *models, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self loadData:models];
                    }];
            [self.pendingOperations.downloadQueue addOperation:requestOperation];
        }
    }
    return cell;
}


#pragma mark -
#pragma mark - UIScrollView delegate
    
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self suspendAllOperations];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnscreenCells];
        [self resumeAllOperations];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenCells];
    [self resumeAllOperations];
}

#pragma mark - Cancelling, suspending, resuming queues / operations

- (void)suspendAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:YES];
    [self.pendingOperations.filtrationQueue setSuspended:YES];
}

- (void)resumeAllOperations {
    [self.pendingOperations.downloadQueue setSuspended:NO];
    [self.pendingOperations.filtrationQueue setSuspended:NO];
}

- (void)cancelAllOperations {
    [self.pendingOperations.downloadQueue cancelAllOperations];
    [self.pendingOperations.filtrationQueue cancelAllOperations];
}

- (void)loadImagesForOnscreenCells {
    
    // 1
    NSSet *visibleRows = [NSSet setWithArray:[self.tableView indexPathsForVisibleRows]];
    
    // 2
    NSMutableSet *pendingOperations = [NSMutableSet setWithArray:[self.pendingOperations.downloadsInProgress allKeys]];
    [pendingOperations addObjectsFromArray:[self.pendingOperations.filtrationsInProgress allKeys]];
    
    NSMutableSet *toBeCancelled = [pendingOperations mutableCopy];
    NSMutableSet *toBeStarted = [visibleRows mutableCopy];
    
    // 3
    [toBeStarted minusSet:pendingOperations];
    // 4
    [toBeCancelled minusSet:visibleRows];
    
    // 5
    for (NSIndexPath *anIndexPath in toBeCancelled) {
        
        RKImageDownloader *pendingDownload = [self.pendingOperations.downloadsInProgress objectForKey:anIndexPath];
        [pendingDownload cancel];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:anIndexPath];
        
        RKImageFiltration *pendingFiltration = [self.pendingOperations.filtrationsInProgress objectForKey:anIndexPath];
        [pendingFiltration cancel];
        [self.pendingOperations.filtrationsInProgress removeObjectForKey:anIndexPath];
    }
    toBeCancelled = nil;
    
    // 6
    for (NSIndexPath *anIndexPath in toBeStarted) {
        
        DataModel *recordToProcess = [self.dataSource objectAtIndex:anIndexPath.row];
        [self startOperationsForPhotoRecord:recordToProcess atIndexPath:anIndexPath];
    }
    toBeStarted = nil;
    
}
    

// 1
- (void)startOperationsForPhotoRecord:(DataModel *)record atIndexPath:(NSIndexPath *)indexPath {
    
    // 2
    if (!record.hasImage) {
        [self startImageDownloadingForRecord:record atIndexPath:indexPath];
        
    }
    
    if (!record.isFiltered) {
        [self startImageFiltrationForRecord:record atIndexPath:indexPath];
    }
}


- (void)startImageDownloadingForRecord:(DataModel *)record atIndexPath:(NSIndexPath *)indexPath {
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:indexPath]) {
        
        // Start downloading
        RKImageDownloader *imageDownloader = [[RKImageDownloader alloc] initWithDataModel:record atIndexPath:indexPath delegate:self];
        [self.pendingOperations.downloadsInProgress setObject:imageDownloader forKey:indexPath];
        [self.pendingOperations.downloadQueue addOperation:imageDownloader];
    }
}

- (void)startImageFiltrationForRecord:(DataModel *)record atIndexPath:(NSIndexPath *)indexPath {
    if (![self.pendingOperations.filtrationsInProgress.allKeys containsObject:indexPath]) {
        
        // Start filtration
        RKImageFiltration *imageFiltration = [[RKImageFiltration alloc] initWithDataModel:record atIndexPath:indexPath delegate:self];
        
        RKImageDownloader *dependency = [self.pendingOperations.downloadsInProgress objectForKey:indexPath];
        if (dependency)
            [imageFiltration addDependency:dependency];
        
        [self.pendingOperations.filtrationsInProgress setObject:imageFiltration forKey:indexPath];
        [self.pendingOperations.filtrationQueue addOperation:imageFiltration];
    }
}


- (void)imageDownloaderDidFinish:(RKImageDownloader *)downloader {
    NSIndexPath *indexPath = downloader.indexPathInTableView;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.pendingOperations.downloadsInProgress removeObjectForKey:indexPath];
}

- (void)imageFiltrationDidFinish:(RKImageFiltration *)filtration {
    NSIndexPath *indexPath = filtration.indexPathInTableView;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.pendingOperations.filtrationsInProgress removeObjectForKey:indexPath];
}



- (void)loadData:(NSArray *)models {
    if(self.needToAppend) {
        [self.dataSource addObjectsFromArray:models];
    }
    else {
        self.dataSource = [NSMutableArray arrayWithArray:models];
        if(!self.dataShown){
            self.dataShown = [NSMutableArray new];
        }
        else {
            [self.dataShown removeAllObjects];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DownloadContentViewController *downloadVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DownloadContentViewController"];
    [downloadVC setModel:[self.dataSource objectAtIndex:indexPath.row]];
//    DataModel *dataModel = [self.dataSource objectAtIndex:indexPath.row];
//    [self fetchVideoDuration:dataModel :^(NSString *mediaDuration) {
//        
//    }];
    [self.navigationController pushViewController:downloadVC animated:YES];
}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if(![self.dataShown containsObject:[self.dataSource objectAtIndex:indexPath.row]]) {
//        
//        [self.dataShown addObject:[self.dataSource objectAtIndex:indexPath.row]];
//        
//        CATransform3D rotationTransform = CATransform3DTranslate(CATransform3DIdentity, -500, 10, 0);
//        cell.layer.transform = rotationTransform;
//        
//        [UIView animateWithDuration:1.0 animations:^{
//            
//            cell.layer.transform = CATransform3DIdentity;
//        }];
//    }
//    
//}

#pragma mark - Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    self.needToAppend = NO;
    self.isPopularSearch = NO;

    [searchBar resignFirstResponder];
    
    NSString *replaceStr=[searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    id requestOperation = [self.RKHttpClient fetchYoutubeVideosWithSearchQuery:replaceStr isFreshQuery:YES fetchCount:self.fetchCount :^(NSArray *models, NSError *error) {

        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if(self.needToAppend) {
            [self.dataSource addObjectsFromArray:models];
        }
        else {
            self.dataSource = [NSMutableArray arrayWithArray:models];
            if(!self.dataShown){
                self.dataShown = [NSMutableArray new];
            }
            else {
                [self.dataShown removeAllObjects];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [self.pendingOperations.downloadQueue addOperation:requestOperation];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self cancelSearching];
    [self.tableView reloadData];
}

-(void)cancelSearching{
    [self.searchBar resignFirstResponder];
    self.searchBar.text  = @"";
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    // we used here to set self.searchBarActive = YES
    // but we'll not do that any more... it made problems
    // it's better to set self.searchBarActive = YES when user typed something
    [self.searchBar setShowsCancelButton:YES animated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    // this method is being called when search btn in the keyboard tapped
    // we set searchBarActive = NO
    // but no need to reloadCollectionView
    [self.searchBar setShowsCancelButton:NO animated:YES];
}


#pragma mark -


- (void)addLongPressGesture {
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 1.0; //seconds
    lpgr.delegate = self;
    [self.tableView addGestureRecognizer:lpgr];
}


-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.tableView];
    
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %ld", (long)indexPath.row);
            } else {
        NSLog(@"gestureRecognizer.state = %ld", (long)gestureRecognizer.state);
    }
}

- (RKPendingOperations *)pendingOperations {
    if (!_pendingOperations) {
        _pendingOperations = [[RKPendingOperations alloc] init];
    }
    return _pendingOperations;
}

@end
