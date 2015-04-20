describe('TreeList', ->
  beforeEach( ->
    @list = new Quill.Document.TreeList()
    @a = { str: 'a' }
    @b = { str: 'b' }
    @c = { str: 'c' }
    @a.length = @b.length = @c.length = -> return 3
  )

  describe('manipulation', ->
    it('append to empty list', ->
      @list.append(@a)
      expect(@list.length).toEqual(1)
      expect(@list.head).toEqual(@a)
      expect(@list.tail).toEqual(@a)
      expect(@a.prev).toBeUndefined()
      expect(@a.next).toBeUndefined()
    )

    it('insert to become head', ->
      @list.append(@b)
      @list.insertBefore(@a, @b)
      expect(@list.length).toEqual(2)
      expect(@list.head).toEqual(@a)
      expect(@list.tail).toEqual(@b)
      expect(@a.prev).toBeUndefined()
      expect(@a.next).toEqual(@b)
      expect(@b.prev).toEqual(@a)
      expect(@b.next).toBeUndefined()
    )

    it('insert to become tail', ->
      @list.append(@a)
      @list.insertBefore(@b, undefined)
      expect(@list.length).toEqual(2)
      expect(@list.head).toEqual(@a)
      expect(@list.tail).toEqual(@b)
      expect(@a.prev).toBeUndefined()
      expect(@a.next).toEqual(@b)
      expect(@b.prev).toEqual(@a)
      expect(@b.next).toBeUndefined()
    )

    it('insert in middle', ->
      @list.append(@a, @c)
      @list.insertBefore(@b, @c)
      expect(@list.length).toEqual(3)
      expect(@list.head).toEqual(@a)
      expect(@a.next).toEqual(@b)
      expect(@b.next).toEqual(@c)
      expect(@list.tail).toEqual(@c)
    )

    it('remove head', ->
      @list.append(@a, @b)
      @list.remove(@a)
      expect(@list.length).toEqual(1)
      expect(@list.head).toEqual(@b)
      expect(@list.tail).toEqual(@b)
      expect(@list.head.prev).toBeUndefined()
      expect(@list.tail.next).toBeUndefined()
    )

    it('remove tail', ->
      @list.append(@a, @b)
      @list.remove(@b)
      expect(@list.length).toEqual(1)
      expect(@list.head).toEqual(@a)
      expect(@list.tail).toEqual(@a)
      expect(@list.head.prev).toBeUndefined()
      expect(@list.tail.next).toBeUndefined()
    )

    it('remove inner', ->
      @list.append(@a, @b, @c)
      @list.remove(@b)
      expect(@list.length).toEqual(2)
      expect(@list.head).toEqual(@a)
      expect(@list.tail).toEqual(@c)
      expect(@list.head.prev).toBeUndefined()
      expect(@list.tail.next).toBeUndefined()
      expect(@a.next).toEqual(@c)
      expect(@c.prev).toEqual(@a)
    )

    it('remove only node', ->
      @list.append(@a)
      @list.remove(@a)
      expect(@list.length).toEqual(0)
      expect(@list.head).toBeUndefined()
      expect(@list.tail).toBeUndefined()
    )
  )

  describe('iteration', ->
    beforeEach( ->
      @spy = {
        callback: (args...) ->
      }
      spyOn(@spy, 'callback')
    )

    it('iterate over empty list', ->
      @list.forEach(@spy.callback)
      expect(@spy.callback.calls.count()).toEqual(0)
    )

    it('forEach', ->
      @list.append(@a, @b, @c)
      @list.forEach(@spy.callback)
      expect(@spy.callback.calls.count()).toEqual(3)
      result = _.reduce(@spy.callback.calls.all(), (memo, call) ->
        return memo + call.args[0].str
      , '')
      expect(result).toEqual('abc')
    )

    it('reduce', ->
      @list.append(@a, @b, @c)
      memo = @list.reduce((memo, node) ->
        return memo + node.str
      , '')
      expect(memo).toEqual('abc')
    )

    it('forEachAt', ->
      @list.append(@a, @b, @c)
      @list.forEachAt(3, 3, @spy.callback)
      expect(@spy.callback.calls.count()).toEqual(1)
      expect(@spy.callback.calls.first().args).toEqual([0, 3, @b])
    )

    it('forEachAt partial nodes', ->
      @list.append(@a, @b, @c)
      @list.forEachAt(1, 3, @spy.callback)
      expect(@spy.callback.calls.count()).toEqual(2)
      calls = @spy.callback.calls.all()
      expect(calls[0].args).toEqual([1, 2, @a])
      expect(calls[1].args).toEqual([0, 1, @b])
    )

    it('forEachAt partial nodes', ->
      @list.append(@a, @b, @c)
      @list.forEachAt(1, 7, @spy.callback)
      expect(@spy.callback.calls.count()).toEqual(3)
      calls = @spy.callback.calls.all()
      expect(calls[0].args).toEqual([1, 2, @a])
      expect(calls[1].args).toEqual([0, 3, @b])
      expect(calls[2].args).toEqual([0, 2, @c])
    )

    it('forEachAt at part of single node', ->
      @list.append(@a, @b, @c)
      @list.forEachAt(4, 1, @spy.callback)
      expect(@spy.callback.calls.count()).toEqual(1)
      expect(@spy.callback.calls.first().args).toEqual([1, 1, @b])
    )
  )
)
