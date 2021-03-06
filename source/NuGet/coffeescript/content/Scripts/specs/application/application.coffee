expect = @chai.expect

describe 'Application', ->

  describe '.start', ->
    stubbedMembershipView = null
    stubbedProfileView = null
    spiedEventsTrigger = null
    stubbedRouter = null

    before ->
      stubbedMembershipView = sinon.stub Application.Views, 'Membership', -> {}
      stubbedProfileView = sinon.stub Application.Views, 'Profile', -> {}
      spiedEventsTrigger = sinon.spy Application.events, 'on'
      stubbedRouter = sinon.stub Application, 'Router', -> navigate: ->

      try
        Application.start()
      catch e

    describe 'view creation', ->
      it 'creates membership view', ->
        expect(Application.membershipView).to.exist

      it 'creates profile view', ->
        expect(Application.profileView).to.exist

    describe 'application events', ->

      describe 'subscription', ->
        it 'subscribe to myAccount application event', ->
          expect(spiedEventsTrigger).to.have.been.calledWith 'myAccount'

        it 'subscribe to signedIn application event', ->
          expect(spiedEventsTrigger).to.have.been.calledWith 'signedIn'

        it 'subscribe to passwordResetRequested application event', ->
          expect(spiedEventsTrigger)
            .to.have.been.calledWith 'passwordResetRequested'

        it 'subscribe to signedUp application event', ->
          expect(spiedEventsTrigger).to.have.been.calledWith 'signedUp'

        it 'subscribe to passwordChanged application event', ->
          expect(spiedEventsTrigger).to.have.been.calledWith 'passwordChanged'

        it 'subscribe to signedOut application event', ->
          expect(spiedEventsTrigger).to.have.been.calledWith 'signedOut'

      describe 'handling', ->
        stubbedShowInfoBar = null
        stubbedDelay = null

        before ->
          stubbedShowInfoBar = sinon.stub $, 'showInfobar', -> 
          stubbedDelay = sinon.stub window, '_'
          stubbedDelay.withArgs(sinon.match.func).returns delay: ->

        describe 'myAccount', ->
          spiedEventsTrigger = null

          before ->
            spiedEventsTrigger = sinon.spy Application.events, 'trigger'

          describe 'user signed in', ->
            before ->
              Application.userSignnedIn = true
              Application.events.trigger 'myAccount'

            it 'triggers showProfile', ->
              expect(spiedEventsTrigger).to.have.been.calledWith 'showProfile'

          describe 'user not signed in', ->
            before ->
              Application.userSignnedIn = false
              Application.events.trigger 'myAccount'

            it 'triggers showMembership', ->
              expect(spiedEventsTrigger).to.have.been.calledWith 'showMembership'

          after ->
            Application.userSignnedIn = false
            spiedEventsTrigger.restore()

        describe 'signedIn', ->
          before ->
            Application.userSignnedIn = false
            Application.events.trigger 'signedIn'
            stubbedDelay.callArg 0

          it 'sets #userSignnedIn to true', ->
            expect(Application.userSignnedIn).to.be.true

          it 'shows info bar', ->
            expect(stubbedShowInfoBar).to.have.been.called

          after ->
            Application.userSignnedIn = false
            stubbedShowInfoBar.reset()

        describe 'passwordResetRequested', ->
          before ->
            Application.events.trigger 'passwordResetRequested'
            stubbedDelay.callArg 0

          it 'shows info bar', ->
            expect(stubbedShowInfoBar).to.have.been.called

          after -> stubbedShowInfoBar.reset()

        describe 'signedUp', ->
          before ->
            Application.events.trigger 'signedUp'
            stubbedDelay.callArg 0

          it 'shows info bar', ->
            expect(stubbedShowInfoBar).to.have.been.called

          after -> stubbedShowInfoBar.reset()

        describe 'passwordChanged', ->
          before ->
            Application.events.trigger 'passwordChanged'
            stubbedDelay.callArg 0

          it 'shows info bar', ->
            expect(stubbedShowInfoBar).to.have.been.called

          after -> stubbedShowInfoBar.reset()

        describe 'signedOut', ->
          before ->
            Application.userSignnedIn = true
            Application.events.trigger 'signedOut'
            stubbedDelay.callArg 0

          it 'sets #userSignnedIn to false', ->
            expect(Application.userSignnedIn).to.be.false

          it 'shows info bar', ->
            expect(stubbedShowInfoBar).to.have.been.called

          after ->
            Application.userSignnedIn = false
            stubbedShowInfoBar.reset()

        after ->
          stubbedShowInfoBar.restore()
          stubbedDelay.restore()

    it 'creates router', -> expect(Application.router).to.exist

    after ->
      stubbedMembershipView.restore()
      stubbedProfileView.restore()
      spiedEventsTrigger.restore()
      stubbedRouter.restore()