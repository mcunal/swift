import UIKit

protocol HucreProtokol: AnyObject {
    func sepeteEkleTiklandi(indexPath: IndexPath)
}

class YemeklerHucre: UITableViewCell {

    @IBOutlet weak var fiyatLabel: UILabel!
    @IBOutlet weak var yemekAdLabel: UILabel!
    @IBOutlet weak var imageViewYemek: UIImageView!
    @IBOutlet weak var hucreArkaPlan: UIView!
    
    weak var hucreProtocol: HucreProtokol?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func sepeteEkleButton(_ sender: Any) {
        if let indexPath = indexPath {
            hucreProtocol?.sepeteEkleTiklandi(indexPath: indexPath)
        } else {
            print("indexPath mevcut değil")
        }
    }
}

