const
    SkipChars: seq[char] = @"-+="

proc combinePaths(params: var seq[string], isDebug: bool, prependSlash: bool, prependWildcard: bool, appendWildcard: bool, wildcardLast: bool): string =
    var
        joined: string = ""

    for n in params.low .. params.high:
        var
            last: seq[string] = params[params.high].split('\\')
            addToLast = (n < params.high) or (wildcardLast == true and n == params.high)
        if prependWildcard == true and addToLast:
            params[n] = '*' & params[n]
        if appendWildcard == true and addToLast:
            params[n] = params[n] & '*'

    joined = params.join("\\")
    if prependSlash == true:
        joined = '\\' & joined

    if isDebug:
        debug(&"params: {params}")
        debug(&"joined: {joined}")

    return joined
