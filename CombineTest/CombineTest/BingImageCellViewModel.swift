//
//  BingImageCellViewModel.swift
//  CombineTest
//
//  Created by 罗树新 on 2021/1/20.
//

import UIKit
import OpenCombine

class BingImageCellViewModel: NSObject {
    
    enum BingImageCellAction {
        case delete
    }
    typealias CellData = (imageUrl: URL?, copyRight: String?)
    typealias ActionData = (actionType: BingImageCellAction, imageLink: String)
    
    override init() {
        let cellData = (imageUrl: URL(string: self.image?.getImageUrl() ?? ""), copyRight: self.image?.copyRight)
        self.dataSubject = CurrentValueSubject<CellData, Never>(cellData)
        self.actionSubject = PassthroughSubject<ActionData, Never>()
        super.init()
    }
    var dataSubject: CurrentValueSubject<CellData, Never>
    var actionSubject: PassthroughSubject<ActionData, Never>
    
    var image: BingImages.BingImage? {
        didSet {
            let imageLink = image?.getImageUrl()
            let data = CellData(imageUrl: URL(string: imageLink ?? ""), copyRight: image?.copyRight)
            dataSubject.send(data)
        }
    }
    
    func delete() {
        if let image = image {
            let action = ActionData(actionType: .delete, imageLink: image.getImageUrl())
            actionSubject.send(action)
        }
    }

}
