//
//  ShowImageViewController.swift
//  Dog Bread Search
//
//  Created by macmini01 on 05/08/22.
//

import UIKit

class ShowImageViewController: UIViewController {

    //MARK: OUTLET
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadImage(from: URL(string: imageURL)!)
    }

    //MARK: DOWNLOADING IMAGE
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            
            // always update the UI in the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}

