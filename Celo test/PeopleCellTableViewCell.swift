//
//  PeopleCellTableViewCell.swift
//  Celo test
//
//  Created by Raj Patel on 17/04/20.
//  Copyright © 2020 Raj Patel. All rights reserved.
//

import UIKit

class PeopleCellTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        _personImage.layer.cornerRadius = 6.0
    }
    
    var name: String? {
        didSet {
            _personName.text = name
        }
    }
    
    var dob: String? {
        didSet {
            _personDob.text = dob
        }
    }
    
    var gender: String? {
        didSet {
            _personGender.text = gender
        }
    }
    
    var personImage: UIImage? {
        didSet {
            _personImage.image = personImage
        }
    }
    
    @IBOutlet weak var _personImage: UIImageView!
    @IBOutlet weak var _personName: UILabel!
    @IBOutlet weak var _personGender: UILabel!
    @IBOutlet weak var _personDob: UILabel!
}
