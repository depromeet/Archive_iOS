//
//  SplashView.swift
//  Archive
//
//  Created by hanwe on 2022/01/08.
//

import UIKit
import Lottie
import RxSwift

class SplashView: UIView, NibIdentifiable {

    // MARK: IBOutlet
    @IBOutlet weak var animationView: AnimationView!
    
    // MARK: property
    
    var isFinishAnimationFlag: BehaviorSubject<Bool> = .init(value: false)
    
    // MARK: lifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initUI()
    }
    
    // MARK: private function
    
    private func initUI() {
        self.animationView.backgroundColor = .clear
        self.animationView.animation = Animation.named("Splash")
        self.animationView.contentMode = .scaleAspectFit
        self.animationView.loopMode = .playOnce
    }
    
    // MARK: internal function
    
    class func instance() -> SplashView? {
        return nib.instantiate(withOwner: nil, options: nil).first as? SplashView
    }
    
    func play() {
        self.isFinishAnimationFlag.onNext(false)
        self.animationView.play(completion: { [weak self] _ in
            DispatchQueue.global().async { [weak self] in
                usleep(4 * 100 * 1000)
                self?.isFinishAnimationFlag.onNext(true)
            }
        })
    }
    
    // MARK: private function
    
    
}
