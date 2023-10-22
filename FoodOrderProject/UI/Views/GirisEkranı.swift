//
//  GirisEkranı.swift
//  FoodOrderProject
//
//  Created by Mac on 18.10.2023.
//

import UIKit
import Lottie

class GirisEkrani: UIViewController {
    
    @IBOutlet weak var sifreTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var animationView: UIView!
    
    private var hidingAnimation: LottieAnimationView?
    private var seeAnimation: LottieAnimationView?
    private var animation = false
    private let yRepo = YemeklerDaoRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextfield.delegate = self
        sifreTextfield.delegate = self
        // Do any additional setup after loading the view.
        hidingAnimation = .init(name: "animation_lnomcxed-2")
        hidingAnimation!.frame = animationView.bounds
        hidingAnimation!.contentMode = .scaleAspectFit
        
        animationView.addSubview(hidingAnimation!)
       
    }
    
    @IBAction func girisYapPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = sifreTextfield.text {
            yRepo.girisYapma(email: email, password: password) { error in
                if let error = error {
                    // Hata
                } else {
                    self.performSegue(withIdentifier: "toLogin", sender: nil)
                }
            }
        }
    }
}

//MARK: - Textfield Method
extension GirisEkrani: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTextfield {
            if animation {
                hidingAnimation!.play(fromProgress: 0.7, toProgress: 0, loopMode: .playOnce)
            }
            
        } else if textField == sifreTextfield {
            animation = true
            hidingAnimation?.play(fromProgress: 0, toProgress: 0.7)
        }
    }
}
