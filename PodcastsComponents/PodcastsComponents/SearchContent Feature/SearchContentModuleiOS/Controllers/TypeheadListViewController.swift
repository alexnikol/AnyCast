// Copyright © 2022 Almost Engineer. All rights reserved.

import UIKit
import SharedComponentsiOSModule

public protocol TypeheadListViewControllerDelegate {
    func searchTextDidChange(term: String)
}

public class TypeheadListViewController: ListViewController {
    
    private var searchDelegate: TypeheadListViewControllerDelegate?
    
    public init(searchDelegate: TypeheadListViewControllerDelegate, tableConfig: ListTableViewConfiguratior = .default) {
        self.searchDelegate = searchDelegate
        super.init(refreshController: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        subscribeOnKeyboardEvents()
    }
    
    private func subscribeOnKeyboardEvents() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?, UIApplication.shared.applicationState == .active else { return }
        let keyboardSize = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size

        if let keyboardHeight = keyboardSize?.height {
            let finalHeight = keyboardHeight - view.safeAreaInsets.bottom
            self.additionalSafeAreaInsets = .init(top: 0, left: 0, bottom: finalHeight, right: 0)
        }
    }

    @objc
    private func keyboardWillHide(_ notification: Notification) {
        self.additionalSafeAreaInsets = .zero
    }
}

extension TypeheadListViewController: UISearchBarDelegate {
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchDelegate?.searchTextDidChange(term: searchText)
    }
}
