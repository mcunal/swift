import UIKit
import Lottie

class SepetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SepetHucreDelegate {

    @IBOutlet weak var sepetTableView: UITableView!
    @IBOutlet weak var animationContainerView: UIView!
    @IBOutlet weak var totalFiyatLabel: UILabel!
    private var animationView: LottieAnimationView?

    var sepetListesi: [Yemekler] = []
    private let yemeklerDaoRepository = YemeklerDaoRepository()

    override func viewDidLoad() {
        super.viewDidLoad()

        sepetTableView.delegate = self
        sepetTableView.dataSource = self

        sepetListesi = SepetManager.shared.getSepetListesi()
        sepetTableView.reloadData()
        updateTotalFiyat()
        setupAnimationView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        sepetListesi = SepetManager.shared.getSepetListesi()
        sepetTableView.reloadData()
        updateTotalFiyat()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        animationView?.frame = animationContainerView.bounds
    }

    private func setupAnimationView() {
        if let animation = LottieAnimation.named("kurye") {
            animationView = LottieAnimationView(animation: animation)

            if let animationView = animationView {
                animationView.frame = animationContainerView.bounds
                animationView.contentMode = .scaleAspectFill
                animationView.loopMode = .loop

                animationContainerView.addSubview(animationView)
            }
        }
    }

    private func updateTotalFiyat() {
        var totalFiyat: Double = 0.0

        for yemek in sepetListesi {
            if let fiyatString = yemek.yemek_fiyat, let fiyat = Double(fiyatString) {
                totalFiyat += fiyat
            }
        }

        totalFiyatLabel.text = String(format: "\(totalFiyat)₺")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sepetListesi.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sepetHucre", for: indexPath) as! SepetHucre
        let yemek = sepetListesi[indexPath.row]

        cell.yemekAdLabel.text = yemek.yemek_adi
        cell.fiyatLabel.text = "\(yemek.yemek_fiyat!)₺"
        cell.delegate = self
        cell.indexPath = indexPath

        if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(yemek.yemek_resim_adi!)") {
            DispatchQueue.main.async {
                cell.yemekResimImageView.kf.setImage(with: url)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil") { (action, view, completionHandler) in
            let yemek = self.sepetListesi[indexPath.row]

            if let yemekId = yemek.yemek_id {
                self.yemeklerDaoRepository.yemekSil(yemekId: yemekId) { success in
                    if success {
                        self.sepetListesi.remove(at: indexPath.row)
                        SepetManager.shared.removeYemekFromSepet(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.updateTotalFiyat()
                    } else {
                        print("Yemek silme işlemi başarısız.")
                    }
                    completionHandler(true)
                }
            }
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    func didUpdateQuantity(_ quantity: Int, at indexPath: IndexPath) {
        if indexPath.row < sepetListesi.count {
            let yemek = sepetListesi[indexPath.row]
            yemek.yemek_fiyat = String(Double(quantity) * 10.0) // Örneğin: her bir yemek 10.0₺
            sepetListesi[indexPath.row] = yemek // Listede güncelle
            sepetTableView.reloadRows(at: [indexPath], with: .none)
            updateTotalFiyat()
        }
    }

    @IBAction func startAnimationButtonTapped(_ sender: UIButton) {
        animationView?.play()
    }
}

