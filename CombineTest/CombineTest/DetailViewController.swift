//
//  Detail.swift
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
import SDWebImage


class DetailViewController: UIViewController {
        
    var viewModel = BingImagesViewModel()
    
    /// weak  修饰，自动取消订阅， 完成释放
    weak var autoCancellable: AnyCancellable?
    
    /// 不是 weak 修饰，需要主动调用 cancel() 取消订阅，完成释放
    var unAutoCancellable1: AnyCancellable?
    #if canImport(Combine)
    var importStr = "Combine"
    #else
    var importStr = "OpenCombine"
    #endif

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(imageView)
        view.addSubview(imageView2)
        imageView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        imageView2.frame = CGRect(x: 100, y: 200, width: 100, height: 100)

        autoCancellable = viewModel.imagePublisher.map({ (images) -> URL? in
            if let image = images?[0] {
                let imageUrlString = image.getImageUrl()
                let imageUrl = URL(string: imageUrlString)
                return imageUrl
            }
            return nil
        }).sink(receiveValue: { (imageUrl) in
            self.imageView.sd_setImage(with: imageUrl, completed: nil)
        })
        
        unAutoCancellable1 = viewModel.imagePublisher.sink(receiveValue: { (images) in
            if let image = images?[1] {
                let imageUrlString = image.getImageUrl()
                let imageUrl = URL(string: imageUrlString)
                self.imageView2.sd_setImage(with: imageUrl, completed: nil)
            }
        })
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var imageView2: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    deinit {
        print("deinit")

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("viewDidDisappear")
        // weak 修饰，不需要cancel；不是weak 修饰，需要自动cancel
//        autoCancellable?.cancel()
        unAutoCancellable1?.cancel()
        viewModel.requestImages()
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let alert = UIAlertController(title: importStr, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        
        }))
        
        alert.addAction(UIAlertAction(title: "好的", style: .destructive, handler: { (action) in
            
        }))
 
        self.present(alert, animated: true) {}
    }
}
