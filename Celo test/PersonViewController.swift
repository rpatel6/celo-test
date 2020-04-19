//
//  PersonViewController.swift
//  Celo test
//
//  Created by Raj Patel on 17/04/20.
//  Copyright © 2020 Raj Patel. All rights reserved.
//

import UIKit

class PersonViewController: UIViewController {
    
    init(person: Person) {
        _person = person
        super.init(nibName: String(describing: PersonViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Person"
        if #available(iOS 13.0, *) {
            self.view.backgroundColor = .systemGray6
        }
        setupView()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        //this handles rotation
        coordinator.animate(alongsideTransition: nil) { _ in
            self.updateConstraints()
        }
    }
    
    override func viewWillAppear(_ animated: Bool)  {
        super.viewWillAppear(animated)
        self.updateConstraints()
    }
    
    private func updateConstraints() {
        let widthConstraint = self.personImageView.widthAnchor.constraint(equalToConstant: 150.0)
        if UIDevice.current.orientation.isLandscape {
            self.personImageViewHeightConstraint.isActive = false
            widthConstraint.isActive = true
        } else {
            self.personImageViewHeightConstraint.isActive = true
            widthConstraint.isActive = false
        }
    }
    
    private func setupView() {
        _name.text = "\(_person.title ?? "") \(_person.name ?? "")"
        _gender.text = _person.gender?.capitalized
        _phone.text = _person.cell
        _email.text = _person.email
        _dob.text = Date.convertToPrettyString(from: _person.dob ?? "")
        if let country = _person.country, let city = _person.city,
            let streetname = _person.streetName {
            _address.text = "\(_person.streetNum) \(streetname), \(city), \(country)"
        }
        if let url = _person.largePic,
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) {
            _personImage.image = image
        } else {
            _personImage.image = #imageLiteral(resourceName: "placeholder.png")
        }
    }
    
    private let _person: Person
    @IBOutlet private weak var _address: UILabel!
    @IBOutlet private weak var _email: UILabel!
    @IBOutlet private weak var _phone: UILabel!
    @IBOutlet private weak var _gender: UILabel!
    @IBOutlet private weak var _dob: UILabel!
    @IBOutlet private weak var _name: UILabel!
    @IBOutlet private weak var _personImage: UIImageView!
    @IBOutlet private var personImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private var personImageView: UIView!
}
