//
//  DetaySayfaViewModel.swift
//  FoodOrderProject
//
//  Created by Mac on 13.10.2023.
//

import Foundation

class DetaySayfaViewModel {
    let yRepo = YemeklerDaoRepository()
    
    func sepeteEkle(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, kullanici_adi: String, completion: @escaping (Bool) -> Void) {
        yRepo.sepeteEkle(yemek_adi: yemek_adi, yemek_resim_adi: yemek_resim_adi, yemek_fiyat: yemek_fiyat, yemek_siparis_adet: yemek_siparis_adet, kullanici_adi: kullanici_adi) { basari in
            completion(basari)
        }
    }
}
