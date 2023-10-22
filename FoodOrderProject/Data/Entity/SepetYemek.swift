//
//  SepetYemek.swift
//  FoodOrderProject
//
//  Created by Mac on 12.10.2023.
//

import Foundation

class SepetYemek: Codable {
    let sepet_yemek_id: String?
    let yemek_adi: String
    let yemek_resim_adi: String
    let yemek_fiyat: String
    let yemek_siparis_adet: String
    let kullanici_adi: String
    
    init(sepet_yemek_id: String, yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: String, yemek_siparis_adet: String, kullanici_adi: String) {
        self.sepet_yemek_id = sepet_yemek_id
        self.yemek_adi = yemek_adi
        self.yemek_resim_adi = yemek_resim_adi
        self.yemek_fiyat = yemek_fiyat
        self.yemek_siparis_adet = yemek_siparis_adet
        self.kullanici_adi = kullanici_adi
    }
}
