//
//  ListOfNotesViewController.swift
//  NotesApp
//
//  Created by Emir Nasyrov on 24.02.2024.
//

import UIKit

final class ListOfNotesViewController: UIViewController {
    // MARK: - Variables
    var navController: UINavigationController?
    private(set) var viewModel: ListOfNotesViewModel
    private var notes: [NoteModel]?
    
    // MARK: - UI Components
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    // MARK: - Lifecycle
    
    init(_ viewModel: ListOfNotesViewModel ) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        setupUI()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapNewNote))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        notes = viewModel.getAllNotes()
        self.tableView.reloadData()
    }
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupTableView()
    }
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.tableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor)
        ])
        
    }
    
    // MARK: - Actions
    @objc private func didTapNewNote() {
        let noteViewModel = NoteViewModel(self.viewModel.databaseManager)
        let vc = NoteViewController(with: noteViewModel, and: self.navController)
        vc.title = "New Note"
        navController?.navigationBar.prefersLargeTitles = true
        navController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - TableView Setup
extension ListOfNotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let notes = notes, !notes.isEmpty {
            return notes.count
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        var content = cell.defaultContentConfiguration()
        if let notes = notes, !notes.isEmpty {
            content.text = notes[indexPath.row].title
            content.secondaryText = notes[indexPath.row].note
        }
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let noteViewModel = NoteViewModel(self.viewModel.databaseManager)
        let vc = NoteViewController(with: noteViewModel, and: self.navController)
        vc.title = "Note"
        let selectedNote = viewModel.getAllNotes()[indexPath.row]
        vc.titleField.text = selectedNote.title
        vc.noteField.text = selectedNote.note
        vc.noteId = selectedNote.id
        navController?.navigationBar.prefersLargeTitles = true
        navController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Удаление записи из базы данных
            if let note = notes?[indexPath.row] {
                viewModel.databaseManager.deleteNote(note.id)
            }
            // Удаление ячейки из таблицы
            tableView.beginUpdates()
            notes?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    
}
