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
//            return ArchiveStep.recordIsRequired
        } else {
            print("로그인 안됨")
            return ArchiveStep.onboardingIsRequired
        }
        
        
//        let subItem1: RecordImageData = RecordImageData(image: "https://archive-depromeet-images.s3.ap-northeast-2.amazonaws.com/images/4dbb559e-f484-4703-8ea0-99d32de2da1c-PlaceHolder.png", review: "넘 잼써!", backgroundColor: "0x010101")
//        let subItem2: RecordImageData = RecordImageData(image: "https://archive-depromeet-images.s3.ap-northeast-2.amazonaws.com/images/4dbb559e-f484-4703-8ea0-99d32de2da1c-PlaceHolder.png", review: "넘 잼써!!!!!!", backgroundColor: "0xFFFFFF")
//        let item: RecordData = RecordData(name: "더미", watchedOn: "21/10/3", companions: ["김땡땡", "후후후"], emotion: "INTERESTING", mainImage: "https://archive-depromeet-images.s3.ap-northeast-2.amazonaws.com/images/4dbb559e-f484-4703-8ea0-99d32de2da1c-PlaceHolder.png", images: [subItem1, subItem2])
//        return ArchiveStep.detailIsRequired(item)
    }
}
