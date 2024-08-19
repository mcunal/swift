import Foundation
import RxSwift

class AnasayfaViewModel {
    var yrepo = YemeklerDaoRepository()
    var yemeklerListesi = BehaviorSubject<[Yemekler]>(value: [Yemekler]())
    
    init() {
        yemeklerListesi = yrepo.yemeklerListesi
        yemekleriYukle()
    }
    
    func yemekleriYukle() {
        yrepo.yemekleriYukle()
    }
}

