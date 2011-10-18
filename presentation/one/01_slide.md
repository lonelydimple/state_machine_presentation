!SLIDE 
# State Machine

https://github.com/pluginaweek/state_machine

!SLIDE 
# Why use state machine?

avoid complicated boolean attributes

    @@@ ruby
    def is_closed?
      status == 'closed'
    end

    def is_open?
      status == 'open'
    end
