//
//  KViewModel.swift
//  FoodOrderProject
//
//  Created by Mac on 22.10.2023.
//

import Foundation

class KViewModel {
    let yRepo = YemeklerDaoRepository()
    
    func kisiBilgileriGetir(completion: @escaping(Kisiler) -> Void) {        
        yRepo.kullaniciVerileriGetir { kisi in
            completion(kisi)
        }
    }
}
