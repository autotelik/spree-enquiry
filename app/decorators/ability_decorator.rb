class ContactUsAbilityDecorator
  include CanCan::Ability

  def initialize(user)

    if(user)

      can :read, Enquiry do |enquiry, token|
        enquiry.user == user || enquiry.token && token == enquiry.token
      end

      can :update, Enquiry do |enquiry, token|
        enquiry.user == user || enquiry.token && token == enquiry.token
      end

      can :index, Enquiry do |enquiry, token|
        enquiry.user == user || enquiry.token && token == enquiry.token
      end

    end
   
    can :create, Enquiry
  end
end