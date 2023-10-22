//
//  YemekDetay.swift
//  FoodOrderProject
//
//  Created by Mac on 11.10.2023.
//

import UIKit
import Kingfisher

class YemekDetay: UIViewController {
    
    @IBOutlet weak var totalUcretLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var adetLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var yemek: Yemekler?
    var adet = 1
    let viewModel = DetaySayfaViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let y = yemek {
            nameLabel.text = y.yemek_adi
            if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(y.yemek_resim_adi)") {
                imageView.kf.setImage(with: url)
            }
        }
        adetLabel.text = String(adet)
        totalUcretLabel.text = "\(String(adet * Int(yemek!.yemek_fiyat)!)) ₺"
    }
    
    @IBAction func eksiltmeArttirmaButton(_ sender: UIButton) {
        if sender.tag == 0 {
            if adet > 0{
                adet -= 1
            }
        } else {
            adet += 1
        }
        adetLabel.text = String(adet)
        totalUcretLabel.text = "\(String(adet * Int(yemek!.yemek_fiyat)!)) ₺"
    }
    
    
    @IBAction func sepeteEkleButton(_ sender: UIButton) {
        viewModel.sepeteEkle(yemek_adi: yemek!.yemek_adi, yemek_resim_adi: yemek!.yemek_resim_adi, yemek_fiyat: Int(yemek!.yemek_fiyat)!, yemek_siparis_adet: adet, kullanici_adi: "murat_kucuk") { basari in
            if basari{
                self.sepeteEkleAlert(title: "BAŞARILI!", message: "\(self.yemek!.yemek_adi)  Sepete Eklendi")
            } else {
                self.sepeteEkleAlert(title: "HATA!", message: "\(self.yemek!.yemek_adi) Sepete Eklenirken Hata Oluştu")
            }
        }
    }
    
    func sepeteEkleAlert(title: String, message: String) {
        let alertController = UIAlertController(
            title: title, message: message, preferredStyle: .alert)
        let actionSepeteGit = UIAlertAction(
            title: "Sepete Git",
            style: .default,
            handler: { action in
                if let tabBarController = self.tabBarController as? UITabBarController {
                    tabBarController.selectedIndex = 1
                }
            }
        )
        let actionAlisveriseDevam = UIAlertAction(
            title: "Alışverişe Devam", style: .default)
        
        alertController.addAction(actionSepeteGit)
        alertController.addAction(actionAlisveriseDevam)
        present(alertController, animated: true, completion: nil)
    }
}
