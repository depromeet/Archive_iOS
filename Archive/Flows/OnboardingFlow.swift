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
    private let validator = Validator()
    private lazy var signUpReactor = SignUpReactor(validator: validator)
    
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
        case .signUpComplete:
            rootViewController.popToRootViewController(animated: true)
            return .none
        default:
            return .none
        }
    }
    
    private func navigationToSignInScreen() -> FlowContributors {
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
        let termsAgreementViewController = onboardingStoryBoard
            .instantiateViewController(identifier: TermsAgreementViewController.identifier) { coder in
                return TermsAgreementViewController(coder: coder, reactor: self.signUpReactor)
            }
        termsAgreementViewController.title = Constants.signUpNavigationTitle
        rootViewController.pushViewController(termsAgreementViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: termsAgreementViewController,
                                                 withNextStepper: signUpReactor))
    }
    
    private func navigationToEmailInputScreen() -> FlowContributors {
        let emailInputViewController = onboardingStoryBoard
            .instantiateViewController(identifier: EmailInputViewController.identifier) { coder in
                return EmailInputViewController(coder: coder, reactor: self.signUpReactor)
            }
        emailInputViewController.title = Constants.signUpNavigationTitle
        rootViewController.pushViewController(emailInputViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: emailInputViewController,
                                                 withNextStepper: signUpReactor))
    }
    
    private func navigationToPasswordInputScreen() -> FlowContributors {
        let passwordInputViewController = onboardingStoryBoard
            .instantiateViewController(identifier: PasswordInputViewController.identifier) { coder in
                return PasswordInputViewController(coder: coder, reactor: self.signUpReactor)
            }
        passwordInputViewController.title = Constants.signUpNavigationTitle
        rootViewController.pushViewController(passwordInputViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: passwordInputViewController,
                                                 withNextStepper: signUpReactor))
    }
    
    private func navigationToSignUpCompletionScreen() -> FlowContributors {
//        guard let  = onboardingStoryBoard
//                .instantiateViewController(identifier: .identifier) as? SignUpCompletionViewController else {
//            return .none
//        }
//        rootViewController.pushViewController(signUpCompletionViewController, animated: true)
//        return .one(flowContributor: .contribute(withNext: signUpCompletionViewController))
        
        let signUpCompletionViewController = onboardingStoryBoard
            .instantiateViewController(identifier: SignUpCompletionViewController.identifier) { coder in
                return SignUpCompletionViewController(coder: coder, reactor: self.signUpReactor)
            }
//        signUpCompletionViewController.title = Constants.signUpNavigationTitle
        rootViewController.pushViewController(signUpCompletionViewController, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: signUpCompletionViewController,
                                                 withNextStepper: signUpReactor))
    }
}
