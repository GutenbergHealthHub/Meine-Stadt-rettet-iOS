//
//  TableViewCell.swift
//  EcoRescue
//
//  Created by Christoph Erl on 29.09.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    private let style: UITableViewCellStyle

    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        self.style = style
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        switch style {
        case .value1:
            textLabel?.font             = UIFont.openSansRegular(textStyle: .body)
            //textLabel?.textColor        = UIColor.colorTextSecondary
            detailTextLabel?.font       = UIFont.openSansLight(textStyle: .body)
            //detailTextLabel?.textColor  = UIColor.colorTextPrimary
            break
            
        case .value2:
            textLabel?.font             = UIFont.openSansRegular(textStyle: .body)
            //textLabel?.textColor        = UIColor.colorTextSecondary
            detailTextLabel?.font       = UIFont.openSansLight(textStyle: .callout)
            //detailTextLabel?.textColor  = UIColor.colorTextPrimary
            break
            
        default:
            textLabel?.font             = UIFont.body
            textLabel?.textColor        = UIColor.colorTextPrimary
            detailTextLabel?.font       = UIFont.callout
            detailTextLabel?.textColor  = UIColor.colorTextSecondary
            break
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var title: String? {
        set { textLabel?.text = newValue; invalidateIntrinsicContentSize()  }
        get { return textLabel?.text                                        }
    }
    
    public var titleFont: UIFont? {
        set { textLabel?.font = newValue; invalidateIntrinsicContentSize()  }
        get { return textLabel?.font                                        }
    }
    
    public var titleAlignment: NSTextAlignment {
        set { textLabel?.textAlignment = newValue; invalidateIntrinsicContentSize()     }
        get { return textLabel?.textAlignment ?? .left                                  }
    }
    
    public var titleColor: UIColor? {
        set { textLabel?.textColor = newValue;  }
        get { return textLabel?.textColor       }
    }
    
    public var titleNumberOfLines: Int {
        set { textLabel?.numberOfLines = newValue; invalidateIntrinsicContentSize()   }
        get { return textLabel?.numberOfLines ?? 0  }
    }
    
    public var subtitle: String? {
        set { detailTextLabel?.text = newValue; invalidateIntrinsicContentSize()    }
        get { return detailTextLabel?.text                                                }
    }
    
    public var subtitleFont: UIFont? {
        set { detailTextLabel?.font = newValue; invalidateIntrinsicContentSize()  }
        get { return detailTextLabel?.font                                        }
    }
    
    public var subtitleAlignment: NSTextAlignment {
        set { detailTextLabel?.textAlignment = newValue; invalidateIntrinsicContentSize()  }
        get { return detailTextLabel?.textAlignment ?? .left                               }
    }
    
    public var subtitleColor: UIColor? {
        set { detailTextLabel?.textColor = newValue;  }
        get { return detailTextLabel?.textColor       }
    }
    
    public var subtitleNumberOfLines: Int {
        set { detailTextLabel?.numberOfLines = newValue; invalidateIntrinsicContentSize()   }
        get { return detailTextLabel?.numberOfLines ?? 0  }
    }
    
    public var icon: UIImage? {
        set { imageView?.image = newValue; invalidateIntrinsicContentSize()    }
        get { return imageView?.image                                                }
    }
    
    public var iconTintColor: UIColor? {
        set { imageView?.tintColor = newValue; invalidateIntrinsicContentSize()    }
        get { return imageView?.tintColor                                                }
    }
    
    // MARK: - Badge
    
    public var badge: String? {
        didSet {
            if let badge = badge {
                if accessoryView == nil {
                    let badgeView           = BadgeView()
                    badgeView.autoLayout    = false
                    badgeView.tintColor     = badgeTintColor
                    badgeView.isFilled      = isBadgeFilled
                    badgeView.value         = badge
                    badgeView.sizeToFit()
                    accessoryView           = badgeView
                    
                } else if let badgeView = accessoryView as? BadgeView {
                    badgeView.value = badge
                }
                
            } else {
                if accessoryView is BadgeView {
                    accessoryView = nil
                }
            }
        }
    }
    
    var badgeTintColor: UIColor = UIColor.theme {
        didSet {
            if let badgeView = accessoryView as? BadgeView {
                badgeView.tintColor = badgeTintColor
            }
        }
    }
    
    var isBadgeFilled: Bool = true {
        didSet {
            if let badgeView = accessoryView as? BadgeView {
                badgeView.isFilled = isBadgeFilled
            }
        }
    }
    
    // MARK: - Override
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        switch style {
        case .value2:
            return p_sizeForSystemLayoutSizeFittingValue12(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        default:
            return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        }
    }
    
    // MARK: - Private Helper Methods
    
    private func p_sizeForSystemLayoutSizeFittingValue12(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        layoutIfNeeded()
        
        var size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        
        if let textLabel = textLabel, let detailTextLabel = detailTextLabel {
            let detailHeight = detailTextLabel.frame.size.height
            let textHeight = textLabel.frame.size.height
            if (detailHeight > textHeight) {
                size.height += detailHeight - textHeight
            }
        }
        return size
    }


}
