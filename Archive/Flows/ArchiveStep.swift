//
//  ArchiveStep.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/14.
//

import RxFlow

enum ArchiveStep: Step {
    // Onboarding
    case onboardingIsRequired
    case onboardingIsComplete
    
    // SignIn
    case signInIsRequired
    case userIsSignedIn
    
    // SignUp
    case termsAgreementIsRequired
    case emailInputRequired
    case passwordInputRequired
    case userIsSignedUp
    
    // MyPage
    case myPageIsRequired(Int)
    case loginInfomationIsRequired(LoginType, Int)
    case withdrawalIsRequired(Int)
    case withdrawalIsComplete
    
    // Record
    case recordIsRequired
    case recordEmotionEditIsRequired(Emotion?)
    case recordEmotionEditIsComplete(Emotion)
    case recordImageSelectIsRequired(Emotion)
    case recordImageSelectIsComplete(UIImage, [UIImage])
}
