import UIKit
import Lottie
import Kingfisher

class AnasayfaViewController: UIViewController {

    var sepettekiUrunler: [Yemekler] = []
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var yemeklerTableView: UITableView!
    @IBOutlet weak var animationContainerView: UIView!
    
    var yemeklerListesi = [Yemekler]()
    var filteredYemeklerListesi = [Yemekler]() // Filtrelenmiş yemekler için dizi
    
    var viewModel = AnasayfaViewModel()
    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        yemeklerTableView.delegate = self
        yemeklerTableView.dataSource = self
        searchBar.delegate = self // UISearchBar delegate'i ayarla
        
        _ = viewModel.yemeklerListesi.subscribe(onNext: { liste in
            self.yemeklerListesi = liste
            self.filteredYemeklerListesi = liste // İlk yüklemede filtrelenmiş listeyi eşitle
            self.yemeklerTableView.reloadData()
        })
        
        yemeklerTableView.separatorColor = UIColor(white: 1, alpha: 1) // Aradaki çizgiyi gizle
        
        let animation = LottieAnimation.named("food")
        animationView = LottieAnimationView(animation: animation)
        
        if let animationView = animationView {
            animationView.frame = animationContainerView.bounds
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationContainerView.addSubview(animationView)
            animationView.play()
        }
    }

    func sepeteEkleTiklandi(indexPath: IndexPath) {
        let yemek = filteredYemeklerListesi[indexPath.row] // filteredYemeklerListesi kullanın
        SepetManager.shared.sepeteEkle(yemek: yemek) // SepetManager kullanımı
        print("\(yemek.yemek_adi!) sepete eklendi.")
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetay" {
            if let yemek = sender as? Yemekler {
                let detayVC = segue.destination as! DetayViewController
                detayVC.yemek = yemek
                detayVC.delegate = self // Delegate ayarla
            }
        } else if segue.identifier == "toSepet" {
            let sepetVC = segue.destination as! SepetViewController
            // SepetViewController'da herhangi bir şey yapmaya gerek yok, SepetManager'dan veri alır
        }
    }
}

extension AnasayfaViewController: UITableViewDelegate, UITableViewDataSource, HucreProtokol {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredYemeklerListesi.count // Filtrelenmiş listeyi kullanın
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let hucre = tableView.dequeueReusableCell(withIdentifier: "yemeklerHucre", for: indexPath) as! YemeklerHucre
        let yemek = filteredYemeklerListesi[indexPath.row] // Filtrelenmiş listeyi kullanın
        
        hucre.yemekAdLabel.text = yemek.yemek_adi
        hucre.fiyatLabel.text = "\(yemek.yemek_fiyat!)₺"
        
        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                hucre.imageViewYemek.kf.setImage(with: url)
            }
        }
        
        hucre.hucreProtocol = self
        hucre.indexPath = indexPath
        
        return hucre
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let yemek = filteredYemeklerListesi[indexPath.row] // Filtrelenmiş listeyi kullanın
        performSegue(withIdentifier: "toDetay", sender: yemek)
    }
}

extension AnasayfaViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredYemeklerListesi = yemeklerListesi // Arama metni boşsa tüm yemekleri göster
        } else {
            filteredYemeklerListesi = yemeklerListesi.filter { $0.yemek_adi?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        yemeklerTableView.reloadData() // Tabloyu güncelle
    }
}

extension AnasayfaViewController: DetayViewControllerDelegate {
    func didAddYemekToSepet(yemek: Yemekler) {
        SepetManager.shared.sepeteEkle(yemek: yemek) // SepetManager kullanımı
    }
}

