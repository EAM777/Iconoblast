//
//  IconCell.swift
//  Iconoblast
//
//  Created by Space 1337 on 3/26/24.
//

import UIKit

class IconCell: UITableViewCell {
    
    var titleLabel =  UILabel()
    var view = UIView()
    var iconView = UIView()
    var logoImage = UIImageView()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    func configureCell(fileName: Directory, viewSize: CGFloat) {
        view.frame = CGRect(x: 5, y: 5, width: viewSize  - 10, height: 100)
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 8
       // view.layer.cornerCurve = 8
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.black.cgColor
        view.translatesAutoresizingMaskIntoConstraints = true
        iconView.frame = CGRect(x: view.frame.width - 100, y: 5, width: 90, height: 90)
        iconView.backgroundColor = .yellow
        iconView.layer.cornerRadius = 8
        iconView.layer.shadowOffset = CGSize(width: 1, height: 1)
        iconView.layer.shadowOpacity = 1
        iconView.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(iconView)
        contentView.addSubview(view)
        
        
        titleLabel.frame = CGRect(x: 8, y: 8, width: 150, height: 28)
        titleLabel.text = fileName.folderName
        titleLabel.font = .boldSystemFont(ofSize: 18)
     //   titleLabel.backgroundColor = .cyan
        titleLabel.translatesAutoresizingMaskIntoConstraints = true
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        view.addSubview(titleLabel)
        
       // self.contentView.sizeToFit()
        contentView.translatesAutoresizingMaskIntoConstraints = true
        translatesAutoresizingMaskIntoConstraints = true 
        
     
        setupLogoImage(url: fileName.image)
        
        NSLayoutConstraint.activate([
//            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
//            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
//            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
//            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
//            iconView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
//            iconView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
//            iconView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
//            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
//            logoImage.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 0),
//            logoImage.trailingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 0),
//            logoImage.leadingAnchor.constraint(equalTo: iconView.leadingAnchor, constant: 0),
//            logoImage.bottomAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 0)
        ])
    }
    
    func setupLogoImage(url: UIImage) {
        
        let frame = CGRect(x: 0, y: 0, width: 90, height: 90)
        logoImage.frame = frame
        logoImage.image = url

        // Set the background color of the UIImageView
        // logoImage.backgroundColor = .lightGray

        // Set the content mode of the UIImageView
        logoImage.contentMode = .scaleAspectFill
        logoImage.layer.shadowOpacity = 0.3
        logoImage.layer.shadowOffset = CGSize(width: 2, height: 2)
        logoImage.layer.shadowRadius = 4
        logoImage.layer.cornerRadius = 8
        logoImage.clipsToBounds = true

        // Set the image for the UIImageView
    

        // Add the UIImageView as a subview
        iconView.addSubview(logoImage)
        


    
        
        NSLayoutConstraint.activate([
          
        ])
        
    }

}
