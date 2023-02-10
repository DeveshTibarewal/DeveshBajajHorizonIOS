//
//  DetailsViewController.swift
//  Horizon
//
//  Created by Devesh Tibarewal on 10/02/23.
//

import UIKit

class DetailsViewController: UIViewController {
    
    // UI Views
    @IBOutlet weak var imageIV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    // My models
    var modelPhoto : Photo?
    var modelVideo : Video?
    var tinyImage : UIImage?
    var orignalImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.imageIV?.image = tinyImage
        self.titleLbl?.text = modelPhoto?.photographer
    }
    
    @IBAction func downloadImage() {
        let url: URL = URL.init(string: (modelPhoto?.src?.original)!)!

        let session = URLSession.shared
        let task = session.downloadTask(with: url) { url, uRLResponse, error in
            do {
                let data = try Data.init(contentsOf: url!)

                DispatchQueue.main.async {
                    self.imageIV?.image = UIImage(data: data)
                }

            } catch {
                print("Error")
            }
        }
        task.resume()
        Utils.shared.showAlertDialog(controller: self, message: "High Resolution Image has been downloaded.", title: "Alert")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
