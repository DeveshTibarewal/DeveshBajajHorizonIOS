//
//  SearchResultViewController.swift
//  Horizon
//
//  Created by Devesh Tibarewal on 09/02/23.
//

import UIKit



class SearchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var resultTV: UITableView!
    
    var resultPhotos: [Photo]? = []
    var resultVideos: [Video]? = []
    var imageArray: [Int: UIImage]? = [:]
    var sectionHeading: String? = ""
    var segmentIndex: Int?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if segmentIndex == 0 {
            return resultPhotos!.count
        } else if segmentIndex == 1 {
            print(sectionHeading ?? "Null")
            return resultVideos!.count
        }
        return 10
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func getImageData(urlString: String) -> UIImage {
        let url = URL.init(string: urlString)
        do {
            let imageData = try Data.init(contentsOf: url!)
            let image = UIImage.init(data: imageData)
            return image!
        } catch {
            return UIImage.init(named: "DefaultImage")!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell", for: indexPath) as! SearchResultTableViewCell
        
        if sectionHeading == "Images Finder" {
            let obj = resultPhotos![indexPath.row]
            cell.nameUI.text = obj.photographer
            cell.descriptionUI.text = obj.alt
            cell.imageUI.image = UIImage.init(named: "DefaultImage")
            DispatchQueue.global(qos: .utility).async {
                let row = indexPath.row
                let image = self.getImageData(urlString: (obj.src?.tiny)!)
                self.imageArray?[row] = image
                DispatchQueue.main.async {
                    cell.imageUI.image = image
                }
            }
        } else if sectionHeading == "Movies Finder" {
            let obj = resultVideos![indexPath.row]
            cell.nameUI.text = obj.user?.name
            cell.descriptionUI.text = obj.user?.url
            
            DispatchQueue.global(qos: .utility).async {
                let image = self.getImageData(urlString: (obj.image)!)
                DispatchQueue.main.async {
                    cell.imageUI.image = image
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeading
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailsView = storyboard.instantiateViewController(withIdentifier: "DetailsSID") as? DetailsViewController
        if segmentIndex == 0 {
            let photo = self.resultPhotos![indexPath.row]
            
            detailsView!.modelPhoto = photo
            detailsView!.tinyImage = self.imageArray?[indexPath.row]
            self.navigationController?.pushViewController(detailsView!, animated: true)
        } else if segmentIndex == 1 {
            let video = self.resultVideos![indexPath.row]
            self.showResolutionWiseDialog(video: video)
        }
        
    }
    
    func showResolutionWiseDialog(video: Video) {
        
        let alert = UIAlertController.init(title: "Play In", message: "", preferredStyle: UIAlertController.Style.alert)
        for res in video.video_files! {
            alert.addAction(UIAlertAction.init(title: "\(res.height ?? 0) x \(res.width ?? 0)", style: UIAlertAction.Style.default, handler: { _ in
                let url = URL(string: res.link!)!
                Utils.shared.playVideoUsingAVPlayer(controller: self, url: url)
                //                } else {
                //                    Utils.shared.showAlertDialog(controller: self, message: "Cannot Play Video", title: "Error")
                //                }
            }))
        }
        self.present(alert, animated: true )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
