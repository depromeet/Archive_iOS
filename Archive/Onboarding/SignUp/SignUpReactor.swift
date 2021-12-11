//
//  SignUpReactor.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/09.
//

import ReactorKit
import RxSwift
import RxRelay
import RxFlow
import SwiftyJSON

final class SignUpReactor: Reactor, Stepper {
    
    enum Action {
        case checkAll
        case agreeTerms
        case viewTerms
        case agreePersonalInformationPolicy
        case viewPersonalInformationPolicy
        case goToEmailInput
        
        case emailInput(text: String)
        case checkEmailDuplicate
        case setIsEmailDuplicated(Bool)
        case goToPasswordInput
        
        case passwordInput(text: String)
        case passwordCofirmInput(text: String)
        case completeSignUp
        
        case startArchive
    }
    
    enum Mutation {
        case setTermsAgreement(Bool)
        case setPersonalInformationPolicyAgreement(Bool)
        
        case setEmail(String)
        case setEmailValidation(Bool)
        case setEmailDuplicate(Bool)
        case resetEmailValidation
        
        case setPassword(String)
        case setEnglishCombination(Bool)
        case setNumberCombination(Bool)
        case setRangeValidation(Bool)
        case setPasswordCofirmationInput(String)
    }
    
    struct State {
        var isCheckAll: Bool {
            return isAgreeTerms && isAgreePersonalInformationPolicy
        }
        var isAgreeTerms: Bool = false
        var isAgreePersonalInformationPolicy: Bool = false
        
        var email: String = ""
        var isValidEmail: Bool = false
        var isDuplicateEmail: Bool = true
        var isCompleteEmailInput: Bool {
            return isValidEmail && (isDuplicateEmail == false)
        }
        var emailValidationText: String = ""
        
        var password: String = ""
        var isContainsEnglish: Bool = false
        var isContainsNumber: Bool = false
        var isWithinRange: Bool = false
        var passwordConfirmationInput: String = ""
        var isSamePasswordInput: Bool {
            return password == passwordConfirmationInput
        }
        var isValidPassword: Bool {
            return isContainsEnglish && isContainsNumber && isWithinRange && isSamePasswordInput
        }
    }
    
    let initialState = State()
    let steps = PublishRelay<Step>()
    private let validator: SignUpValidator
    var isLoading: PublishSubject<Bool>
    var error: PublishSubject<String>
    
    init(validator: SignUpValidator) {
        self.validator = validator
        self.isLoading = .init()
        self.error = .init()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .checkAll:
            let isSelected = !currentState.isCheckAll
            return .from([.setTermsAgreement(isSelected),
                          .setPersonalInformationPolicyAgreement(isSelected)])
            
        case .agreeTerms:
            let isSelected = !currentState.isAgreeTerms
            return .just(.setTermsAgreement(isSelected))
            
        case .viewTerms:
            Util.openUseSafari("https://wise-icicle-d10.notion.site/8ad4c5884b814ff6a6330f1a6143c1e6")
            return.empty()
            
        case .agreePersonalInformationPolicy:
            let isSelected = !currentState.isAgreePersonalInformationPolicy
            return .just(.setPersonalInformationPolicyAgreement(isSelected))
            
        case .viewPersonalInformationPolicy:
            Util.openUseSafari("https://wise-icicle-d10.notion.site/13ff403ad4e2402ca657fb20be31e4ae")
            return .empty()
            
        case .goToEmailInput:
            steps.accept(ArchiveStep.emailInputRequired)
            return .empty()
            
        case let .emailInput(email):
            let isValid = validator.isValidEmail(email)
            return .from([.resetEmailValidation,
                          .setEmail(email),
                          .setEmailValidation(isValid)])
            
        case .checkEmailDuplicate:
            checkIsDuplicatedEmail(eMail: self.currentState.email, completion: { [weak self] isDup in
                if isDup {
                    self?.error.onNext("이미 가입된 아이디입니다.")
                }
                self?.action.onNext(.setIsEmailDuplicated(isDup))
            })
            return .empty()
        case .setIsEmailDuplicated(let isDup):
            return .just(.setEmailDuplicate(isDup))
        case .goToPasswordInput:
            steps.accept(ArchiveStep.passwordInputRequired)
            return .empty()
            
        case let .passwordInput(text):
            let isContainsEnglish = validator.isContainsEnglish(text)
            let isContainsNumber = validator.isContainsNumber(text)
            let isWithinRage = validator.isWithinRange(text, range: (8...20))
            return .from([.setPassword(text),
                          .setEnglishCombination(isContainsEnglish),
                          .setNumberCombination(isContainsNumber),
                          .setRangeValidation(isWithinRage)])
            
        case let .passwordCofirmInput(text):
            return .just(.setPasswordCofirmationInput(text))
            
        case .completeSignUp:
            registEmail(eMail: self.currentState.email, password: self.currentState.password)
            return .empty()
            
        case .startArchive:
            steps.accept(ArchiveStep.signUpComplete)
            return .empty()
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setTermsAgreement(isSelected):
            newState.isAgreeTerms = isSelected
            
        case let .setPersonalInformationPolicyAgreement(isSelected):
            newState.isAgreePersonalInformationPolicy = isSelected
            
        case let .setEmail(email):
            newState.email = email
            
        case let .setEmailValidation(isValid):
            newState.isValidEmail = isValid
            newState.emailValidationText = ""
            
        case let .setEmailDuplicate(isDuplicate):
            newState.isDuplicateEmail = isDuplicate
            newState.emailValidationText = isDuplicate ? "중복된 이메일입니다" : "중복되지 않은 이메일입니다"
            
        case .resetEmailValidation:
            newState.isValidEmail = false
            newState.isDuplicateEmail = true
            
        case let .setPassword(password):
            newState.password = password
            
        case let .setEnglishCombination(isContainsEnglish):
            newState.isContainsEnglish = isContainsEnglish
            
        case let.setNumberCombination(isContainsNumber):
            newState.isContainsNumber = isContainsNumber
            
        case let .setRangeValidation(isWithinRange):
            newState.isWithinRange = isWithinRange
            
        case let .setPasswordCofirmationInput(password):
            newState.passwordConfirmationInput = password
        }
        
        return newState
    }
    
    private func registEmail(eMail: String, password: String) {
        self.isLoading.onNext(true)
        let provider = ArchiveProvider.shared.provider
        let param = RequestEmailParam(email: eMail, password: password)
        provider.request(.registEmail(param), completion: { [weak self] response in
            self?.isLoading.onNext(false)
            switch response {
            case .success(_):
                DispatchQueue.main.async {
                    self?.steps.accept(ArchiveStep.userIsSignedUp)
                }
            case .failure(let err):
                print("err: \(err.localizedDescription)")
            }
        })
    }
    
    private func checkIsDuplicatedEmail(eMail: String, completion: @escaping (Bool) -> Void) {
        self.isLoading.onNext(true)
        let provider = ArchiveProvider.shared.provider
        provider.request(.isDuplicatedEmail(eMail), completion: { [weak self] response in
            self?.isLoading.onNext(false)
            switch response {
            case .success(let response):
                if let result: JSON = try? JSON.init(data: response.data) {
                    let isDup: Bool = result["duplicatedEmail"].boolValue
                    if isDup {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(true)
                }
            case .failure(let err):
                print("err: \(err.localizedDescription)")
                completion(true)
            }
        })
    }
}

struct RequestEmailParam: Encodable {
    var email: String
    var password: String
}
