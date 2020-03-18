//
//  SplashOnboardingStep.swift
//  FBTT
//
//  Created by Christoph on 7/16/19.
//  Copyright © 2019 Verse Communications Inc. All rights reserved.
//

import Foundation
import UIKit

class StartOnboardingStep: OnboardingStep {

    private lazy var textView: UITextView = {
        let view = UITextView.forAutoLayout()
        view.backgroundColor = UIColor.background.default
        view.delegate = self
        view.isEditable = false
        let text = NSMutableAttributedString(Text.Onboarding.policyStatement.text,
                                             font: UIFont.systemFont(ofSize: 13, weight: .medium),
                                             color: UIColor.text.detail)
        text.addLinkAttribute(value: Support.Article.termsOfService.rawValue,
                              to: Text.Onboarding.termsOfService.text)
        text.addLinkAttribute(value: Support.Article.privacyPolicy.rawValue,
                              to: Text.Onboarding.privacyPolicy.text)
        view.attributedText = text
        return view
    }()

    init() {
        super.init(.start)
    }

    override func customizeView() {

        let title = NSAttributedString("\n\(Text.planetary.text)\n",
                                       font: UIFont.systemFont(ofSize: 50, weight: .semibold),
                                       color: .clear)

        let subtitle = NSAttributedString(name.title.text,
                                          font: UIFont.systemFont(ofSize: 17, weight: .regular),
                                          color: UIColor.text.detail)

        let text = NSMutableAttributedString(attributedString: title)
        text.append(subtitle)
        self.view.titleLabel.attributedText = text
        self.view.primaryButton.setText(.getStartedButton)

        // this is a total cheat
        // rather than try to position the logo and subtitle text
        // keep the existing attributed title but with a clear
        // and center the logo image view on top
        let logoImageView = UIImageView(image: UIImage(named: "title"))
        logoImageView.contentMode = .center
        Layout.center(logoImageView, in: self.view.titleLabel)

        // add the ToS text below the primary button
        self.textView.constrainHeight(to: 74)
        self.view.buttonStack.addArrangedSubview(self.textView)
    }
}

extension StartOnboardingStep: UITextViewDelegate {

    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool
    {
        guard let article = Support.Article(rawValue: URL.absoluteString) else { return false }
        let controller = Support.articleViewController(article)
        let nc = UINavigationController(rootViewController: controller)
        AppController.shared.present(nc, animated: true)
        return false
    }
}