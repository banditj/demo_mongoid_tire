Fabricate(:person) do
  snumber { sequence(:snumber, 111111111) }
  age { sequence(:age, 20) }
  income   {sqeuence(:income, 1000.50)}
  lname {Faker::Name.last_name}
  fname {Faker::Name.first_name}
  username { sequence(:lname) { |i| "user_#{i}" } }
  birthday { Faker::Date.at_beginning_of_year }
end
