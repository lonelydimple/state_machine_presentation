!SLIDE subsection
# State Machine

## https://github.com/pluginaweek/state_machine

!SLIDE subsection bullets incremental
# Why use state_machine?

* provides a CHEAP "mini-DSL" for your domain logic
* replace messy/inconsistent boolean methods throughout the class
* enforces consistency across the application in dealing with state

!SLIDE subsection
# An example application

## Students!

!SLIDE subsection center
# state_machine at Merchants

![bond](plumber_bond.jpg)

!SLIDE subsection bullets incremental

# Updating/Endorsing surety bonds

* legal documents that express an obligation over time
* changes need to be made to the obligation (needing to endorse the
  legal document)
* lots of different "categories" of changes
* web users request these changes
* merchants approves these changes

!SLIDE bullets subsection incremental

# Common workflow for all updates

* User submits request to update surety bond => Employee approves/declines
update request => User executes update and gets endorsement
documentation

!SLIDE smaller subsection
# Defining a state machine for a generic update

    @@@ ruby
    class Update

      state_machine :state, :initial => :draft do

        event :submit_for_review do
          transition [:draft, 
                      :editing_renewal] => :pending_review
        end
        ....
        event :execute do
          transition [:draft, 
                      :pending_review, 
                      :pending_activation] => :executed
        end

      end
    end

!SLIDE smaller subsection

# Specifying validations for a particular type of update

    @@@ ruby
    class NameUpdate < Update

      validates :name, :presence => true
      validates :receiver, :presence => true
      validate :name_attributes_must_be_changed, :if => :draft?

      ....

      def principal_name_attributes_must_be_changed
        unless principal_name_attributes_changed?
          errors[:base] << "No principal name values were changed"
        end
      end

    end

!SLIDE smaller subsection

# Specifying callbacks for update type

    @@@ ruby
    class NameUpdate < Update
      
      ....

      state_machine do
        after_transition :on => :submit_for_review, 
                         :do => :deliver_pending_review_notifications
        ....
        before_transition :on => :execute, :do => :update_surety_bond
      end

      def update_surety_bond
        ....
      end

      def deliver_pending_review_notifications
        SuretyBondMailer.delay(:priority => 50).update_request_notification(self)
      end

    end

!SLIDE smaller subsection
# Mapping the events to controller actions

    @@@ ruby
    class UpdatesController < ApplicationController

      ....

      def submit_for_review
        update.submit_for_review
        flash[:success] = after_submit_for_review_flash_message
        redirect_to :action => :show
      end

      def execute
        update.execute
        flash[:success] = after_execute_flash_message
        redirect_to after_execute_path
      end

      ....

    end

!SLIDE smaller subsection
# Using declarative_authorization gem to control access to events

    @@@ ruby
    authorization do

      role :commercial do
      
        ....

        has_permission_on :surety_bond_principal_address_updates, 
                          :to => [:manage, :execute]
        has_permission_on :surety_bond_principal_name_updates, 
                          :to => [:manage, :execute, 
                                  :approve_for_execution, :decline_for_execution,
                                  :cancel, :toggle_notification]
        
        ....

        end
      end
    end
