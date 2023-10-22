//
//  SepetViewModel.swift
//  FoodOrderProject
//
//  Created by Mac on 13.10.2023.
//

import Foundation
import RxSwift

class SepetViewModel {
    let yRepo = YemeklerDaoRepository()
    var yemeklerListesi = BehaviorSubject<[SepetYemek]>(value: [SepetYemek]())
    var toplamTutar = BehaviorSubject<Int>(value: Int())

    
    init() {
        yemeklerListesi = yRepo.siparisYemekListesi
        toplamTutar = yRepo.toplamTutar
    }
    
    func sepetYemekGetir(kullanici_adi: String) {
        yRepo.sepetYemekleriGetir(kullanici_adi: kullanici_adi)
    }
    
    func sepetYemekSil(sepet_yemek_id: Int, kullanici_adi: String) {
        yRepo.yemekSil(sepet_yemek_id: sepet_yemek_id, kullanici_adi: kullanici_adi)
    }
}
