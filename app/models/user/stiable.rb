module User::Stiable
  extend ActiveSupport::Concern

  module ClassMethods
    def find_sti_class(university_id)
      case university_id
        when 1
          ApuUser
        else
          self
      end
    end

    def sti_name
      case self.to_s
        when 'ApuUser'
          1
        else
          0
      end
    end
  end
end