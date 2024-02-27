//
//  EntryViewModel.swift
//  NotesApp
//
//  Created by Emir Nasyrov on 24.02.2024.
//

import Foundation

final class NoteViewModel {
    // MARK: - Variables
    public var completion: ((String, String) -> Void)?
    private(set) var databaseManager: DBManagerProtocol
    
    // MARK: - Lifecycle
    init(_ databaseManager: DBManagerProtocol) {
        self.databaseManager = databaseManager
    }
    // MARK: - Actions
    func saveNote(with title: String, and note: String) {
        databaseManager.saveNote(title, note)
    }
}
