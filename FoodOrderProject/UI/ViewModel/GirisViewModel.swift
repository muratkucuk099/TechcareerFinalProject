//
//  GirisViewModel.swift
//  FoodOrderProject
//
//  Created by Mac on 21.10.2023.
//

import Foundation

class GirisViewModel {
    let yRepo = YemeklerDaoRepository()
    
    func giris(email: String, password: String, completion: @escaping (Error?) -> Void) {
        yRepo.girisYapma(email: email, password: password) { error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
}
