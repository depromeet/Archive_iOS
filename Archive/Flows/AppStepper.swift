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
        if UserDefaultManager.shared.isLoggedIn { // TODO: 홈화면 ㄱㄱ
            print("로그인 됨")
            return ArchiveStep.recordIsRequired
        } else {
            print("로그인 안됨")
            return ArchiveStep.onboardingIsRequired
        }
    }
}
