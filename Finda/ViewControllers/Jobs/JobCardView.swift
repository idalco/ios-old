
import UIKit

class JobCardView: CardView {

    @IBOutlet weak var contentView: UIView!
    
    let presentedCardViewColor: UIColor = UIColor.FindaColors.White
    //UIColor.FindaColors.Purple.lighter(by: 77) ?? UIColor.FindaColors.Purple.fade()
    
    lazy var depresentedCardViewColor: UIColor = { return UIColor.FindaColors.White }()
    
    // { return UIColor.FindaColors.Purple.lighter(by: 80) ?? UIColor.FindaColors.Purple.fade() }()
    
    
    @IBOutlet weak var headerLabel: UILabel!
    var header: String = "" {
        didSet {
            headerLabel.text = "\(header)"
        }
    }

    
    @IBOutlet weak var jobNameLabel: UILabel!
    var jobName: String = "" {
        didSet {
            jobNameLabel.text = "\(jobName)"
        }
    }
    
    @IBOutlet weak var clientNameLabel: UILabel!
    var clientName: String = "" {
        didSet {
            clientNameLabel.text = "\(clientName)"
        }
    }
    
    @IBOutlet weak var jobTypeLabel: UILabel!
    var jobType: String = "" {
        didSet {
            jobTypeLabel.text = "\(jobType)"
        }
    }
    
    @IBOutlet weak var locationLabel: UILabel!
    var location: String = "" {
        didSet {
            locationLabel.text = "\(location)"
        }
    }
    
    @IBOutlet weak var jobDatesLabel: UILabel!
    var jobDates: String = "" {
        didSet {
            jobDatesLabel.text = "\(jobDates)"
        }
    }
    
    @IBOutlet weak var durationLabel: UILabel!
    var duration: String = "" {
        didSet {
            durationLabel.text = "\(duration)"
        }
    }
    
    @IBOutlet weak var jobDescriptionLabel: UILabel!
    var jobDescription: String = "" {
        didSet {
            jobDescriptionLabel.text = "\(jobDescription)"
        }
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius  = 10
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 2
        contentView.layer.borderColor = UIColor.FindaColors.Purple.cgColor
        //UIColor.FindaColors.Purple.fade(alpha: 0.2).cgColor
        
        presentedDidUpdate()
        
    }
    
    override var presented: Bool { didSet { presentedDidUpdate() } }
    
    func presentedDidUpdate() {
        
        removeCardViewButton.isHidden = !presented
        contentView.backgroundColor = presented ? presentedCardViewColor: depresentedCardViewColor
        contentView.addTransitionFade()
        
    }
    
    @IBOutlet weak var removeCardViewButton: UIButton!
    @IBAction func removeCardView(_ sender: Any) {
        walletView?.remove(cardView: self, animated: true)
    }
    
}
