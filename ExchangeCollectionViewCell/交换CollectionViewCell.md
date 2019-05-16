
### 第一步：添加长按手势

```Objective-C
UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
[self.collectionView addGestureRecognizer:longPress];
```
### 第二步：长按手势实现

```Objective-C
- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    UIGestureRecognizerState status = sender.state;
    CGPoint p = [sender locationInView:self.collectionView];

    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];

    if (!indexPath && (status == UIGestureRecognizerStateChanged || status == UIGestureRecognizerStateBegan)) return;

    //获取cell用来做动画
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];

    switch (status) {
        case UIGestureRecognizerStateBegan:
        {

            if (@available(iOS 9.0, *)) {
                NSLog(@"%d",[self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath]);
                NSLog(@"beginInteractiveMovementForItemAtIndexPath");
            } else {
                // Fallback on earlier versions
            }
            [UIView animateWithDuration:0.2 animations:^{
                cell.transform = CGAffineTransformScale(cell.transform, 0.8, 0.8);
            }];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            if (@available(iOS 9.0, *)) {
                [self.collectionView updateInteractiveMovementTargetPosition:p];
                NSLog(@"updateInteractiveMovementTargetPosition");
            } else {
                // Fallback on earlier versions
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (@available(iOS 9.0, *)) {
                [self.collectionView endInteractiveMovement];
                NSLog(@"endInteractiveMovement");
            } else {
                // Fallback on earlier versions
            }
            [UIView animateWithDuration:0.2 animations:^{
                cell.transform = CGAffineTransformIdentity;
            }];

        }
            break;
        default:
        {
            if (@available(iOS 9.0, *)) {
                [self.collectionView cancelInteractiveMovement];
                NSLog(@"cancelInteractiveMovement");
            } else {
                // Fallback on earlier versions
            }
            [UIView animateWithDuration:0.2 animations:^{
                cell.transform = CGAffineTransformIdentity;
            }];
        };
            break;
    }
}

```

### 代理方法实现
```Objective-C
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {

    // 交换数据
//    [_selectedTagsArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];

}
```
