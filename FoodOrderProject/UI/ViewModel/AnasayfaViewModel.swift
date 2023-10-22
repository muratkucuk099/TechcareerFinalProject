//
//  AnasayfaViewModel.swift
//  FoodOrderProject
//
//  Created by Mac on 11.10.2023.
//

import Foundation
import RxSwift

class AnasayfaViewModel {
    let yRepo = YemeklerDaoRepository()
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    
    init() {
        yemeklerListesi = yRepo.yemekListesi
    }
    
    func yemekleriYukle() {
        yRepo.yemekleriYukle()
    }
    
    func yemekAra(aramaKelimesi: String) {
        yRepo.yemekAra(aramaKelimesi: aramaKelimesi)
    }
}
