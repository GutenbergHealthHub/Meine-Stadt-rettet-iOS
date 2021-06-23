//
//  AuthorizationViewController.swift
//  EcoRescue
//
//  Created by Christoph Erl on 24.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class AuthorizationViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //isBackButtonHidden  = false
        //backButtonTitle     = String.SPAETER

        let containerView = UIView.view()
        view.addSubview(containerView)
        containerView.leftright().top(constant: UIViewPadding.medium).bottom(constant: UIViewPadding.medium).apply()
        
        containerView.addSubview(tableView)
        containerView.addSubview(labelInformation)
        containerView.addSubview(buttonAuthorize)
        
        tableView.leftright().top(constant: UIViewPadding.medium).top(of: buttonAuthorize, constant: UIViewPadding.medium).apply()
        buttonAuthorize.centerX().top(of: labelInformation, constant: UIViewPadding.medium).apply()
        labelInformation.leftright(constant: UIViewPadding.big).bottom(constant: UIViewPadding.medium).apply()
    }
    
    class func createTableViewCell(title: String?, subtitle: String?) -> UITableViewCell {
        let cell                    = TableViewCell(style: .value2, reuseIdentifier: nil)
        cell.selectionStyle         = .none
        cell.backgroundColor        = UIColor.clear
        cell.titleColor             = UIColor.colorTextSecondary
        
        cell.titleFont              = UIFont.createFont(textStyle: .callout)
        cell.subtitleFont           = UIFont.createFont(textStyle: .callout)
        cell.subtitleNumberOfLines  = 0
        
        cell.title                  = title
        cell.subtitle               = subtitle
        
        return cell
    }
    
    // MARK: - Properties
    
    var authorizationTitle: String? {
        set { title = newValue; }
        get { return title      }
    }
    
    var authorizationDescription: String? {
        set { labelDescription.text = newValue  }
        get { return labelDescription.text      }
    }
    
    var authorizationTintColor: UIColor = UIColor.theme {
        didSet {
            imageViewViewDescription.backgroundColor = authorizationTintColor
        }
    }
    
    var authorizationIcon: UIImage? {
        set { imageViewDescription.image = newValue?.image(color: UIColor.white)  }
        get { return imageViewDescription.image      }
    }
    
    var authorizationInformation: String? {
        set { labelInformation.text = newValue  }
        get { return labelInformation.text      }
    }
    
    var authorizationInformationColor: UIColor {
        set { labelInformation.textColor = newValue  }
        get { return labelInformation.textColor      }
    }
    
    var authorizationButtonTitle: String? {
        set { buttonAuthorize.title = newValue  }
        get { return buttonAuthorize.title      }
    }
    
    var authorizationButtonTintColor: UIColor! {
        set { buttonAuthorize.tintColor = newValue  }
        get { return buttonAuthorize.tintColor      }
    }
    
    var authorizationButtonShape: Button.Shape {
        set { buttonAuthorize.shape = newValue  }
        get { return buttonAuthorize.shape      }
    }
    
    var authorizationButtonIcon: UIImage? {
        set { buttonAuthorize.icon = newValue  }
        get { return buttonAuthorize.icon      }
    }
    
    var authorizationButtonFilled: Bool {
        set { buttonAuthorize.isFilled = newValue  }
        get { return buttonAuthorize.isFilled      }
    }
    
    // MARK: - Views
    
    private lazy var labelDescription: UILabel = {
        let label = UILabel.bodyLabel
        label.font = UIFont.createFont(textStyle: .callout, weight: UIFontWeightMedium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageViewDescription: UIImageView = {
        let view = UIImageView.imageView()
        return view
    }()
    
    private lazy var imageViewViewDescription: UIView = {
        let view = View()
        view.layer.cornerRadius = 4
        view.addSubview(self.imageViewDescription)
        self.imageViewDescription.match(constant: 4).apply()
        return view
    }()
    
    private lazy var labelInformation: UILabel = {
        let label = UILabel.footnoteLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var buttonAuthorize: Button = {
        let button = Button()
        button.addTarget(self, action: #selector(didTapAuthorize(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: FixedTableView = {
        let tableView = FixedTableView(style: .grouped)
        tableView.backgroundColor   = UIColor.clear
        tableView.bounces           = false
        tableView.tableHeaderView   = self.tableHeaderView
        tableView.sections          = self.sections()
        return tableView
    }()
    
    private lazy var tableHeaderView: UIView = {
        let tableHeaderView = View()
        tableHeaderView.addSubview(self.labelDescription)
        tableHeaderView.addSubview(self.imageViewViewDescription)
        self.labelDescription.leftright(constant: UIViewPadding.big).bottom(constant: 0).bottom(of: self.imageViewDescription, constant: UIViewPadding.big).apply()
        self.imageViewViewDescription.centerX().top(constant: UIViewPadding.big).height(constant: 32).widthEqualsHeight().apply()
        return tableHeaderView
    }()
    
    // MARK: - Override
    
    func sections() -> [FixedTableViewSection] {
        return [ FixedTableViewSection ]()
    }
    
    // MARK: - Actions
    
    func didTapAuthorize(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Enum AccessLevel
    
    let accessLevel: AccessLevel
    
    enum AccessLevel {
        case guest, firstResponder
    }
    
    // MARK: - Init
    
    init(accessLevel: AccessLevel) {
        self.accessLevel = accessLevel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
