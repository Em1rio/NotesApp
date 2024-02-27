//
//  ViewController.swift
//  NotesApp
//
//  Created by Emir Nasyrov on 24.02.2024.
//

import UIKit

final class NoteViewController: UIViewController {
    // MARK: - Variables
    var navController: UINavigationController?
    private(set) var viewModel: NoteViewModel
    var noteId: String?
    
    
    // MARK: - UI Components
    private(set) var titleField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private(set) var noteField: UITextView = {
        let noteField = UITextView()
        noteField.font = UIFont.systemFont(ofSize: 18)
        noteField.layer.cornerRadius = 8
        noteField.isScrollEnabled = true
        noteField.alwaysBounceVertical = true
        return noteField
    }()
    
    // MARK: - Lifecycle
    init(with viewModel: NoteViewModel, and navigationController: UINavigationController?) {
        self.viewModel = viewModel
        self.navController = navigationController
        super.init(nibName: nil, bundle: nil)
        self.title = "New Note"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done ,
                                                            target: self,
                                                            action: #selector(didTapSave))
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        self.titleField.becomeFirstResponder()
        setupTitleField()
        setupNoteField()
        setupRecognizer()
        
    }
    private func setupRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.numberOfTapsRequired = 2
        self.noteField.addGestureRecognizer(tap)
    }
    private func setupTitleField() {
        self.view.addSubview(titleField)
        self.titleField.translatesAutoresizingMaskIntoConstraints = false
        self.titleField.backgroundColor = .secondarySystemBackground
        self.titleField.placeholder = "Enter title..."
        self.titleField.setPadding(left: 5, right: 5)
        
        NSLayoutConstraint.activate([
            self.titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            self.titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            self.titleField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupNoteField() {
        self.view.addSubview(noteField)
        self.noteField.translatesAutoresizingMaskIntoConstraints = false
        self.noteField.backgroundColor = .secondarySystemBackground
        
        
        NSLayoutConstraint.activate([
            self.noteField.topAnchor.constraint(equalTo: self.titleField.bottomAnchor, constant: 10),
            self.noteField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            self.noteField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            self.noteField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Actions
    @objc func didTapSave() {
        if let title = titleField.text, !title.isEmpty, !noteField.text.isEmpty {
            if let id = noteId {
                viewModel.databaseManager.updateNote(id, withTitle: title, andNote: noteField.text)
            } else {
                viewModel.saveNote(with: title, and: noteField.text)
            }
            
            self.navController?.popToRootViewController(animated: true)
        }
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
 
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
            noteField.contentInset = contentInsets
            noteField.scrollIndicatorInsets = contentInsets

            // Скроллим содержимое UITextView так, чтобы курсор был виден над клавиатурой
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.height
            if !aRect.contains(noteField.frame.origin) {
                noteField.scrollRectToVisible(noteField.frame, animated: true)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        noteField.contentInset = contentInsets
        noteField.scrollIndicatorInsets = contentInsets
    }
    
}


extension UITextField {
    func setPadding(left: CGFloat, right: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.height))
        self.rightView = paddingViewRight
        self.rightViewMode = .always
    }
}
