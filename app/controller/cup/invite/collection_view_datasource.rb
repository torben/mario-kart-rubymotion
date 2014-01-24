module Invite
  module CollectionViewDatasource
    def numberOfSectionsInCollectionView(collectionView)
      1
    end

    def collectionView(collectionView, numberOfItemsInSection:section)
      @users.length
    end

    def collectionView(collectionView, cellForItemAtIndexPath:indexPath)
      user = users[indexPath.row]

      cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath:indexPath)

      cell.image_view.load_async_image user.avatar_url
      cell.name_label.text = user.nickname
      cell.points_label.text = "#{user.total_points} Punkte"

      cell
    end

    def collectionView(collectionView, layout: collectionViewLayout, sizeForItemAtIndexPath:indexPath)
      CGSizeMake(100, 145)
    end

    def collectionView(collectionView, layout:collectionViewLayout, insetForSectionAtIndex:section)
      [15,10,15,10]
    end

    def collectionView(collectionView, layout: collectionViewLayout, minimumInteritemSpacingForSectionAtIndex: section)
      0
    end

    def collectionView(collectionView, layout:collectionViewLayout, minimumLineSpacingForSectionAtIndex: section)
      0
    end
  end
end