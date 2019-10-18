//
//  MovieListCollectionViewCell.swift
//  movie-core-data
//
//  Created by Thet Htun on 9/18/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import SDWebImage

class MovieListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageViewMoviePoster : UIImageView!
    
    let imageViewPoster : UIImageView = {
        let ui = UIImageView()
        ui.translatesAutoresizingMaskIntoConstraints = false
        ui.contentMode = UIView.ContentMode.scaleAspectFill
        return ui
    }()
    
    var data : MovieVO? {
        didSet {
            if let data = data {
                imageViewPoster.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data.poster_path ?? "")"), completed: nil)
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageViewPoster)

        imageViewPoster.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        imageViewPoster.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        imageViewPoster.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        imageViewPoster.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static var identifier : String {
        return String(describing: self)
    }
}
