//
//  ERProfileV2TableViewCell.swift
//  EcoRescue
//
//  Created by Birtan on 13.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

private let kProgressViewWidth: CGFloat = 15

class ERProfileV2TableViewCell: UITableViewCell {
    
    private let progressView = ProfileV2CellsProgressView()
    
    private let iconView = UIImageView.imageView()
    
    private let titleLabel    = UILabel.type2Label()
    private let subtitleLabel = UILabel.type2LightLabel(.callout)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(progressView)
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        
        progressView.topbottom().left(constant: UIViewPadding.big).width(constant: kProgressViewWidth).apply()
        iconView.centerY().right(of: progressView, constant: UIViewPadding.big).width(constant: 20).widthEqualsHeight().apply()
        titleLabel.top(constant: UIViewPadding.medium).right(of: iconView, constant: UIViewPadding.big).right(constant: UIViewPadding.small).apply()
        subtitleLabel.bottom(of: titleLabel, constant: UIViewPadding.tiny).left(to: titleLabel, constant: 0).bottom(constant: UIViewPadding.medium).apply()
        
        titleLabel.numberOfLines    = 1
        titleLabel.lineBreakMode    = .byTruncatingTail
        
        subtitleLabel.numberOfLines = 1
        subtitleLabel.lineBreakMode = .byTruncatingTail
        
        iconView.contentMode = .scaleAspectFit
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var title: String? {
        set { titleLabel.text = newValue; invalidateIntrinsicContentSize()  }
        get { return titleLabel.text                                        }
    }
    
    public var subtitle: String? {
        set { subtitleLabel.text = newValue; invalidateIntrinsicContentSize()  }
        get { return subtitleLabel.text                                        }
    }
    
    public var icon: UIImage? {
        set { iconView.image = newValue; invalidateIntrinsicContentSize()  }
        get { return iconView.image                                        }
    }
    
    public func setProgressType(type: ProfileV2CellsProgressViewType) {
        progressView.type = type
    }
    
    public func setProgressCompleted(completed: ProfileV2CellsProgressViewCompletionType) {
        progressView.completion = completed
    }
    
}

public enum ProfileV2CellsProgressViewType {
    case start, mid, end
}

public enum ProfileV2CellsProgressViewCompletionType {
    case completed, inReview, notCompleted
}

class ProfileV2CellsProgressView: UIView {
    
    fileprivate var type = ProfileV2CellsProgressViewType.start
    fileprivate var completion = ProfileV2CellsProgressViewCompletionType.notCompleted { didSet { setIsCompleted(oldValue: oldValue)  } }
    private var color: UIColor = .colorPrimaryRedV2
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.clear
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let side = rect.width.multiplied(by: 0.8)
        let pad  = rect.width.multiplied(by: 0.1)
        
        switch type {
        case .start:
            let square = UIBezierPath(roundedRect: CGRect(x: pad, y: UIViewPadding.medium, width: side, height: side), cornerRadius: 1)
            square.lineWidth = 2
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: rect.midX, y: UIViewPadding.medium + side))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.lineWidth = 1
            path.close()
            
            UIColor.lightGray.setStroke()
            path.stroke()
            square.stroke()
            
            color.setFill()
            square.fill()
            
            break
        case .mid:
            let path1 = UIBezierPath()
            path1.move(to: CGPoint(x: rect.midX, y: 0))
            path1.addLine(to: CGPoint(x: rect.midX, y: UIViewPadding.medium))
            path1.lineWidth = 1
            path1.close()
            
            let square = UIBezierPath(roundedRect: CGRect(x: pad, y: UIViewPadding.medium, width: side, height: side), cornerRadius: 1)
            square.lineWidth = 2
            
            let path2 = UIBezierPath()
            path2.move(to: CGPoint(x: rect.midX, y: UIViewPadding.medium + side))
            path2.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path2.lineWidth = 1
            path2.close()
            
            UIColor.lightGray.setStroke()
            path1.stroke()
            square.stroke()
            path2.stroke()
            
            color.setFill()
            square.fill()
            
            
            break
        case .end:
            let path = UIBezierPath()
            path.move(to: CGPoint(x: rect.midX, y: 0))
            path.addLine(to: CGPoint(x: rect.midX, y: UIViewPadding.medium))
            path.lineWidth = 1
            path.close()
            
            let square = UIBezierPath(roundedRect: CGRect(x: pad, y: UIViewPadding.medium, width: side, height: side), cornerRadius: 1)
            square.lineWidth = 2
            
            UIColor.lightGray.setStroke()
            path.stroke()
            square.stroke()
            
            color.setFill()
            square.fill()
            
            break
        }
        
    }
    
    private func setIsCompleted(oldValue: ProfileV2CellsProgressViewCompletionType) {
        if oldValue == completion { return }
        
        switch completion {
        case .completed:
            color = UIColor.positive
        case .inReview:
            color = UIColor.neutral
        case .notCompleted:
            color = UIColor.negativ
        }
        
        self.setNeedsDisplay()
    }
    
}
