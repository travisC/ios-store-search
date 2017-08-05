//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Travis Cunningham on 8/5/17.
//  Copyright © 2017 Travis Cunningham. All rights reserved.
//

import UIKit
extension UIImageView {
    func loadImage(url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        // 1
        let downloadTask = session.downloadTask(with: url,
                                                completionHandler: { [weak self] url, response, error in
                                                    // 2
                                                    if error == nil, let url = url,
                                                        let data = try? Data(contentsOf: url), // 3
                                                        let image = UIImage(data: data) {
                                                        // 4
                                                        DispatchQueue.main.async {
                                                            if let strongSelf = self {
                                                                strongSelf.image = image
                                                            }
                                                        }
                                                    }
            })
        // 5
        downloadTask.resume()
        return downloadTask
    }
}
