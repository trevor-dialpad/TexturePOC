import AnchorKit
import AsyncDisplayKit
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

class UIKitViewController: UIViewController {
    private let tableView: UITableView = .init()

    private let datasource: [String] = (0..<200000).map { "Row \($0)" }

    init() {
        super.init(nibName: nil, bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UIKitCustomCell.self, forCellReuseIdentifier: "UIKitCustomCell")
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        [tableView].forEach(view.addSubview)
        tableView.constrainEdges(to: view)
    }
}

extension UIKitViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UIKitCustomCell") as? UIKitCustomCell else { return .init() }
        let item = datasource[indexPath.row]
        cell.configure(item: item)
        return cell
    }
}

extension UIKitViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

final class UIKitCustomCell: UITableViewCell {
    private let label: UILabel = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        label.textAlignment = .center
        contentView.addSubview(label)
        label.constrainEdges(to: contentView).inset(.init(top: 8, left: 0, bottom: 8, right: 0))
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    func configure(item: String) {
        label.text = item
    }
}

// MARK: - Texture Example

class TextureViewController: UIViewController {
    private let tableNode: ASTableNode = .init()
    private let inputComposer: ASEditableTextNode = .init()

    private let datasource: [String] = (0..<100).map { "Row \($0)" }

    init() {
        super.init(nibName: nil, bundle: nil)
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.inverted = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        tableNode.dataSource = self
        tableNode.delegate = self
        tableNode.inverted = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        [tableNode.view].forEach(view.addSubview)

        view.addSubview(inputComposer.view)
        inputComposer.view.backgroundColor = .green
        inputComposer.view.constrainHeight(to: 80.0)
        inputComposer.attributedPlaceholderText = NSAttributedString(string: "Type something here...")
        inputComposer.attributedText = NSAttributedString(string: "Lorem ipsum dolor sit amet.")
        inputComposer.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        inputComposer.view.constrain(.leading, .trailing, to: view)
        inputComposer.view.constrain(.bottom, to: .top, of: view.keyboardLayoutGuide)
        tableNode.view.constrain(.leading, .top, .trailing, to: view)
        tableNode.view.constrain(.bottom, to: .top, of: inputComposer.view)
        tableNode.view.backgroundColor = .blue
        tableNode.view.keyboardDismissMode = .interactive

        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        let textFieldOnKeyboard = view.keyboardLayoutGuide.topAnchor.constraint(equalTo: inputComposer.view.bottomAnchor)
        view.keyboardLayoutGuide.setConstraints([textFieldOnKeyboard], activeWhenAwayFrom: .top)
   }
}

extension TextureViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        datasource.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let item = datasource[indexPath.row]
        return {
            let cellNode = CustomCellNode(item: item)
            return cellNode
        }
    }
}

extension TextureViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
    }
}

final class CustomCellNode: ASCellNode {
    private let textNode: ASTextNode = .init()

    init(item: String) {
        super.init()
        automaticallyManagesSubnodes = true
        textNode.attributedText = .init(string: item, attributes: [.foregroundColor: UIColor.black, .font: UIFont.systemFont(ofSize: 18, weight: .regular)])
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let centerText = ASCenterLayoutSpec(horizontalPosition: .center, verticalPosition: .center, sizingOption: .minimumHeight, child: textNode)
        let inset = ASInsetLayoutSpec(insets: .init(top: 8, left: 0, bottom: 8, right: 0), child: centerText)
        return inset
    }
}
