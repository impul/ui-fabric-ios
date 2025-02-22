//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

// MARK: MSActionsCell

/**
 `MSActionsCell` is used to present a button or set of buttons (max of 2) as a row in a table view. After being added to the table view a target can be added to the button(s) with a corresponding action.

 `MSActionsCell` supports a maximum of 2 buttons that are displayed in a single row with a vertical separator between them. A button can be denoted 'destructive' by setting the 'action(X)IsDestructive' property to true. When true, this property causes the button to be displayed with red title label text to signify a 'destructive' action.
 */
open class MSActionsCell: UITableViewCell {
    public static let defaultHeight: CGFloat = 45
    public static let identifier: String = "MSActionsCell"

    // By design, an actions cell has 2 actions at most
    @objc public let action1Button = UIButton()
    @objc public let action2Button = UIButton()

    private let separator = MSSeparator(style: .default, orientation: .vertical)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(action1Button)
        contentView.addSubview(action2Button)
        contentView.addSubview(separator)

        backgroundColor = MSColors.Table.Cell.background
        action1Button.titleLabel?.font = MSTableViewCell.TextStyles.title.font
        action2Button.titleLabel?.font = MSTableViewCell.TextStyles.title.font
    }

    @objc public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Sets up the action cell with 1 or 2 actions. A 'destructive' action is displayed with red label text.
    ///
    /// - Parameters:
    ///   - action1Title: The title of the first action.
    ///   - action2Title: The title of the second action.
    ///   - action1IsDestructive: Bool describing if the first action is 'destructive'.
    ///   - action2IsDestructive: Bool describing if the second action is 'destructive'.
    @objc open func setup(action1Title: String, action2Title: String = "", action1IsDestructive: Bool = false, action2IsDestructive: Bool = false) {
        action1Button.setTitle(action1Title, for: .normal)
        action1Button.setTitleColor(actionTitleColor(isDestructive: action1IsDestructive, isHighlighted: false), for: .normal)
        action1Button.setTitleColor(actionTitleColor(isDestructive: action1IsDestructive, isHighlighted: true), for: .highlighted)

        let hasAction = !action2Title.isEmpty
        if hasAction {
            action2Button.setTitle(action2Title, for: .normal)
            action2Button.setTitleColor(actionTitleColor(isDestructive: action2IsDestructive, isHighlighted: false), for: .normal)
            action2Button.setTitleColor(actionTitleColor(isDestructive: action2IsDestructive, isHighlighted: true), for: .highlighted)
        }
        action2Button.isHidden = !hasAction
        separator.isHidden = !hasAction
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        let actionCount: CGFloat = action2Button.isHidden ? 1 : 2
        let singleActionWidth = UIScreen.main.roundToDevicePixels(contentView.width / actionCount)
        var left: CGFloat = 0

        action1Button.frame = CGRect(x: left, y: 0, width: singleActionWidth, height: height)
        left += action1Button.width

        if actionCount > 1 {
            action2Button.frame = CGRect(x: left, y: 0, width: width - left, height: height)
            separator.frame = CGRect(x: left, y: 0, width: separator.width, height: height)
        }
    }

    open override func prepareForReuse() {
        super.prepareForReuse()
        action1Button.removeTarget(nil, action: nil, for: .allEvents)
        action2Button.removeTarget(nil, action: nil, for: .allEvents)
    }

    open override func setHighlighted(_ highlighted: Bool, animated: Bool) { }

    open override func setSelected(_ selected: Bool, animated: Bool) { }

    private func actionTitleColor(isDestructive: Bool, isHighlighted: Bool) -> UIColor {
        if isDestructive {
            return isHighlighted ? MSColors.Table.ActionCell.textDestructiveHighlighted : MSColors.Table.ActionCell.textDestructive
        } else {
            return isHighlighted ? MSColors.Table.ActionCell.textHighlighted : MSColors.Table.ActionCell.text
        }
    }
}
