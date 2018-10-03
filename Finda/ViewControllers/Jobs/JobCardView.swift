
import UIKit
import DCKit

class JobCardView: CardView {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var topColourBar: UILabel!
    
    let presentedCardViewColor: UIColor = UIColor.FindaColours.White
    //UIColor.FindaColors.Purple.lighter(by: 77) ?? UIColor.FindaColors.Purple.fade()
    
    lazy var depresentedCardViewColor: UIColor = { return UIColor.FindaColours.White }()
    
    // { return UIColor.FindaColors.Purple.lighter(by: 80) ?? UIColor.FindaColors.Purple.fade() }()
    
    
    @IBOutlet weak var headerLabel: UILabel!
    var header: String = "" {
        didSet {
            headerLabel.text = "\(header)"
//            switch(header) {
//            case "PENDING":
//                contentView.layer.borderColor = UIColor.FindaColours.DarkYellow.cgColor
//                contentView.layer.addBorder(edge: .top, color: UIColor.FindaColours.DarkYellow, thickness: 5.0)
//                break
//                
//            case "ACCEPTED":
//                contentView.layer.borderColor = UIColor.FindaColours.Blue.cgColor
//                contentView.layer.addBorder(edge: .top, color: UIColor.FindaColours.Blue, thickness: 5.0)
//                break
//                
//            case "OFFERED":
//                contentView.layer.borderColor = UIColor.FindaColours.DarkYellow.cgColor
//                contentView.layer.addBorder(edge: .top, color: UIColor.FindaColours.DarkYellow, thickness: 5.0)
//                break
//                
//            case "MODEL_COMPLETED":
//                headerLabel.text = "COMPLETED"
//                contentView.layer.borderColor = UIColor.FindaColours.Purple.cgColor
//                contentView.layer.addBorder(edge: .top, color: UIColor.FindaColours.Purple, thickness: 5.0)
//                break
//                
//            case "OPTIONED":
//                contentView.layer.borderColor = UIColor.FindaColours.DarkYellow.cgColor
//                contentView.layer.addBorder(edge: .top, color: UIColor.FindaColours.DarkYellow, thickness: 5.0)
//                break
//                
//            case "COMPLETED":
//                contentView.layer.borderColor = UIColor.FindaColours.Black.cgColor
//                contentView.layer.addBorder(edge: .top, color: UIColor.FindaColours.Black, thickness: 5.0)
//                break
//                
//            default:
//                break
//            }
            
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
    
    @IBOutlet weak var offeredLabel: UILabel!
    @IBOutlet weak var offeredNumberButton: UIButton!
    var offeredNumber: String = "" {
        didSet {
            offeredNumberButton.setTitle("\(offeredNumber)", for: .normal)
        }
    }
    
    
    @IBOutlet weak var primaryButton: DCRoundedButton!
    @IBAction func primaryButtonFunc(_ sender: Any) {
        
    }
        
        
    @IBOutlet weak var secondaryButton: DCRoundedButton!
    @IBAction func seconaryButtonFunc(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.cornerRadius  = 10
        contentView.layer.masksToBounds = false
        contentView.layer.borderWidth = 0
//        contentView.layer.borderColor = UIColor.FindaColours.DarkYellow.cgColor
        
//        contentView.layoutIfNeeded()
//        contentView.layer.addBorder(edge: .top, color: UIColor.FindaColours.DarkYellow, thickness: 5.0)
        
        contentView.layer.shadowColor = UIColor.FindaColours.Black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        contentView.layer.shadowRadius = 10.0
        contentView.layer.shadowOpacity = 0.4
        
        //UIColor.FindaColors.Purple.fade(alpha: 0.2).cgColor
        
        offeredNumberButton.isHidden = true
        offeredNumberButton.isEnabled = false
//        offeredNumberButton.layer.borderColor = UIColor.FindaColours.BorderGrey.cgColor
//        offeredNumberButton.layer.borderWidth = 2
//        offeredNumberButton.layer.cornerRadius = 5
        
        offeredLabel.isHidden = true
        
        primaryButton.normalBackgroundColor = UIColor.FindaColours.Blue
        primaryButton.normalTextColor = UIColor.FindaColours.White
        
        secondaryButton.normalBackgroundColor = UIColor.FindaColours.Black
        secondaryButton.normalTextColor = UIColor.FindaColours.White

        
        presentedDidUpdate()
        
    }
    
    override var presented: Bool { didSet { presentedDidUpdate() } }
    
    func presentedDidUpdate() {
        
//        primaryButton.isHidden = !presented
//        seconaryButton.isHidden = !presented
        contentView.backgroundColor = presented ? presentedCardViewColor: depresentedCardViewColor
        contentView.addTransitionFade()
        
    }
    
    
    
}

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        
        switch edge {
            case UIRectEdge.top:
                border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
                break
            
            case UIRectEdge.bottom:
                border.frame = CGRect(x:0, y:self.frame.height - thickness, width:self.frame.width, height:thickness)
                break
            
            case UIRectEdge.left:
                border.frame = CGRect(x:0, y:0, width: thickness, height: self.frame.height)
                break
            
            case UIRectEdge.right:
                border.frame = CGRect(x:self.frame.width - thickness, y: 0, width: thickness, height:self.frame.height)
                break
            
            default:
                break
        }
        
        
        
        if #available(iOS 11.0, *) {
            border.cornerRadius = 10.0
            border.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
//            let rectShape = CAShapeLayer()
//            rectShape.bounds = self.frame
//            rectShape.position = border.center
//            rectShape.path = UIBezierPath(roundedRect: border.frame.bounds,    byRoundingCorners: [.topRight , .topLeft], cornerRadii: CGSize(width: 10, height: 10)).cgPath
//            border.mask = rectShape
        }
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
    
}

extension UIView {
    func maskByRoundingCorners(_ masks:UIRectCorner, withRadii radii:CGSize = CGSize(width: 10, height: 10)) {
        let rounded = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: masks, cornerRadii: radii)
        
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        
        self.layer.mask = shape
    }
}
