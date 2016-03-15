//
// Created by Maxim Pervushin on 05/03/16.
// Copyright (c) 2016 Maxim Pervushin. All rights reserved.
//

import UIKit

class ChatConfigurationCell: UITableViewCell {

    static let defaultReuseIdentifier = "ChatConfigurationCell"

    @IBOutlet weak var serverNameLabel: UILabel?
    @IBOutlet weak var serverBackendURLLabel: UILabel?
    @IBOutlet weak var serverNotificationsLabel: UILabel?
    @IBOutlet weak var editorLeadingConstraint: NSLayoutConstraint?
    @IBOutlet weak var autoconnectButton: UIButton?

    @IBAction func deleteButtonAction(sender: AnyObject) {
        delegate?.chatConfigurationCellDidDelete(self)
    }

    @IBAction func autoconnectButtonAction(sender: AnyObject) {
        delegate?.chatConfigurationCellDidToggleAutoconnect(self)
    }

    @objc func swipeLeftAction(sender: AnyObject) {
        if !editing {
            setEditing(true, animated: true)
        }
    }

    @objc func swipeRightAction(sender: AnyObject) {
        if editing {
            setEditing(false, animated: true)
        }
    }

    weak var delegate: ChatConfigurationCellDelegate?

    var chatConfiguration: ChatConfiguration? {
        didSet {
            serverNameLabel?.text = chatConfiguration?.name
            serverBackendURLLabel?.text = chatConfiguration?.backendURL.absoluteString

            var autoconnectTitle = NSLocalizedString("Autoconnect: Off", comment: "Autoconnect Button Title: Off")
            var autoconnectColor = UIColor.orangeColor()
            if let chatConfiguration = chatConfiguration where chatConfiguration.autoconnect {
                autoconnectTitle = NSLocalizedString("Autoconnect: On", comment: "Autoconnect Button Title: On")
                autoconnectColor = UIColor.greenColor()
            }
            autoconnectButton?.setTitle(autoconnectTitle, forState: .Normal)
            autoconnectButton?.backgroundColor = autoconnectColor
        }
    }

    var notificationsCount = 0 {
        didSet {
            if notificationsCount > 0 {
                serverNotificationsLabel?.hidden = false
                serverNotificationsLabel?.text = "\(notificationsCount)"
            } else {
                serverNotificationsLabel?.hidden = true
            }
        }
    }

    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if let editorToLeftConstraint = editorLeadingConstraint {
            layoutIfNeeded()
            let width = frame.size.width
            editorToLeftConstraint.constant = editing ? 0 : width
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [.CurveEaseInOut], animations: {
                () -> Void in
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }

    private func commonInit() {
        let leftSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeLeftAction:")
        leftSwipeRecognizer.numberOfTouchesRequired = 1
        leftSwipeRecognizer.direction = .Left
        addGestureRecognizer(leftSwipeRecognizer)

        let rightSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: "swipeRightAction:")
        rightSwipeRecognizer.numberOfTouchesRequired = 1
        rightSwipeRecognizer.direction = .Right
        addGestureRecognizer(rightSwipeRecognizer)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }


}

protocol ChatConfigurationCellDelegate: class {

    func chatConfigurationCellDidDelete(cell: ChatConfigurationCell)

    func chatConfigurationCellDidToggleAutoconnect(cell: ChatConfigurationCell)
}