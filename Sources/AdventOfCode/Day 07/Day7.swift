struct Day7: Solution {
    static let day = 7

    var rootDir: Directory
    
    init(input: String) {
        let cmdArr = input.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "$ ")

        var directoryStack = Stack<Directory>()

        for cmd in cmdArr {
            let cmdOutput = cmd.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines)
            let commandBit = cmdOutput[0]
                .components(separatedBy: " ")

            if commandBit[0] == "cd" {
                if commandBit[1] == ".." {
                    directoryStack.pop()
                } else {
                    if directoryStack.isEmpty {
                        directoryStack.push(Directory(name: commandBit[1]))
                    } else {
                        directoryStack.push(directoryStack.peek().findDir(named: commandBit[1])!)
                    }
                }
            } else if commandBit[0] == "ls" {
                for contents in cmdOutput.dropFirst() {
                    let typeAndName = contents.components(separatedBy: .whitespaces)
                    let currentDir = directoryStack.peek()
                    if typeAndName[0] == "dir" {
                        currentDir.files.append(Directory(name: typeAndName[1]))
                    } else {
                        currentDir.files.append(File(name: typeAndName[1], size: Int(typeAndName[0])!))
                    }
                }
            }
        }
        while directoryStack.size > 1 {
            directoryStack.pop()
        }
        self.rootDir = directoryStack.peek()
    }
    
    func calculatePartOne() -> Int {
        let tot = findDirectories(in: rootDir).filter { $0.size < 100000}.reduce(0) { total, next in
            total + next.size
        }

        return tot
    }
    
    func calculatePartTwo() -> Int {
        // The minimum size needed to be deleted
        let targetSize = 30000000 - (70000000 - rootDir.size)

        var smallestFit = Int.max
        for dir in findDirectories(in: rootDir) {
            if dir.size < targetSize {
                continue
            }
            if dir.size < smallestFit {
                smallestFit = dir.size
            }
        }
        return smallestFit
    }

    func findDirectories(in dir: Directory) -> [Directory] {
        var dirs: [Directory] = []
        for dir in dir.subDirs {
            dirs.append(contentsOf: findDirectories(in: dir))
        }
        dirs.append(dir)
        return dirs
    }
}

protocol IsFile {
    var name: String { get set }
    var size: Int { get set }
}

class File: IsFile {
    var name: String
    var size: Int
    init(name: String, size: Int) {
        self.name = name
        self.size = size
    }
}

class Directory: IsFile {
    var name: String
    var size: Int {
        get {
            var total: Int = 0
            for file in files {
                total += file.size
            }
            return total
        }
        set { fatalError("cannot set the size of a directory") }
    }
    var subDirs: [Directory] {
        self.files.compactMap { $0 as? Directory }
    }
    func findDir(named: String) -> Directory? {
        self.files.first { $0.name == named } as? Directory
    }
    var files: [IsFile]
    init(name: String, files: [File] = []) {
        self.name = name
        self.files = files
    }
}
