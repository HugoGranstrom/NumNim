import strformat, algorithm, sequtils, math, times
import arraymancer

type
    Vector*[T] = object
        components*: seq[T]
        len*: int

proc newVector*[T](components: openArray[T]): Vector[T] {.inline.} =
    return Vector[T](components: @components, len: components.len)

proc checkVectorSizes*(v1, v2: Vector) {.inline.} =
    if v1.len == v2.len:
        return
    else:
        raise newException(ValueError, "Vectors must have the same size.")


proc `[]`*[T](v: Vector[T], i: int): T {.inline.} = v.components[i]
proc `[]`*[T](v: var Vector[T], i: int): var T {.inline.} = v.components[i]
proc `[]=`*[T](v: var Vector[T], i: int, value: T) {.inline.} =
    v.components[i] = value
iterator items*[T](v: Vector[T]): T =
    for i in v.components:
        yield i
iterator mitems*[T](v: var Vector[T]): var T =
    for i in v.components:
        yield i
iterator pairs*[T](v: Vector[T]): (int, T) =
    for i in 0 ..< v.len:
        yield (i, v[i])
proc `$`*(v: Vector): string {.inline.} = &"Vector({v.components})"
proc `@`*[T](v: Vector[T]): seq[T] {.inline.} = v.components
proc `@`*[T](v: Vector[Vector[T]]): seq[seq[T]] {.inline.} =
    for i in 0 ..< v.len:
        result.add(@(v[i]))
proc `@`*[T](v: Vector[Vector[Vector[T]]]): seq[seq[seq[T]]] {.inline.} =
    for i in 0 ..< v.len:
        result.add(@(v[i]))
proc toTensor*(v: Vector): Tensor[float] {.inline.} = (@v).toTensor()
proc `==`*[T](v1, v2: Vector[T]): bool {.inline.} =
    for i in 0 .. v1.components.high:
        if v1[i] != v2[i]:
            return false
    return true

proc size*[T](v: Vector[T]): int = v.components.len

proc `+`*[T](v1, v2: Vector[T]): Vector[T] {.inline.} =
    checkVectorSizes(v1, v2)
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] + v2[i]
    result = newVector(newComponents)

proc `+`*[T](v1: Vector[T], d: float): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] + d
    result = newVector(newComponents)

proc `+`*[T](d: float, v1: Vector[T]): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] + d
    result = newVector(newComponents)

template `+.`*[T](d: float, v1: Vector[T]): Vector[T] =
    d + v1

template `+.`*[T](v1: Vector[T], d: float): Vector[T] =
    v1 + d


proc `+`*[T](v1: Vector[T], d: T): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] + d
    result = newVector(newComponents)

proc `+`*[T](d: T, v1: Vector[T]): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] + d
    result = newVector(newComponents)

proc `+=`*[T](v1: var Vector[T], v2: Vector[T]) {.inline.} =
    checkVectorSizes(v1, v2)
    for i in 0 .. v1.components.high:
        v1[i] += v2[i]

proc `+=`*[T](v1: var Vector[T], d: float) {.inline.} =
    for i in 0 .. v1.components.high:
        v1[i] += d

template `+.=`*[T](v1: var Vector[T], d: float) =
    v1 += d

proc `+=`*[T](v1: var Vector[T], d: T) {.inline.} =
    for i in 0 .. v1.components.high:
        v1[i] += d

proc `-`*[T](v1, v2: Vector[T]): Vector[T] {.inline.} =
    checkVectorSizes(v1, v2)
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] - v2[i]
    result = newVector(newComponents)

proc `-`*[T](v1: Vector[T], d: float): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] - d
    result = newVector(newComponents)

proc `-`*[T](d: float, v1: Vector[T]): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = d - v1[i]
    result = newVector(newComponents)

template `-.`*[T](d: float, v1: Vector[T]): Vector[T] =
    d - v1

template `-.`*[T](v1: Vector[T], d: float): Vector[T] =
    v1 - d

proc `-`*[T](v1: Vector[T], d: T): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] - d
    result = newVector(newComponents)

proc `-`*[T](d: T, v1: Vector[T]): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = d - v1[i]
    result = newVector(newComponents)

proc `-=`*[T](v1: var Vector[T], v2: Vector[T]) {.inline.} =
    checkVectorSizes(v1, v2)
    for i in 0 .. v1.components.high:
        v1[i] -= v2[i]

proc `-=`*[T](v1: var Vector[T], d: float) {.inline.} =
    for i in 0 .. v1.components.high:
        v1[i] -= d

template `-.=`*[T](v1: var Vector[T], d: float) =
    v1 -= d

proc `-=`*[T](v1: var Vector[T], d: T) {.inline.} =
    for i in 0 .. v1.components.high:
        v1[i] -= d

proc `/`*[T](v1: Vector[T], d: float): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] / d
    result = newVector(newComponents)
proc `*`*[T](v1: Vector[T], d: float): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] * d
    result = newVector(newComponents)
proc `*`*[T](d: float, v1: Vector[T]): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] * d
    result = newVector(newComponents)
proc `*`*[T](v1, v2: Vector[T]): float {.inline.} =
    checkVectorSizes(v1, v2)
    result = 0.0
    for i in 0 .. v1.components.high:
        result += v1[i] * v2[i]
proc `*.`*[T](v1, v2: Vector[T]): Vector[T] {.inline.} =
    checkVectorSizes(v1, v2)
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] * v2[i]
    result = newVector(newComponents)
proc `/.`*[T](v1, v2: Vector[T]): Vector[T] {.inline.} =
    checkVectorSizes(v1, v2)
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = v1[i] / v2[i]
    result = newVector(newComponents)
proc `*.=`*[T](v1: var Vector[T], v2: Vector[T]) {.inline.} =
    checkVectorSizes(v1, v2)
    for i in 0 .. v1.components.high:
        v1[i] *= v2[i]
proc `/.=`*[T](v1: var Vector[T], v2: Vector[T]) {.inline.} =
    checkVectorSizes(v1, v2)
    for i in 0 .. v1.components.high:
        v1[i] /= v2[i]
proc dot*[T](v1, v2: Vector[T]): float {.inline.} =
    result = v1 * v2
proc `*=`*[T](v1: var Vector[T], d: float) {.inline.} =
    for i in 0 .. v1.components.high:
        v1[i] *= d
proc `/=`*[T](v1: var Vector[T], d: float) {.inline.} =
    for i in 0 .. v1.components.high:
        v1[i] /= d
proc `-`*[T](v1: Vector[T]): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = -v1[i]
    result = newVector(newComponents)
proc abs*[T](v1: Vector[T]): Vector[T] {.inline.} =
    var newComponents = newSeq[T](v1.len)
    for i in 0 .. v1.components.high:
        newComponents[i] = abs(v1[i])
    result = newVector(newComponents)

proc norm*(v1: Vector, p: int = 2): float64 {.inline.} =
    ## Calculate various norms of our Vector class
    
    # we have to make a case for p = 0 to avoid division by zero, may as well flesh them all out
    case p:
        of 0:
            # max(v1) Infinity norm
            result = float64(max(@v1))
        of 1:
            # sum(v1) Taxicab norm
            result = float64(sum(@v1))
        of 2:
            # sqrt(sum([v ^ 2 for v in v1])) Euclidean norm
            result = sqrt(sum(@(v1 ^ 2)))
        else:
            # pow(sum([v ^ p for v in v1]), 1.0/p) P norm
            result = pow(sum(@(v1 ^ p)), 1.0 / float64(p))

proc sum*[T](v: Vector[T]): T {.inline.} =
    when T is Vector:
        var newComponents = newSeq[T](v.len)
        for i in 0 .. v.components.high:
            newComponents[i] = sum(v[i])
        return norm(newVector(newComponents), 1)
    else:
        return norm(v, 1)

proc mean_squared_error*[T](v1, v2: Vector[T]): float {.inline.} = norm(v1 - v2) / v1.len.toFloat

proc `^`*[float](v: Vector[float], power: Natural): Vector[float] {.inline.} =
    ## Returns a Vector object after raising each element to a power (Natural number powers)
    var newComponents = newSeq[float](v.len)
    for i in 0 .. v.components.high:
        newComponents[i] = v[i] ^ power
    result = newVector(newComponents)

proc `^`*[float](v: Vector[float], power: float): Vector[float] {.inline.} =
    ## Returns a Vector object after raising each element to a power (float powers)
    var newComponents = newSeq[float](v.len)
    for i in 0 .. v.components.high:
        newComponents[i] = pow(v[i], power)
    result = newVector(newComponents)
 

proc clone*[T](x: T): T {.inline.} = x
proc mean_squared_error*[T](y_true, y: T): float {.inline.} = abs(y_true - y)
proc calcError*[T](y_true, y: T): float {.inline.} = mean_squared_error(y_true, y)


proc hermiteSpline*[T](x, x1, x2: float, y1, y2, dy1, dy2: T): T {.inline.}=
    let t = (x - x1)/(x2 - x1)
    let h00 = (1.0 + 2.0 * t) * (1.0 - t) ^ 2
    let h10 = t * (1.0 - t) ^ 2
    let h01 = t ^ 2 * (3.0 - 2.0 * t)
    let h11 = t ^ 3 - t ^ 2
    result = h00 * y1 + h10 * (x2 - x1) * dy1 + h01 * y2 + h11 * (x2 - x1) * dy2


proc hermiteInterpolate*[T](x: openArray[float], t: openArray[float],
                            y, dy: openArray[T]): seq[T] {.inline.} =
    # loop over each interval and check if x is in there, if x is sorted
    var xIndex = 0
    if isSorted(x):
        for i in 0 .. t.high - 1:
            while t[i] <= x[xIndex] and x[xIndex] < t[i+1]:
                result.add(hermiteSpline(x[xIndex], t[i], t[i+1], y[i], y[i+1], dy[i], dy[i+1]))
                xIndex += 1
                if x.high < xIndex:
                    break
            if x.high < xIndex:
                break
        if x[x.high] == t[t.high]:
            result.add(y[y.high])
    # loop over each x and then loop over each interval, if x not sorted
    else:
        for a in x:
            block forblock:
                for i in 0 .. t.high - 1:
                    if t[i] <= a and a < t[i+1]:
                        result.add(hermiteSpline(a, t[i], t[i+1], y[i], y[i+1], dy[i], dy[i+1]))
                        break forblock
                if a == t[t.high]:
                    result.add(y[y.high])
                else:
                    raise newException(ValueError, &"{a} not in interval {min(t)} - {max(t)}")






proc sortDataset*[T](X: openArray[float], Y: openArray[T]): seq[(float, T)] {.inline.} =
    if X.len != Y.len:
        raise newException(ValueError, "X and Y must have the same length")
    result = zip(X, Y)
    result.sort() # sort with respect to x
    


proc isClose*[T](y1, y2: T, tol: float = 1e-3): bool {.inline.} =
    let diff = calcError(y1, y2)
    if diff <= tol:
        return true
    else:
        return false


proc arange*(x1, x2, dx: float, includeStart = true, includeEnd = false): seq[float] {.inline.} =
    let dx = abs(dx) * sgn(x2 - x1).toFloat
    if dx == 0.0:
        raise newException(ValueError, "dx must be bigger than 0")
    if includeStart:
        result.add(x1)
    for i in 1 .. abs(floor((x2 - x1)/dx).toInt):
        result.add(x1 + i.toFloat * dx)
    if includeEnd:
        if result[result.high] != x2:
            result.add(x2)


proc linspace*(x1, x2: float, N: int): seq[float] {.inline.} =
    if N <= 0:
        raise newException(ValueError, &"Number of samples {N} must be greater then 0")

    let dx = (x2 - x1) / (N - 1).toFloat
    result.add(x1)
    for i in 1 .. N - 2:
        result.add(x1 + dx * i.toFloat)
    result.add(x2)


template timeit*(s: untyped, n = 100, msg = ""): untyped =
    var tTotal = 0.0
    for i in 1 .. n:
        let t0 = cpuTime()
        discard s
        tTotal += cpuTime() - t0
    echo msg & ": " & $(tTotal / n.toFloat) & " seconds per iteration"

template benchmarkit*[T](s: untyped, n = 100, msg = "", answer: T, onlyEfficiency = false): untyped =
    var tTotal = cpuTime()
    for i in 1 .. n:
        discard s
    tTotal = cpuTime() - tTotal
    let error = calcError(answer, s)
    let tAverage = tTotal / n.toFloat
    let efficiency = (error * tAverage)
    if onlyEfficiency:
        echo msg & " Efficiency: " & $efficiency
    else:
        echo msg & ": Time: " & $tAverage & " s/iter Error: " & $error & " Efficiency: " & $efficiency
