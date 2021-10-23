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
        _ = CommonAlertView.shared
        // TODO: 홈화면으로 변경하고 로그인 여부 확인하는 로직 추가 필요
        return ArchiveStep.onboardingIsRequired
    }
}
