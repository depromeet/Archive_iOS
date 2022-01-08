//
//  AppStepper.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/14.
//

import RxRelay
import RxFlow

final class AppStepper: Stepper {

    let steps = PublishRelay<Step>()

    var initialStep: Step {
        if UserDefaultManager.shared.isLoggedIn {
            return ArchiveStep.homeIsRequired
        } else {
            print("로그인 안됨")
            return ArchiveStep.onboardingIsRequired
        }
    }
}
