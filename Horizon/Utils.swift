//
//  Utils.swift
//  Horizon
//
//  Created by Devesh Tibarewal on 09/02/23.
//

import Foundation
import UIKit
import AVKit
import AVFoundation

class Utils {
    static let shared: Utils = Utils()
    
    static let header = [
        "X-RapidAPI-Key" : "91bc386961msh29ee1e1e35cc7e2p1e8e8ajsnaa4d51017950",
        "X-RapidAPI-Host" :"PexelsdimasV1.p.rapidapi.com"
    ]
    
    func showAlertDialog(controller: UIViewController, message: String, title: String) {
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: UIAlertAction.Style.default))
        controller.present(alert, animated: true )
    }
    
    func playVideoUsingAVPlayer(controller: UIViewController, url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        vc.player?.play()

        controller.present(vc, animated: true) {
            vc.player?.play()
        }
        
    }
    
}
