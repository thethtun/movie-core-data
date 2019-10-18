//
//  BookmarkCollectionViewCell.swift
//  movie-core-data
//
//  Created by Riki on 9/28/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import SDWebImage

class BookmarkCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var moviePosterImage: UIImageView!
    
    var data: MovieVO?{
        didSet{
            moviePosterImage.sd_setImage(with: URL(string: "\(API.BASE_IMG_URL)\(data?.poster_path ?? "")"), completed: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static var identifier : String {
        return "cell"
    }
}
