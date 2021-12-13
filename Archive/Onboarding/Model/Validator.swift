//
//  Validator.swift
//  Archive
//
//  Created by TTOzzi on 2021/10/15.
//

import Foundation

protocol SignInValidator {
    func isEnableSignIn(id: String, password: String) -> Bool
}

protocol SignUpValidator {
    func isValidEmail(_ email: String) -> Bool
    func isContainsEnglish(_ text: String) -> Bool
    func isContainsNumber(_ text: String) -> Bool
    func isWithinRange(_ text: String, range: ClosedRange<Int>) -> Bool
}

struct Validator: SignInValidator, SignUpValidator {
    
    private enum Constants {
        static let mailScheme = "mailto"
        static let passwordValidCount = (8...20)
    }
    
    func isEnableSignIn(id: String, password: String) -> Bool {
        return isValidID(id) && isValidPassword(password)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        return isValidID(email)
    }
    
    func isContainsEnglish(_ text: String) -> Bool {
        return text.rangeOfCharacter(from: .letters) != nil
    }
    
    func isContainsNumber(_ text: String) -> Bool {
        return text.rangeOfCharacter(from: .decimalDigits) != nil
    }
    
    func isWithinRange(_ text: String, range: ClosedRange<Int>) -> Bool {
        return range.contains(text.count)
    }
    
    private func isValidID(_ id: String) -> Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(id.startIndex..<id.endIndex, in: id)
        let matches = detector?.matches(in: id, options: [], range: range)
        guard let match = matches?.first, matches?.count == 1 else {
            return false
        }
        guard match.url?.scheme == Constants.mailScheme, match.range == range else {
            return false
        }
        return true
    }
    
    private func isValidPassword(_ password: String) -> Bool {
        return Constants.passwordValidCount.contains(password.count)
    }
}
