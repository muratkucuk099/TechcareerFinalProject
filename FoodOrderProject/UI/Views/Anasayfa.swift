//
//  ViewController.swift
//  FoodOrderProject
//
//  Created by Mac on 11.10.2023.
//

import UIKit
import Kingfisher

class Anasayfa: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let viewModel = AnasayfaViewModel()
    let detayViewModel = DetaySayfaViewModel()
    let kViewModel = KViewModel()
    var yemekListesi = [Yemekler]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        searchBar.delegate = self
        
        kViewModel.kisiBilgileriGetir(completion: { kisi in
            self.navigationItem.title = "Hoşgeldin \(kisi.name)"
        })
        
        _ = viewModel.yemeklerListesi.subscribe(onNext: { liste in
            self.yemekListesi = liste
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                print(self.yemekListesi.count)
            }
        })
        
        let tasarim = UICollectionViewFlowLayout()
        tasarim.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        tasarim.minimumLineSpacing = 10
        tasarim.minimumInteritemSpacing = 10
        
        let ekranGenislik = UIScreen.main.bounds.width
        let itemGenislik = (ekranGenislik - 40) / 2
        
        tasarim.itemSize = CGSize(width: itemGenislik, height: itemGenislik * 1.6)
        collectionView.collectionViewLayout = tasarim
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.yemekleriYukle()
    }
    
    @IBAction func sepeteGit(_ sender: UIButton) {
        performSegue(withIdentifier: "mainToBasket", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let yemek = sender as? Yemekler {
                let gidilecekVC = segue.destination as! YemekDetay
                gidilecekVC.yemek = yemek
            }
        }
    }
}

//MARK: - CollectionView Functions
extension Anasayfa: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return yemekListesi.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodCell", for: indexPath) as! FoodCollectionViewCell
        let yemek = yemekListesi[indexPath.row]
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi)") {
            cell.imageViewCell.kf.setImage(with: url)
                }
        cell.nameLabelCell.text = yemek.yemek_adi
        cell.priceLabelCell.text = "\(yemek.yemek_fiyat) ₺"
        cell.ekleButton = {[unowned self] in
            let secilenYemek = yemekListesi[indexPath.row]
            print(secilenYemek.yemek_adi)
            detayViewModel.sepeteEkle(yemek_adi: secilenYemek.yemek_adi, yemek_resim_adi: secilenYemek.yemek_resim_adi, yemek_fiyat: Int(secilenYemek.yemek_fiyat)!, yemek_siparis_adet: 1, kullanici_adi: "murat_kucuk") { basari in
                if basari{
                    self.sepeteEkleAlert(title: "BAŞARILI!", message: "\(secilenYemek.yemek_adi)  Sepete Eklendi")
                } else {
                    self.sepeteEkleAlert(title: "HATA!", message: "\(secilenYemek.yemek_adi) Sepete Eklenirken Hata Oluştu")
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let yemek = yemekListesi[indexPath.row]
        performSegue(withIdentifier: "toDetay", sender: yemek)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

//MARK: - SearchBar Functions
extension Anasayfa: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.yemekAra(aramaKelimesi: searchText)
    }
}

//MARK: - Supporting Functions
extension Anasayfa {
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

