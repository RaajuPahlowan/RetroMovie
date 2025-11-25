//
//  CastCollectionViewCell.swift
//  testMovie
//
//  Created by Fahim Mashroor on 15/11/25.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterlabel: UILabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            profileImageView.layer.cornerRadius = 8
            profileImageView.layer.masksToBounds = true
        }
    
}
