//
//  Presenter.swift
//  SampleCodeLayout
//
//  Created by Shinichiro Kudo on 2021/07/24.
//

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
