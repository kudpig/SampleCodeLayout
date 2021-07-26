# SampleCodeLayout

制約を張り替えられる機能
レイアウトを全てコードで書いた

## プレビュー

<img src="https://i.gyazo.com/b9d568c536c67058e5ba691e6d83d6f2.gif" width="400">

## ソースコード
### AppDelegate

```swift
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        Router.showPreview(window: window)
        return true
    }

}
```

### Router

```swift
import UIKit

final class Router {
    
    private init() {}
       
    static func showPreview(window: UIWindow?) {
        let vc = PreviewViewController()
        let nav = UINavigationController(rootViewController: vc)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
    }
    
    static func showSetting(fromVC: UIViewController) {
        let vc = SettingViewController()
        let presenter = Presenter(outputSetting: vc, outputPreview: fromVC as! PreviewPresenterOutput)
        vc.inject(presenter: presenter)
        show(fromVC: fromVC, nextVC: vc)
    }
    
    static func backView(fromVC: UIViewController) {
        let vc = fromVC
        vc.navigationController?.popViewController(animated: true)
    }

    private static func show(fromVC: UIViewController, nextVC: UIViewController) {
        if let nav = fromVC.navigationController {
            nav.pushViewController(nextVC, animated: true)
        } else {
            fromVC.present(nextVC, animated: true, completion: nil)
        }
    }
    
    private static func back(fromVC: UIViewController) {
        if fromVC.navigationController == nil {
            fromVC.navigationController?.popViewController(animated: true)
        } else {
            fromVC.dismiss(animated: true, completion: nil)
        }
    }
}
```

### Presenter

```swift
import Foundation

// 設定画面からの入力
protocol SettingPresenterInput: AnyObject {
    func input(parameters: InputParameters)
}
// 設定画面への出力
protocol SettingPresenterOutput: AnyObject {
    func dismiss(permission: Bool) // 画面遷移の許可
    func getError(error: InputError)
}
// プレビューへの出力
protocol PreviewPresenterOutput: AnyObject {
    func update(model: ObjectConstraint) // 制約のModelを渡す
}

final class Presenter {
    
    private weak var outputSetting: SettingPresenterOutput? // View(設定画面)
    private weak var outputPreview: PreviewPresenterOutput? // View(プレビュー画面)
    
    private let data: InputData = InputData.shared
    
    init(outputSetting: SettingPresenterOutput, outputPreview: PreviewPresenterOutput) {
        self.outputSetting = outputSetting
        self.outputPreview = outputPreview
    }
    
}

extension Presenter: SettingPresenterInput {
    
    func input(parameters: InputParameters) {
        self.data.getModelData(parameters: parameters, completion: { [weak self] result in
            switch result {
            case .success(let model):
                self?.outputPreview?.update(model: model)
                self?.outputSetting?.dismiss(permission: true)
            case .failure(let error):
                self?.outputSetting?.getError(error: error)
            }
        })
        
    }
    
}
```

### PreviewViewController

```swift
import UIKit

class PreviewViewController: UIViewController {
    
    private var sampleX = NSLayoutConstraint()
    private var sampleY = NSLayoutConstraint()
    private var sampleWidth = NSLayoutConstraint()
    private var sampleHeight = NSLayoutConstraint()
    
    private var itemContsraint: ObjectConstraint = ObjectConstraint.createDefaultConstraint()
    
    private let itemView: UIView = {
        let itemView = UIView()
        itemView.backgroundColor = .systemGray
        return itemView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "プレビュー画面"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "設定",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSetting))
        
        itemView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(itemView)
        feachConstraint(constraint: self.itemContsraint)
        
        view.backgroundColor = .systemBackground
    }
    
    @objc private func didTapSetting() {
        Router.showSetting(fromVC: self)
    }
    
    private func feachConstraint(constraint: ObjectConstraint) {
        sampleX =  itemView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(constraint.topAnchorX))
        sampleY = itemView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: CGFloat(constraint.leftAnchorY))
        sampleWidth = itemView.widthAnchor.constraint(equalToConstant: CGFloat(constraint.widthAnchorInt))
        sampleHeight = itemView.heightAnchor.constraint(equalToConstant: CGFloat(constraint.heightAnchorInt))
        
        sampleX.isActive = true
        sampleY.isActive = true
        sampleWidth.isActive = true
        sampleHeight.isActive = true
        
        self.view.layoutIfNeeded()
    }
    
    private func reomoveConstraintAndReload() {
        itemView.removeConstraint(sampleX)
        itemView.removeConstraint(sampleY)
        itemView.removeConstraint(sampleWidth)
        itemView.removeConstraint(sampleHeight)
        self.loadView()
        self.viewDidLoad()
    }

}

extension PreviewViewController: PreviewPresenterOutput {
    
    func update(model: ObjectConstraint) {
        itemContsraint = model
        reomoveConstraintAndReload()
    }
    
}
```

### SettingViewController

```swift
import UIKit

class SettingViewController: UIViewController {
    
    private let titles = TitelForTextField.createTitles()
    private lazy var textFields = [textFieldX, textFieldY, textFieldWidth, textFieldHeight]
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "設置位置を入力してください"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }()
    
    private let textFieldX = UITextField()
    private let textFieldY = UITextField()
    private let textFieldWidth = UITextField()
    private let textFieldHeight = UITextField()
    
    private  let updateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("更新する", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.addTarget(self, action: #selector(tapUpdateButton), for: .touchUpInside)
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        return stackView
    }()
    
    private var presenter: SettingPresenterInput!
    func inject(presenter: SettingPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "設定画面"
        
        view.backgroundColor = .systemBackground
        
        setupFrame(self: stackView,
                   setX: 50,
                   setY: 30,
                   setWidth: view.frame.size.width-100,
                   setHeight: view.frame.size.height/2)
        setupStackViewContents()
        view.addSubview(stackView)
    }
    
    private func setupFrame(self: UIView, setX: CGFloat, setY: CGFloat, setWidth: CGFloat, setHeight: CGFloat) {
        self.frame = CGRect(x: setX,
                            y: setY,
                            width: setWidth,
                            height: setHeight)
    }
    
    private func setupStackViewContents() {
        
        self.stackView.addArrangedSubview(titleLabel)
        
        for (index, textfield) in textFields.enumerated() {
            textfield.setTextFieldParameters()
            textfield.addcloseToolbar()
            
            textfield.placeholder = titles[index].titleString
            self.stackView.addArrangedSubview(textfield)
        }
        
        self.stackView.addArrangedSubview(updateButton)
    }
    
    @objc private func tapUpdateButton() {
        textFieldX.resignFirstResponder()
        textFieldY.resignFirstResponder()
        textFieldWidth.resignFirstResponder()
        textFieldHeight.resignFirstResponder()
        
        let parameters = InputParameters(textX: textFieldX.text,
                                         textY: textFieldY.text,
                                         textWidth: textFieldWidth.text,
                                         textHeight: textFieldHeight.text)
        
        self.presenter.input(parameters: parameters)
    }
    
    private func alertError(message: String) {
        let alert = UIAlertController(title: "入力エラー", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "閉じる", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}

extension SettingViewController: SettingPresenterOutput {
    
    func dismiss(permission: Bool) {
        guard permission else {
            return
        }
        Router.backView(fromVC: self)
    }
    
    func getError(error: InputError) {
        self.alertError(message: error.errorDescription)
    }
    
}
```

### InputParameter(Model)

```swift
import Foundation

enum InputError: Error, LocalizedError {
    case notEnteredError, validationError, dataError
    var errorDescription: String {
        switch self {
        case .notEnteredError:
            return "入力されていない項目があります"
        case .validationError:
            return "数字が入力されていません"
        case .dataError:
            return "入力データに不正があります"
        }
    }
}

struct InputParameters {
    let textX: String?
    let textY: String?
    let textWidth: String?
    let textHeight: String?
    
}

struct InputData {
    
    static let shared = InputData()
    private init() {}
    
    func getModelData(parameters: InputParameters, completion: ((Result<ObjectConstraint, InputError>) -> Void)? = nil) {
        
        guard let textX = parameters.textX,
              let textY = parameters.textY,
              let textWidth = parameters.textWidth,
              let textHeight = parameters.textHeight,
              !textX.isEmpty,
              !textY.isEmpty,
              !textWidth.isEmpty,
              !textHeight.isEmpty else {
            completion?(.failure(.notEnteredError))
            return
        }
        
        guard let intX = NumberFormatter().number(from: textX) as? Int,
              let intY = NumberFormatter().number(from: textY) as? Int,
              let intWidth = NumberFormatter().number(from: textWidth) as? Int,
              let intHeight = NumberFormatter().number(from: textHeight) as? Int else {
            completion?(.failure(.validationError))
            return
        }
        
        let model = ObjectConstraint(topAnchorX: intX,
                                     leftAnchorY: intY,
                                     widthAnchorInt: intWidth,
                                     heightAnchorInt: intHeight)
        
        completion?(.success(model))
    }
    
}
```

### ObjectConstraint(Model)

```swift
import Foundation

struct ObjectConstraint {
    let topAnchorX: Int
    let leftAnchorY: Int
    let widthAnchorInt: Int
    let heightAnchorInt: Int
    
    static func createDefaultConstraint() -> ObjectConstraint {
        return ObjectConstraint(topAnchorX: 50, leftAnchorY: 50, widthAnchorInt: 50, heightAnchorInt: 50)
    }
}

```

### TextFieldExtension

```swift
import UIKit

struct TextFieldLayerParameters {
    var cornerRadius: CGFloat = 12
    var borderWidth: CGFloat = 1
    var borderColor: CGColor = UIColor.lightGray.cgColor
}

extension UITextField {
    
    func setTextFieldParameters(parameter: TextFieldLayerParameters = .init()) {
        
        self.layer.cornerRadius = parameter.cornerRadius
        self.layer.borderWidth = parameter.borderWidth
        self.layer.borderColor = parameter.borderColor
        
        self.backgroundColor = .white
        self.keyboardType = .numberPad
        self.returnKeyType = .default
        self.textAlignment = .center
    }
    
}

// NumberPadに閉じるボタンつける
extension UITextField {
    func addcloseToolbar(onClose: (target: Any, action: Selector)? = nil, onCancel: (target: Any, action: Selector)? = nil) {
        let onClose = onClose ?? (target: self, action: #selector(closeButtonTapped))

        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "閉じる", style: .plain, target: onClose.target, action: onClose.action)
        ]
        toolbar.sizeToFit()

        self.inputAccessoryView = toolbar
    }
    @objc func closeButtonTapped() { self.resignFirstResponder() }
}

struct TitelForTextField {
    
    let titleString: String
    
    static func createTitles() -> [TitelForTextField] {
        
        let createArray = [
            TitelForTextField(titleString: "Xを数字で入力"),
            TitelForTextField(titleString: "Yを数字で入力"),
            TitelForTextField(titleString: "Widthを数字で入力"),
            TitelForTextField(titleString: "Heightを数字で入力")
        ]
        
        return createArray
    }

}
```
