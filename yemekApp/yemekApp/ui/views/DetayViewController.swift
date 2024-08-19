import UIKit
import Kingfisher
import Lottie

protocol DetayViewControllerDelegate: AnyObject {
    func didAddYemekToSepet(yemek: Yemekler)
}

class DetayViewController: UIViewController {
    weak var delegate: DetayViewControllerDelegate?

    @IBOutlet weak var labelYemekAd: UILabel!
    @IBOutlet weak var labelYemekFiyat: UILabel!
    @IBOutlet weak var imageViewYemek: UIImageView!
    @IBOutlet weak var lottieArea: LottieAnimationView!
    
    var yemek: Yemekler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let y = yemek {
            labelYemekAd.text = y.yemek_adi
            if let url = URL(string: "http://kasimadalan.pe.hu/yemekler/resimler/\(y.yemek_resim_adi!)") {
                DispatchQueue.main.async {
                    self.imageViewYemek.kf.setImage(with: url)
                }
                labelYemekFiyat.text = "\(y.yemek_fiyat!)₺"
            }
        }
        
        setupLottieAnimation()
    }
    
    func setupLottieAnimation() {
        lottieArea.animation = LottieAnimation.named("sepetekleme")
        lottieArea.loopMode = .playOnce
        lottieArea.animationSpeed = 1.0
    }
    
    @IBAction func buttonSepeteEkle(_ sender: UIButton) {
        lottieArea.play()
        
        if let y = yemek {
            delegate?.didAddYemekToSepet(yemek: y) // Delegate kullanımı
            print("\(y.yemek_adi!) sepete eklendi.")
        }
        
        
    }
}

