//
//  NotificationTransitionController.swift
//  EcoRescue
//
//  Created by Christoph Erl on 04.04.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class NotificationTransitionController: UIPresentationController {
    
    // MARK: - Override
    
    override var shouldRemovePresentersView: Bool {
        return false
    }

}
