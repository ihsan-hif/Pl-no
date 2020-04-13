//
//  TodoCell.swift
//  Plano
//
//  Created by Rayhan Martiza Faluda on 10/04/20.
//  Copyright © 2020 Mini Challenge 1 - Group 7. All rights reserved.
//

import UIKit
import SwipeCellKit

class TodoCell: SwipeTableViewCell {

    @IBOutlet weak var checkboxButtonOutlet: UIButton!
    @IBOutlet weak var todoCellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var priorityImage: UIImageView!
    
    var animator: Any?
    var indicatorView = IndicatorView(frame: .zero)
    var status = false {
        didSet {
            indicatorView.transform = status ? CGAffineTransform.identity : CGAffineTransform.init(scaleX: 0.001, y: 0.001)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setStatus(_ status: Bool, animated: Bool) {
        let closure = {
            self.status = status
        }
        
        if #available(iOS 10, *), animated {
            var localAnimator = self.animator as? UIViewPropertyAnimator
            localAnimator?.stopAnimation(true)
            
            localAnimator = status ? UIViewPropertyAnimator(duration: 1.0, dampingRatio: 0.4) : UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1.0)
            localAnimator?.addAnimations(closure)
            localAnimator?.startAnimation()
            
            self.animator = localAnimator
        } else {
            closure()
        }
    }

}
