import Foundation
import UIKit

class Input : UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        construct()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        construct()
    }
    private func construct() {
        self.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0)
    }
}
