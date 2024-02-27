//
//  DBManager.swift
//  NotesApp
//
//  Created by Emir Nasyrov on 26.02.2024.
//

import Foundation
import RealmSwift

protocol DBManagerProtocol {
    func getAllNotes() -> [NoteModel]
    func saveNote(_ title: String, _ note: String)
    func updateNote(_ id: String, withTitle title: String, andNote note: String)
    func deleteNote(_ id: String)
}

struct DBManager: DBManagerProtocol {
    // MARK: - Variables
    private(set) var realm: Realm
    private var notesInDB: Results<NoteModel>
    
    // MARK: - Lifecycle
    init() {
        do { realm = try Realm()
            notesInDB = realm.objects(NoteModel.self)
            if notesInDB.isEmpty {
                saveDefaultNote()
            }
        } catch {
            fatalError("Ошибка при инициализации Realm: \(error)")
        }
    }
    // MARK: - Actions
    func getAllNotes() -> [NoteModel] {
        return Array(notesInDB)
    }
    
    func saveNote(_ title: String, _ note: String) {
        let newNote = NoteModel()
        let id = UUID().uuidString
        print(id)
        newNote.id = id
        newNote.title = title
        newNote.note = note
        do {
            try realm.write {
                realm.add(newNote)
            }
        } catch {
            fatalError("Ошибка при инициализации Realm: \(error)")
        }
    }
    
    private func saveDefaultNote() {
        saveNote("Первая заметка", "Добро пожаловать в приложение \"Заметки\"! Здесь ты можешь писать все что пожалаешь")
    }
    
    private func getNoteId(_ id: String) -> NoteModel? {
        return notesInDB.filter("id = %@", id).first
    }
    
    func updateNote(_ id: String, withTitle title: String, andNote note: String) {
        if let existingNote = getNoteId(id) {
            do {
                try realm.write {
                    existingNote.title = title
                    existingNote.note = note
                }
            } catch {
                fatalError("Ошибка при обновлении заметки: \(error)")
            }
        } else {
            print("Заметка с id \(id) не найдена")
        }
    }
    
    func deleteNote(_ id: String) {
        guard let noteToDeleate = notesInDB.first(where: { $0.id == id }) else {
            return
        }
        do {
            try realm.write {
                realm.delete(noteToDeleate)
            }
        } catch {
            print("Ошибка при удалении записи из базы данных: \(error)")
        }
    }
    
    
}


