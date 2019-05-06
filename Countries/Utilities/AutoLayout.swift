import UIKit

typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

// MARK: - Base methods

func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                         _ to: KeyPath<UIView, Anchor>,
                         constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        return view[keyPath: keyPath].constraint(equalTo: parent[keyPath: to], constant: constant)
    }
}

func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                         _ anchor: NSLayoutAnchor<Axis>,
                         constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, _ in
        return view[keyPath: keyPath].constraint(equalTo: anchor, constant: constant)
    }
}

func equal<Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                   _ anchor: NSLayoutDimension,
                   constant: CGFloat = 0, multiplier: CGFloat = 0) -> Constraint where Anchor: NSLayoutDimension {
    return { view, _ in
        return view[keyPath: keyPath].constraint(equalTo: anchor, multiplier: multiplier)
    }
}

func lessThanOrEqual<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                   _ to: KeyPath<UIView, Anchor>,
                                   constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        return view[keyPath: keyPath].constraint(lessThanOrEqualTo: parent[keyPath: to], constant: constant)
    }
}

func lessThanOrEqual<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                   _ anchor: NSLayoutAnchor<Axis>,
                                   constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, _ in
        return view[keyPath: keyPath].constraint(lessThanOrEqualTo: anchor, constant: constant)
    }
}

func greaterThanOrEqual<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                      _ to: KeyPath<UIView, Anchor>,
                                      constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        return view[keyPath: keyPath].constraint(greaterThanOrEqualTo: parent[keyPath: to], constant: constant)
    }
}

func greaterThanOrEqual<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                      _ anchor: NSLayoutAnchor<Axis>,
                                      constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, _ in
        return view[keyPath: keyPath].constraint(greaterThanOrEqualTo: anchor, constant: constant)
    }
}

// MARK: - Helpers, shorthands

func equal<Anchor>(_ keyPath: KeyPath<UIView, Anchor>, toConstant constant: CGFloat) -> Constraint where Anchor: NSLayoutDimension {
    return { view, _ in
        return view[keyPath: keyPath].constraint(equalToConstant: constant)
    }
}

func equal<Anchor>(_ keyPath: KeyPath<UIView, Anchor>, multiplier: CGFloat) -> Constraint where Anchor: NSLayoutDimension {
    return { view, parent in
        return view[keyPath: keyPath].constraint(equalTo: parent[keyPath: keyPath], multiplier: multiplier)
    }
}

func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return equal(keyPath, keyPath, constant: constant)
}

func lessThanOrEqual<Anchor>(_ keyPath: KeyPath<UIView, Anchor>, toConstant constant: CGFloat) -> Constraint where Anchor: NSLayoutDimension {
    return { view, _ in
        return view[keyPath: keyPath].constraint(lessThanOrEqualToConstant: constant)
    }
}

func lessThanOrEqual<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>, constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return lessThanOrEqual(keyPath, keyPath, constant: constant)
}

func greaterThanOrEqual<Anchor>(_ keyPath: KeyPath<UIView, Anchor>, toConstant constant: CGFloat) -> Constraint where Anchor: NSLayoutDimension {
    return { view, _ in
        return view[keyPath: keyPath].constraint(greaterThanOrEqualToConstant: constant)
    }
}

func greaterThanOrEqual<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                      constant: CGFloat = 0) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return greaterThanOrEqual(keyPath, keyPath, constant: constant)
}

func prioritize(_ priority: UILayoutPriority, _ constraint: @escaping Constraint) -> Constraint {
    return { view, parent in
        let nsLayoutConstraint = constraint(view, parent)
        nsLayoutConstraint.priority = priority
        return nsLayoutConstraint
    }
}

extension UIView {
    func addSubview(_ child: UIView, constraints: [Constraint]) {
        addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0(child, self) })
    }

    func addSubview(_ child: UIView, constraints: [NSLayoutConstraint]) {
        addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints)
    }
}

extension Array where Element == Constraint {
    static var allAnchors: [Constraint] {
        return [equal(\.topAnchor), equal(\.bottomAnchor), equal(\.leftAnchor), equal(\.rightAnchor)]
    }

    static var allSafeAreaAnchors: [Constraint] {
        return [equal(\.safeAreaLayoutGuide.topAnchor),
                equal(\.safeAreaLayoutGuide.bottomAnchor),
                equal(\.safeAreaLayoutGuide.leftAnchor),
                equal(\.safeAreaLayoutGuide.rightAnchor)
        ]
    }
}
