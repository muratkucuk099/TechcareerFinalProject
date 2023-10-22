//
//  KayitViewModel.swift
//  FoodOrderProject
//
//  Created by Mac on 21.10.2023.
//

import Foundation

class KayitViewModel {
    
    let yRepo = YemeklerDaoRepository()
    
    func kayitOl(name: String, userName: String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        yRepo.kayitOlma(name: name, userName: userName, email: email, password: password) { sonuc in
            completion(sonuc)
        }
    }
}
