//
//  MovieTrailerViewController.swift
//  movie-core-data
//
//  Created by Thet Htun on 10/11/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import YoutubePlayer_in_WKWebView

class MovieTrailerViewController: UIViewController {    

    @IBOutlet weak var viewYouTubePlayer : WKYTPlayerView!
    
    var videoId : String? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewYouTubePlayer.load(withVideoId: videoId ?? "")
    }
    

   
}
