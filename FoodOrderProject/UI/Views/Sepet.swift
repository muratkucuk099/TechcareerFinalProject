//
//  Sepet.swift
//  FoodOrderProject
//
//  Created by Mac on 13.10.2023.
//

import UIKit
import RxSwift

class Sepet: UIViewController {
    
    @IBOutlet weak var toplamLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel = SepetViewModel()
    var yemekListesi = [SepetYemek]()
    var toplamTutar = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        _ = viewModel.yemeklerListesi.subscribe(onNext: { liste in
            self.yemekListesi = liste
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        
        _ = viewModel.toplamTutar.subscribe(onNext: { toplam in
            self.toplamTutar = toplam
            DispatchQueue.main.async {
                self.toplamLabel.text = "\(String(self.toplamTutar)) ₺"
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.sepetYemekGetir(kullanici_adi: "murat_kucuk")
    }
    
    
    @IBAction func satinAlPressed(_ sender: UIButton) {
        let alertController = UIAlertController(
            title: "Başarılı!", message: "Satın alma gerçekleşti", preferredStyle: .alert)
        let actionSepeteGit = UIAlertAction(
            title: "Alışverişe Devam",
            style: .default,
            handler: { action in
                if let tabBarController = self.tabBarController as? UITabBarController {
                    tabBarController.selectedIndex = 0
                }
            }
        )
        let actionAlisveriseDevam = UIAlertAction(
            title: "Tamam", style: .default)
        
        alertController.addAction(actionSepeteGit)
        alertController.addAction(actionAlisveriseDevam)
        present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: - Tableview Method
extension Sepet: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        yemekListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sepetViewCell", for: indexPath) as! SepetTableViewCell
        let yemek = yemekListesi[indexPath.row]
        if let adetFiyat = Int(yemek.yemek_fiyat), let siparisAdet = Int(yemek.yemek_siparis_adet) {
            cell.fiyatLabel.text = "\(String(adetFiyat * siparisAdet)) ₺"
        }
        cell.adetLabel.text = yemek.yemek_siparis_adet
        cell.isimLabel.text = yemek.yemek_adi
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi)") {
            cell.yemekImageView.kf.setImage(with: url)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let yemek = self.yemekListesi[indexPath.row]
            self.viewModel.sepetYemekSil(sepet_yemek_id: Int(yemek.sepet_yemek_id!)!, kullanici_adi: yemek.kullanici_adi)
            self.yemekListesi.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            print("Silme işleminde \(toplamTutar)")
        }
    }
}
