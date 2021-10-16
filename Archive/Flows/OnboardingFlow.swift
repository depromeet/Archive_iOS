//
//  OnboardingFlow.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/14.
//

import UIKit
import RxFlow

final class OnboardingFlow: Flow {
    
    private enum Constants {
        static let onboardingStoryBoardName = "Onboarding"
        static let signUpNavigationTitle = "회원가입"
    }
    
    var root: Presentable {
        return rootViewController
    }
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()
    private let onboardingStoryBoard = UIStoryboard(name: Constants.onboardingStoryBoardName, bundle: nil)
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ArchiveStep else { return .none }

        switch step {
        case .signInIsRequired:
            return navigationToSignInScreen()
        case .userIsSignedIn:
            return .end(forwardToParentFlowWithStep: ArchiveStep.onboardingIsComplete)
        case .termsAgreementIsRequired:
            return navigationToTermsAgreementScreen()
        case .emailInputRequired:
            return navigationToEmailInputScreen()
        case .passwordInputRequired:
            return navigationToPasswordInputScreen()
        case .userIsSignedUp:
            return navigationToSignUpCompletionScreen()
        default:
            return .none
        }
    }
    
    private func navigationToSignInScreen() -> FlowContributors {
        let validator = Validator()
        let signInReactor = SignInReactor(validator: validator)
        let signInViewController = onboardingStoryBoard
            .instantiateViewController(identifier: SignInViewController.identifier) { coder in
                return SignInViewController(coder: coder, reactor: signInReactor)
            }
        rootViewController.pushViewController(signInViewController, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: signInViewController,
                                                 withNextStepper: signInReactor))
    }
    
    private func navigationToTermsAgreementScreen() -> FlowContributors {
        // TODO: 회원가입 로직 Reactor 주입 필요
        guard let termsAgreementViewController = onboardingStoryBoard
                .instantiateViewController(withIdentifier: TermsAgreementViewController.identifier) as? TermsAgreementViewController else {
            return .none
        }
        termsAgreementViewController.title = Constants.signUpNavigationTitle
        rootViewController.pushViewController(termsAgreementViewController, animated: true)
        return .one(flowContributor: .contribute(withNext: termsAgreementViewController))
    }
    
    private func navigationToEmailInputScreen() -> FlowContributors {
        guard let emailInputViewController = onboardingStoryBoard
                .instantiateViewController(identifier: EmailInputViewController.identifier) as? EmailInputViewController else {
            return .none
        }
        emailInputViewController.title = Constants.signUpNavigationTitle
        rootViewController.pushViewController(emailInputViewController, animated: true)
        return .one(flowContributor: .contribute(withNext: emailInputViewController))
    }
    
    private func navigationToPasswordInputScreen() -> FlowContributors {
        guard let passwordInputViewController = onboardingStoryBoard
                .instantiateViewController(identifier: PasswordInputViewController.identifier) as? PasswordInputViewController else {
            return .none
        }
        passwordInputViewController.title = Constants.signUpNavigationTitle
        rootViewController.pushViewController(passwordInputViewController, animated: true)
        return .one(flowContributor: .contribute(withNext: passwordInputViewController))
    }
    
    private func navigationToSignUpCompletionScreen() -> FlowContributors {
        guard let signUpCompletionViewController = onboardingStoryBoard
                .instantiateViewController(identifier: SignUpCompletionViewController.identifier) as? SignUpCompletionViewController else {
            return .none
        }
        rootViewController.pushViewController(signUpCompletionViewController, animated: true)
        return .one(flowContributor: .contribute(withNext: signUpCompletionViewController))
    }
}
