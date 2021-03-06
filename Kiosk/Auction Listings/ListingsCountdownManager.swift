import UIKit
import RxSwift

class ListingsCountdownManager: NSObject {
   
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var countdownContainerView: UIView!
    let formatter = NSNumberFormatter()

    let sale = Variable<Sale?>(nil)

    let time = SystemTime()
    var provider: Networking! {
        didSet {
            time.sync(provider)
                .dispatchAsyncMainScheduler()
                .take(1)
                .subscribeNext { [weak self] (_) in
                    self?.startTimer()
                    self?.setLabelsHidden(false)
                }
                .addDisposableTo(rx_disposeBag)
        }
    }

    private var _timer: NSTimer? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        formatter.minimumIntegerDigits = 2
    }

    /// Immediately invalidates the timer. No further updates will be made to the UI after this method is called.
    func invalidate() {
        _timer?.invalidate()
    }

    func setFonts() {
        (countdownContainerView.subviews).forEach{ (view) -> () in
            if let label = view as? UILabel {
                label.font = UIFont.serifFontWithSize(15)
            }
        }
        countdownLabel.font = UIFont.sansSerifFontWithSize(20)
    }

    func setLabelsHidden(hidden: Bool) {
        countdownContainerView.hidden = hidden
    }

    func setLabelsHiddenIfSynced(hidden: Bool) {
        if time.inSync() {
            setLabelsHidden(hidden)
        }
    }

    func hideDenomenatorLabels() {
        for subview in countdownContainerView.subviews {
            subview.hidden = subview != countdownLabel
        }
    }

    func startTimer() {
        let timer = NSTimer(timeInterval: 0.49, target: self, selector: "tick:", userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)

        _timer = timer

        self.tick(timer)
    }
    
    func tick(timer: NSTimer) {
        guard let sale = sale.value else { return }
        guard time.inSync() else { return }
        guard sale.id != "" else { return }

        if sale.isActive(time) {
            let now = time.date()
            let components = NSCalendar.currentCalendar().components([.Hour, .Minute, .Second], fromDate: now, toDate: sale.endDate, options: [])

            self.countdownLabel.text = "\(formatter.stringFromNumber(components.hour)!) : \(formatter.stringFromNumber(components.minute)!) : \(formatter.stringFromNumber(components.second)!)"

        } else {
            self.countdownLabel.text = "CLOSED"
            hideDenomenatorLabels()
            timer.invalidate()
            _timer = nil
        }
    }
}
