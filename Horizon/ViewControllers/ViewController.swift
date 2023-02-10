//
//  ViewController.swift
//  Horizon
//
//  Created by Devesh Tibarewal on 09/02/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBoxSB: UISearchBar!
    @IBOutlet weak var segmentControlSC: UISegmentedControl!
    
    var listPhotos: [Photo]! = []
    var listVideos: [Video]! = []
    var segmentIndex: Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Images Finder"
        // Do any additional setup after loading the view.
        
        self.searchBoxSB.placeholder = "Search Images"
        
        
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        self.segmentIndex = sender.selectedSegmentIndex
        
        switch sender.selectedSegmentIndex {
        case 0:do {
            self.searchBoxSB.placeholder = "Search Images"
            self.title = "Images Finder"
            break
        }
            
        case 1: do {
            self.searchBoxSB.placeholder = "Search Movies"
            self.title = "Movies Finder"
            break
        }
            
        case 2: do {
            self.searchBoxSB.placeholder = "Search Music"
            self.title = "Musics Finder"
            break
        }
            
        default:
            self.searchBoxSB.placeholder = "Error Please Don't Search"
            self.title = "Don't Ask Please"
        }
        
    }
    
    @IBAction func OnSearchButtonClicked() {
        switch self.segmentIndex {
        case 0: do {
            self.searchForPhotoInAPI(query: searchBoxSB.text!)
            break
        }
        case 1: do {
            self.searchForVideoInAPI(query: searchBoxSB.text!)
            break
        }
        case 2: do {
            Utils.shared.showAlertDialog(controller: self, message: "Coming Soon",title:  "Information")
            break
        }
        case .none:
            break
        case .some(_):
            break
        }
    }
    
    func searchForPhotoInAPI(query: String) {
        if(query == "") {
            searchBoxSB.becomeFirstResponder()
            Utils.shared.showAlertDialog(controller: self, message: "Please Enter Search Query.", title: "Error")
        } else {
            
            // Converting string URL to URL Object
            let url: URL = URL.self(string: "https://pexelsdimasv1.p.rapidapi.com/v1/search?query=\(query)&locale=en-US&per_page=20&page=1")!
            
            // Creating URLRequest for the URL
            var urlRequest: URLRequest = URLRequest.init(url: url)
            // Putting all the required headers in URLRequest
            urlRequest.allHTTPHeaderFields = Utils.header
            // Putting "GET" as HTTP method
            urlRequest.httpMethod = "GET"
            // Creating a session instance
            let session = URLSession.shared
            
            // Creating a task to get the Data from API
            let task = session.dataTask(with: urlRequest) { data, response, error in
                // Checking if we received error.
                if(error != nil) {
                    // if error received, then print the error in console.
                    print(error!)
                } else {
                    // if no error, then get the response and decode data.
                    let httpResponse = response as? HTTPURLResponse
                    print("Response Code: ", httpResponse!.statusCode)
                    
                    // Decoding the received JSON data from HTTP response.
                    let decoder = JSONDecoder()
                    do {
                        // Decoding data.
                        let modelPhoto = try decoder.decode(ModelPhoto.self, from: data!)
                        // Setting the data.
                        self.listPhotos = modelPhoto.photos
                        // Going to SearchResultViewController.
                        DispatchQueue.main.async {
                            self.goToSearchResultView()
                        }
                    } catch {
                        // If there is any error while decoding, then print "decode error".
                        print("decode error")
                    }
                }
            }
            // Resuming task.
            task.resume()
        }
    }
    
    func searchForVideoInAPI(query: String) {
        if(query == "") {
            searchBoxSB.becomeFirstResponder()
            Utils.shared.showAlertDialog(controller: self, message: "Please Enter Search Query.", title: "Error")
        } else {
            
            // Converting string URL to URL Object
            let url: URL = URL.self(string: "https://pexelsdimasv1.p.rapidapi.com/videos/search?query=\(query)&locale=en-US&per_page=20&page=1")!
            
            // Creating URLRequest for the URL
            var urlRequest: URLRequest = URLRequest.init(url: url)
            // Putting all the required headers in URLRequest
            urlRequest.allHTTPHeaderFields = Utils.header
            // Putting "GET" as HTTP method
            urlRequest.httpMethod = "GET"
            // Creating a session instance
            let session = URLSession.shared
            
            // Creating a task to get the Data from API
            let task = session.dataTask(with: urlRequest) { data, response, error in
                // Checking if we received error.
                if(error != nil) {
                    // if error received, then print the error in console.
                    print(error!)
                } else {
                    // if no error, then get the response and decode data.
                    let httpResponse = response as? HTTPURLResponse
                    print("Response Code for Video: ", httpResponse!.statusCode)
                    
                    // Decoding the received JSON data from HTTP response.
                    let decoder = JSONDecoder()
                    do {
                        // Decoding data.
                        let modelVideo = try decoder.decode(ModelVideo.self, from: data!)
                        // Setting the data.
                        self.listVideos = modelVideo.videos
                        // Going to SearchResultViewController.
                        DispatchQueue.main.async {
                            self.goToSearchResultView()
                        }
                    } catch {
                        // If there is any error while decoding, then print "decode error".
                        print("decode error")
                    }
                }
            }
            // Resuming task.
            task.resume()
        }
    }
    
    /**GoToSrearchResultView
     *  This function creates an instance of storyboard.
     *  The instance is used to instantiate SearchResultViewContoller
     *  Setting the data to SearchResultViewController for passing it from one view to another
     *  Using navigationController and pushing the SeachResultView in the Main Stack.
     */
    func goToSearchResultView() {
        // Creating a Storyboard Instance
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        // Instantiating view controller of SearchResultViewController
        let searchResultVC = storyboard.instantiateViewController(withIdentifier: "SearchResultVC") as? SearchResultViewController
        // Passing the data from this view to SearchResultViewController
        if segmentIndex == 0 {
            searchResultVC!.resultPhotos = self.listPhotos
        } else if segmentIndex == 1 {
            searchResultVC!.resultVideos = self.listVideos
        }
        searchResultVC!.sectionHeading = self.title ?? ""
        searchResultVC!.segmentIndex = self.segmentIndex
        // Pushing the SearchResultViewController into the Stack to show or changing the view
        self.navigationController?.pushViewController(searchResultVC!, animated: true)
    }
    
}
