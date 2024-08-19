import Foundation

class SepetManager {
    static let shared = SepetManager()
    
    private init() {}
    
    private(set) var sepetListesi: [Yemekler] = []
    
    func sepeteEkle(yemek: Yemekler) {
        sepetListesi.append(yemek)
    }
    
    func getSepetListesi() -> [Yemekler] {
        return sepetListesi
    }
    func removeYemekFromSepet(at index: Int) {
            if index >= 0 && index < sepetListesi.count {
                sepetListesi.remove(at: index)
            }
        }
}

