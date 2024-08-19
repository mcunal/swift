import Foundation
import RxSwift
import Alamofire

class YemeklerDaoRepository {
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    
    func yemekleriYukle() {
        AF.request("http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php", method: .get).response { response in
            if let data = response.data {
                do {
                    let cevap = try JSONDecoder().decode(YemeklerCevap.self, from: data)
                    if let liste = cevap.yemekler {
                        self.yemeklerListesi.onNext(liste)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Sepetten yemek silmek için String türünde yemek_id'yi kullanıyoruz
    func yemekSil(yemekId: String, completion: @escaping (Bool) -> Void) {
        let parameters: [String: Any] = ["yemek_id": yemekId]
        
        AF.request("http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php", method: .post, parameters: parameters, encoding: URLEncoding.default).response { response in
            if let error = response.error {
                print("Silme işlemi başarısız: \(error.localizedDescription)")
                completion(false)
            } else {
                // Başarılı ise true döndür
                completion(true)
            }
        }
    }
}

