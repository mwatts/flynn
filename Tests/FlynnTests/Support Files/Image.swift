
import XCTest
@testable import Flynn

public class ImageableState {
    fileprivate var path: String = ""
}

protocol Imageable: Actor {
    var safeImageable: ImageableState { get set }
}

extension Imageable {
    private func _bePath(_ path: String) {
        safeImageable.path = path
    }
}

public final class Image: Actor, Colorable, Imageable, Viewable {
    public var safeColorable = ColorableState()
    public var safeImageable = ImageableState()
}


// MARK: - Autogenerated by FlynnLint
// Contents of file after this marker will be overwritten as needed

extension Imageable {

    @discardableResult
    public func bePath(_ path: String) -> Self {
        unsafeSend { self._bePath(path) }
        return self
    }

}
