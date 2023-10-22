//
//  YemeklerDaoRepository.swift
//  FoodOrderProject
//
//  Created by Mac on 11.10.2023.
//

import Foundation
import RxSwift
import Alamofire
import FirebaseAuth
import FirebaseFirestore

class YemeklerDaoRepository {
    
    //http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php
    var yemekListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    var siparisYemekListesi = BehaviorSubject<[SepetYemek]>(value: [SepetYemek]())
    var toplamTutar = BehaviorSubject<Int>(value: Int())
    
    func yemekleriYukle() {
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(YemeklerCevap.self, from: data)
                    if let liste = cevap.yemekler {
                        self.yemekListesi.onNext(liste)
                    }
                    //                    let rawResponse = try JSONSerialization.jsonObject(with: data)
                    //                    print(rawResponse)
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func sepeteEkle(yemek_adi: String, yemek_resim_adi: String, yemek_fiyat: Int, yemek_siparis_adet: Int, kullanici_adi: String, completion: @escaping (Bool) ->Void) {
        var adet = 0
        sepetYemekleriGetir(kullanici_adi: kullanici_adi) { foods, error  in
            if let error = error {
                adet = yemek_siparis_adet
                print("Eğer hata varsa \(error.localizedDescription)")
                let params: Parameters = ["yemek_adi": yemek_adi, "yemek_resim_adi": yemek_resim_adi, "yemek_fiyat": yemek_fiyat, "yemek_siparis_adet": adet, "kullanici_adi": kullanici_adi]
                AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: params).response { reponse in
                    if let data = reponse.data {
                        do {
                            let cevap = try JSONDecoder().decode(SepetCevap.self, from: data)
                            print("Mesaj:  \(cevap.message)")
                            print("Başarı: \(cevap.success)")
                            if cevap.success == 0 {
                                completion(false)
                            } else {
                                completion(true)
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                if let yemekler = foods {
                    for yemek in yemekler {
                        if yemek.yemek_adi == yemek_adi {
                            adet = Int(yemek.yemek_siparis_adet)! + yemek_siparis_adet
                            self.yemekSil(sepet_yemek_id: Int(yemek.sepet_yemek_id!)!, kullanici_adi: yemek.kullanici_adi)
                            break
                        } else {
                            adet = yemek_siparis_adet
                        }
                    }
                }
                
                let params: Parameters = ["yemek_adi": yemek_adi, "yemek_resim_adi": yemek_resim_adi, "yemek_fiyat": yemek_fiyat, "yemek_siparis_adet": adet, "kullanici_adi": kullanici_adi]
                AF.request("http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php", method: .post, parameters: params).response { reponse in
                    if let data = reponse.data {
                        do {
                            let cevap = try JSONDecoder().decode(SepetCevap.self, from: data)
                            print("Mesaj:  \(cevap.message)")
                            print("Başarı: \(cevap.success)")
                            if cevap.success == 0 {
                                completion(false)
                            } else {
                                completion(true)
                            }
                            
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func sepetYemekleriGetir(kullanici_adi: String) {
        var tutar = 0
        let params: Parameters = ["kullanici_adi": kullanici_adi]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(SepettekiYemeklerCevap.self, from: data)
                    if let liste = cevap.sepet_yemekler {
                        self.siparisYemekListesi.onNext(liste)
                        for yemek in liste {
                            tutar += Int(yemek.yemek_siparis_adet)! * Int(yemek.yemek_fiyat)!
                            self.toplamTutar.onNext(tutar)
                        }
                        print("Toplam tutar \(tutar)")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func sepetYemekleriGetir(kullanici_adi: String, completion: @escaping([SepetYemek]?, Error?) -> Void) {
        var tutar = 0
        let params: Parameters = ["kullanici_adi": kullanici_adi]
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php", method: .post, parameters: params).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(SepettekiYemeklerCevap.self, from: data)
                    if let liste = cevap.sepet_yemekler {
                        self.siparisYemekListesi.onNext(liste)
                        for yemek in liste {
                            tutar += Int(yemek.yemek_siparis_adet)! * Int(yemek.yemek_fiyat)!
                            self.toplamTutar.onNext(tutar)
                        }
                        completion(liste, nil)
                    }
                } catch {
                    print(error.localizedDescription)
                    completion(nil, error)
                }
            }
        }
    }
    
    func yemekAra(aramaKelimesi:String){
        var arananYemeklerListe = [Yemekler]()
        if aramaKelimesi != "" {
            AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
                if let data = response.data {
                    do{
                        let cevap = try JSONDecoder().decode(YemeklerCevap.self, from: data)
                        if let liste = cevap.yemekler {
                            for yemekler in liste {
                                if yemekler.yemek_adi.contains(aramaKelimesi) {
                                    arananYemeklerListe.append(yemekler)
                                }
                            }
                            self.yemekListesi.onNext(arananYemeklerListe)
                        }
                        //                    let rawResponse = try JSONSerialization.jsonObject(with: data)
                        //                    print(rawResponse)
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            yemekleriYukle()
        }
    }
    
    func yemekSil(sepet_yemek_id: Int, kullanici_adi: String) {
        //http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php
        let params:Parameters = ["sepet_yemek_id": sepet_yemek_id, "kullanici_adi": kullanici_adi]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php",method: .post,parameters: params).response { response in
            if let data = response.data {
                do{
                    let cevap = try JSONDecoder().decode(SepetCevap.self, from: data)
                    print("Başarı Silme : \(cevap.success!)")
                    print("Mesaj  : \(cevap.message!)")
                    self.sepetYemekleriGetir(kullanici_adi: kullanici_adi) { sepetYemek, error in
                        if let error = error {
                            self.toplamTutar.onNext(0)
                        } else {
                            
                        }
                    }
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func kayitOlma(name: String, userName: String, email: String?, password: String?, completion: @escaping (Bool) -> Void) {
        if let mail = email, let sifre = password {
            let user = Kisiler(name: name, userName: userName, email: mail, password: sifre)
            let data = ["name": user.name, "userName": user.userName, "email": user.email, "password": user.password]
            Auth.auth().createUser(withEmail: mail, password: sifre) { authResult, error in
                if error == nil {
                    print("Kullanıcı başarıyla oluşturuldu")
                    let db = Firestore.firestore()
                    let userCollection = db.collection("Users").document(authResult?.user.uid ?? "").collection(user.email)
                    userCollection.document("UserInfo").setData(data) { error in
                        if let error = error {
                            print("Kullanıcı dökümanı oluşturulurken hata oluştu!")
                            completion(false)
                        } else {
                            print("Kullanıcı dökümanı oluşturuldu")
                            completion(true)
                        }
                    }
                } else {
                    print("Kullanıcı oluşturulurken hata oluştu!")
                    completion(false)
                }
            }
        }        
    }
    
    func girisYapma(email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }
    
    func kullaniciVerileriGetir(completion: @escaping (Kisiler) -> Void) {
        let db = Firestore.firestore()
        if let user = Auth.auth().currentUser {
            let userCollection = db.collection("Users").document(user.uid).collection(user.email!).document("UserInfo")
            userCollection.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let userData = document.data() {
                        if let name = userData["name"] as? String,
                        let userName = userData["userName"] as? String,
                        let email = userData["email"] as? String,
                           let password = userData["password"] as? String {
                            let user = Kisiler(name: name, userName: userName, email: email, password: password)
                            completion(user)
                        }
                    }
                } else {
                    print("Kullanıcı belgesi bulunamadı veya bir hata oluştu.")
                }
            }
        }

    }
}
