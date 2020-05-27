//
//  AppDelegate+Twitter.swift
//  Planetary
//
//  Created by Rabble on 5/26/20.
//  Copyright © 2020 Verse Communications Inc. All rights reserved.
//

import Foundation
import UIKit
import TwitterKit

import Keys

extension AppDelegate {
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let keys = PlanetaryKeys()
        TWTRTwitter.sharedInstance().start(withConsumerKey: keys.twitterConsumerKey, consumerSecret: keys.twitterConsumerSecret)

        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
    
    
   
    func configureTwitter() {
        let keys = PlanetaryKeys()
        TWTRTwitter.sharedInstance().start(withConsumerKey: keys.twitterConsumerKey, consumerSecret: keys.twitterConsumerSecret)
    }
}

