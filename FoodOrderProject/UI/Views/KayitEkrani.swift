//
//  KayitEkrani.swift
//  FoodOrderProject
//
//  Created by Mac on 21.10.2023.
//

import UIKit

class KayitEkrani: UIViewController {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var userNameTextfield: UITextField!
    @IBOutlet weak var nameTextfield: UITextField!
    
    let viewModel = KayitViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        if let isim = nameTextfield.text, let kullaniciAdi = userNameTextfield.text, let email = emailTextfield.text, let sifre = passwordTextfield.text {
            viewModel.kayitOl(name: isim, userName: kullaniciAdi, email: email, password: sifre) { sonuc in
                if sonuc {
                    self.alert(title: "BAŞARILI", message: "Kullanıcı kaydınız oluşturuldu!")
                } else {
                    self.alert(title: "HATA", message: "Kullanıcı kaydı oluştururken hata oldu!")
                }
            }
        }
    }
    
    func alert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title, message: message, preferredStyle: .alert)
        let giriseGit = UIAlertAction(
            title: "Giriş Yap",
            style: .default,
            handler: { action in
                self.navigationController?.popViewController(animated: true)
            }
        )
        alertController.addAction(giriseGit)
        present(alertController, animated: true, completion: nil)
    }
}
