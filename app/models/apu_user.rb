class ApuUser < User
  enum faculty: { APS: 1, APM: 2}, _prefix: :true
end
