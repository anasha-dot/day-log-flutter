# day-log-flutter

This repository contains a minimal Flutter implementation of a diary app. The main feature implemented is a screen to create new diary entries and save them to a Firestore collection called **`entries`**.

## Firestore

Diary entries are stored in the collection `/entries`. Each document has the following fields:

- `text` – body of the entry
- `tag` – optional tag for categorizing entries
- `visibility` – either `public` or `private`
- `mediaUrl` – optional URL of an uploaded photo
- `createdAt` – server timestamp

## Running the app

Configure Firebase for your Flutter project and ensure `firebase_core`, `cloud_firestore`, `firebase_storage` and `image_picker` dependencies are installed. Launch the app as a normal Flutter application. The home screen lets you create a new entry with text, tag, visibility and an optional image. Once saved, the entry document appears in the `/entries` collection.
