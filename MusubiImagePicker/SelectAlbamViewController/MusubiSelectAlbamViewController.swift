//
//  MusubiSelectAlbamViewController.swift
//  MusubiImagePicker
//
//  Created by ST20591 on 2017/11/06.
//  Copyright © 2017年 はるふ. All rights reserved.
//

import UIKit
import Photos

protocol MusubiSelectAlbamViewControllerDelegate: class {
    func selectAlbamViewController(didSelect collection: PHAssetCollection?)
}

class AlbamCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
}

// Similar to MasterViewController in Example
class MusubiSelectAlbamViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    var allPhotos: PHFetchResult<PHAsset>!
    var smartAlbums: PHFetchResult<PHAssetCollection>!
    var userCollections: PHFetchResult<PHCollection>!
    weak var delegate: MusubiSelectAlbamViewControllerDelegate?
    
    let sectionLocalizedTitles = ["", NSLocalizedString("Smart Albums", comment: ""), NSLocalizedString("Albums", comment: "")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a PHFetchResult object for each section in the table view.
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
        smartAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
        userCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        PHPhotoLibrary.shared().register(self)
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension MusubiSelectAlbamViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Types for managing sections, cell and segue identifiers
    enum Section: Int {
        case allPhotos = 0
        case smartAlbums
        case userCollections
        
        static let count = 3
    }
    
    private var cellIdentifier: String {
        return "AlbamCell"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch Section(rawValue: indexPath.section) ?? Section.allPhotos {
        case .allPhotos:
            delegate?.selectAlbamViewController(didSelect: nil)
        case .smartAlbums:
            let collection = smartAlbums.object(at: indexPath.row)
            delegate?.selectAlbamViewController(didSelect: collection)
        case .userCollections:
            let collection = userCollections.object(at: indexPath.row)
            delegate?.selectAlbamViewController(didSelect: collection as? PHAssetCollection)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section)! {
        case .allPhotos: return 1
        case .smartAlbums: return smartAlbums.count
        case .userCollections: return userCollections.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section)! {
        case .allPhotos:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AlbamCell
            cell?.titleLabel.text = NSLocalizedString("All Photos", comment: "")
            cell?.countLabel.text = ""
            return cell ?? UITableViewCell()
            
        case .smartAlbums:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AlbamCell
            let collection = smartAlbums.object(at: indexPath.row)
            cell?.titleLabel.text = collection.localizedTitle
            cell?.countLabel.text = "\(PHAsset.fetchAssets(in: collection, options: nil).count)"
            return cell ?? UITableViewCell()
            
        case .userCollections:
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AlbamCell
            let collection = userCollections.object(at: indexPath.row)
            cell?.titleLabel.text = collection.localizedTitle
            if let collection = collection as? PHAssetCollection {
                cell?.countLabel.text = "\(PHAsset.fetchAssets(in: collection, options: nil).count)"
            }
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionLocalizedTitles[section]
    }
}

// MARK: PHPhotoLibraryChangeObserver
extension MusubiSelectAlbamViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // Check each of the three top-level fetches for changes.
            
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                // Update the cached fetch result.
                allPhotos = changeDetails.fetchResultAfterChanges
                // (The table row for this one doesn't need updating, it always says "All Photos".)
            }
            
            // Update the cached fetch results, and reload the table sections to match.
            if let changeDetails = changeInstance.changeDetails(for: smartAlbums) {
                smartAlbums = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: Section.smartAlbums.rawValue), with: .automatic)
            }
            if let changeDetails = changeInstance.changeDetails(for: userCollections) {
                userCollections = changeDetails.fetchResultAfterChanges
                tableView.reloadSections(IndexSet(integer: Section.userCollections.rawValue), with: .automatic)
            }
            
        }
    }
}
