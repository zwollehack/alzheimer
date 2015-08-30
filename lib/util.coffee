Array::flatMap = (fn) ->
  Array::concat.apply [], @map(fn)

Array::last = (fn) ->
  if @length is 0 then null else @[@length - 1]

Array::contains = (element) ->
  @indexOf(element) isnt -1

Array::distinct = ->
  u = {}
  a = []
  i = 0
  l = @length
  while i < l
    if u.hasOwnProperty(@[i])
      ++i
      continue
    a.push @[i]
    u[@[i]] = 1
    ++i
  a

# [B](f: (A) ⇒ B): B -> [A] ; Although the types in the arrays aren't strict (:
Array::groupBy = (fn) ->
  Array::reduce.apply(@,
    [(groups, item) ->
      group = fn.apply(@, [item])
      groups[group] ?= []
      groups[group].push(item)
      groups
    , []])

###
Array::find
@param  Function       fn  Function to execute on each value in the array.
@return Any|undefined      The array element if found, otherwise undefined.
###
Array::find ?= (fn) ->
  throw new TypeError("Array.prototype.find called on null or undefined")  unless this?
  throw new TypeError()  if typeof fn isnt "function"

  t = Object(this)
  len = t.length >>> 0
  thisArg = (if arguments.length >= 2 then arguments[1] else undefined)
  i = 0

  while i < len
    if i of t
      val = t[i]

      return val  if fn.call(thisArg, val, i, t)
    i++
  return

@util =
  str:
    isEmpty: (str) ->
      (not str?) or str is ""