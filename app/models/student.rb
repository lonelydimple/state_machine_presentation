class Student < ActiveRecord::Base

  validates :first_name, :presence => true
  validates :last_name, :presence => true

  state_machine :state, :initial => 'recruited' do

    event :register do
      transition [:recruited, :withdrawn] => :registered
    end

    state :enrolled do
      validates :gpa, :numericality => true
    end

    event :enroll do
      transition [:registered, :suspended] => :enrolled
    end

    state :suspended do
      validates :suspension_reason, :presence => true
    end

    event :suspend do
      transition :enrolled => :suspended
    end

    state :expel do
      validates :expellation_reason, :presence => true
    end

    event :expel do
      transition :suspended => :expelled
    end

    event :graduate do
      transition :enrolled => :graduated, :unless => :low_gpa?
    end

    event :withdraw do
      transition any - :graduated => :withdrawn
    end

    before_transition :on => :register, :do => :set_registration_date
    after_transition :on => :graduate, :do => :create_alumnus

  end

  def set_registration_date
    self[:registration_date] = Date.today.at_beginning_of_month.next_month
  end

  def create_alumnus
    Alumnus.create(:first_name => self.first_name, :last_name => self.last_name)
  end

  def low_gpa?
    self[:gpa] < 2
  end

end
