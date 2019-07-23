//
//  BookController.swift
//  Reading List
//
//  Created by Taylor Lyles on 7/23/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

class BookController: Codable {
	
	private(set) var books = [Book]()
	
	// MARK: - Persistence
	
	func saveToPersistentStore() {
		guard let url = readingListURL else { return }
		
		do {
			let encoder = PropertyListEncoder()
			let booksData = try encoder.encode(books)
			try booksData.write(to: url)
		} catch {
			print("Error saving books data: \(error)")		}
	}
	
	func loadToPersistentStore() {
		let fm = FileManager.default
		guard let url = readingListURL,
			fm.fileExists(atPath: url.path) else { return }
		
		do {
			let data = try Data(contentsOf: url)
			let decoder = PropertyListDecoder()
			books = try decoder.decode([Book].self, from: data)
		} catch {
			print("Error loading books data: \(error)")
		}
	}
	
	// MARK: - Private
	
	private var readingListURL: URL? {
		let fm = FileManager.default
		guard let dir = fm.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
		return dir.appendingPathComponent("books.plist")
	}
	
}