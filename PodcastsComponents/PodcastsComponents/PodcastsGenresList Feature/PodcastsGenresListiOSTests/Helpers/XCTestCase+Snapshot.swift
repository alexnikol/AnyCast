// Copyright © 2022 Almost Engineer. All rights reserved.

import XCTest

extension XCTestCase {
    
    func assert(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            XCTFail("Failed to load stored snapshot at URL: \(snapshotURL). Use the `record` method to store a snapshot before asserting.", file: file, line: line)
            return
        }
        
        if snapshotData != storedSnapshotData {
            let temporarySnapshotURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
                .appendingPathComponent(snapshotURL.lastPathComponent)
            
            try? snapshotData?.write(to: temporarySnapshotURL)
            
            saveFailedSnapshotArtifacts(expectedURL: snapshotURL, receivedURL: temporarySnapshotURL, file: file)
            
            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL), Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }
    
    private func saveFailedSnapshotArtifacts(expectedURL: URL, receivedURL: URL, file: StaticString) {
        let fileName = expectedURL.lastPathComponent
        let failedArtifactsURL = URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("failed_snapshots")
            .appendingPathComponent(fileName)
        
        do {
            try? FileManager.default.removeItem(at: failedArtifactsURL)
            
            try FileManager.default.createDirectory(
                at: failedArtifactsURL,
                withIntermediateDirectories: true
            )
            try FileManager.default.copyItem(
                at: expectedURL,
                to: failedArtifactsURL
                    .appendingPathComponent("EXPECTED__\(fileName)")
            )
            try FileManager.default.copyItem(
                at: receivedURL,
                to: failedArtifactsURL
                    .appendingPathComponent("RECEIVED__\(fileName)")
            )
            print("Failed snapshots copied to failed_snapshots at \(failedArtifactsURL)")
        } catch {
            print("Failed to record snapshot with error: \(error)")
        }
    }
    
    func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)
        
        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            
            try snapshotData?.write(to: snapshotURL)
            XCTFail("Snapshot recorder, turn to assert instead of record for proving the result", file: file, line: line)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }
    
    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        return URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
    }
    
    private func makeSnapshotData(for snapshot: UIImage, file: StaticString, line: UInt) -> Data? {
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }
        
        return data
    }
}
