//
//  BingImagesViewMode.swift
//  CombineTest
//
//  Created by 罗树新 on 2021/1/20.
//

import UIKit
#if canImport(Combile)
import Combine
#else
import OpenCombine
#endif
class BingImagesViewModel: NSObject {
        
    var images: [BingImages.BingImage]?
        
    let bingImagesRequest = BingImagesRequest()
    
    lazy var imagePublisher: CurrentValueSubject<[BingImages.BingImage]?, Never> = {
        return CurrentValueSubject<[BingImages.BingImage]?, Never>(images)
    }()

}

// MARK:- Public
extension BingImagesViewModel {
    func requestImages() {
        bingImagesRequest.request { [unowned self] (images) in
            self.images = images
            self.imagePublisher.send(images)
        }
    }
}
 
// MARK:- UITableViewDelegate, UITableViewDataSource
extension BingImagesViewModel: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: BingImageCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? BingImageCell
        if cell == nil {
            cell = BingImageCell(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.viewModel.image = images?[indexPath.row]
        cell?.actionCancelable = cell?.viewModel.actionSubject.sink(receiveValue: { [unowned self] (action) in
            let imageLink = action.imageLink
            switch action.actionType {
            case .delete:
                delete(with: imageLink, on: tableView)
            }
        })

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK:- Private
private extension BingImagesViewModel {
    func delete(with imageLink: String, on tableView: UITableView) {
        if let index = self.images?.lastIndex(where: { $0.getImageUrl() == imageLink }) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.beginUpdates()
            
            self.images?.removeAll{ $0.getImageUrl() == imageLink }
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.endUpdates()
        }
    }
}


