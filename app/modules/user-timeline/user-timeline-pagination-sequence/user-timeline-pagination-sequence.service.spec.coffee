describe "tgUserTimelinePaginationSequenceService", ->
    userTimelinePaginationSequenceService = null

    _inject = () ->
        inject (_tgUserTimelinePaginationSequenceService_) ->
            userTimelinePaginationSequenceService = _tgUserTimelinePaginationSequenceService_

    beforeEach ->
        module "taigaUserTimeline"
        _inject()

    it "get remote items to reach the min", (done) ->
        config = {}

        page1 = Immutable.Map({
            next: true,
            data: [1, 2, 3]
        })
        page2 = Immutable.Map({
            next: true,
            data: [4, 5]
        })
        page3 = Immutable.Map({
            next: true,
            data: [6, 7, 8, 9, 10, 11]
        })

        promise = sinon.stub()
        promise.withArgs(1).promise().resolve(page1)
        promise.withArgs(2).promise().resolve(page2)
        promise.withArgs(3).promise().resolve(page3)

        config.fetch = (page) ->
            return promise(page)

        config.minItems = 10

        seq = userTimelinePaginationSequenceService.generate(config)

        seq.next().then (result) ->
            result = result.toJS()

            expect(result.items).to.have.length(11)
            expect(result.next).to.be.true

            done()

    it "get items until the last page", (done) ->
        config = {}

        page1 = Immutable.Map({
            next: true,
            data: [1, 2, 3]
        })
        page2 = Immutable.Map({
            next: false,
            data: [4, 5]
        })

        promise = sinon.stub()
        promise.withArgs(1).promise().resolve(page1)
        promise.withArgs(2).promise().resolve(page2)

        config.fetch = (page) ->
            return promise(page)

        config.minItems = 10

        seq = userTimelinePaginationSequenceService.generate(config)

        seq.next().then (result) ->
            result = result.toJS()

            expect(result.items).to.have.length(5)
            expect(result.next).to.be.false

            done()

    it "increase pagination every page call", (done) ->
        config = {}

        page1 = Immutable.Map({
            next: true,
            data: [1, 2, 3]
        })
        page2 = Immutable.Map({
            next: true,
            data: [4, 5]
        })

        promise = sinon.stub()
        promise.withArgs(1).promise().resolve(page1)
        promise.withArgs(2).promise().resolve(page2)

        config.fetch = (page) ->
            return promise(page)

        config.minItems = 2

        seq = userTimelinePaginationSequenceService.generate(config)

        seq.next().then () ->
            seq.next().then (result) ->
                result = result.toJS()

                expect(result.items).to.have.length(2)
                expect(result.next).to.be.true

                done()
