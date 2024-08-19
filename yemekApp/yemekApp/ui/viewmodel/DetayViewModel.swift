import Foundation
import RxSwift

class DetayViewModel {
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


