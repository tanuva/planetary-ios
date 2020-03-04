//
//  AppController+Progress.swift
//  FBTT
//
//  Created by Christoph on 5/7/19.
//  Copyright © 2019 Verse Communications Inc. All rights reserved.
//

import Foundation
import SVProgressHUD
import UIKit

extension AppController {

    func showProgress(after: TimeInterval = 1, status: String? = nil) {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.setBackgroundColor(UIColor.background.default)
        SVProgressHUD.setForegroundColor(UIColor.red)
        SVProgressHUD.setGraceTimeInterval(after)
        SVProgressHUD.setStatus(status)
        SVProgressHUD.show()
    }

    func hideProgress(completion: (() -> Void)? = nil) {
        SVProgressHUD.dismiss() { completion?() }
    }
}
