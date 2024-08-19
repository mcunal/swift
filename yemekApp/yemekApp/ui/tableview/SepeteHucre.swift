import UIKit

protocol SepetHucreDelegate: AnyObject {
    func didUpdateQuantity(_ quantity: Int, at indexPath: IndexPath)
}

class SepetHucre: UITableViewCell {

    weak var delegate: SepetHucreDelegate?
    @IBOutlet weak var labelStepper: UIStepper!
    @IBOutlet weak var adetlabel: UILabel!
    @IBOutlet weak var yemekAdLabel: UILabel!
    @IBOutlet weak var fiyatLabel: UILabel!
    @IBOutlet weak var yemekResimImageView: UIImageView!
    var indexPath: IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func stepperAdet(_ sender: UIStepper) {
        let quantity = Int(sender.value)
        adetlabel.text = String(quantity)
        if let indexPath = indexPath {
            delegate?.didUpdateQuantity(quantity, at: indexPath)
        }
    }
}

