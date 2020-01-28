require 'rails_helper'

RSpec.describe Signup, type: :model do
  it { should validate_presence_of(:course_id)}
  it { should validate_presence_of(:snum)}

  it 'should not allow signup of same student twice' do
    t = Teacher.create(email:"a@a.a", password:"asdasdasd")
    c = Course.new(id: 1, name: "Testing", ctype: "lab", description: "Like this", ects:1, limit: 2, teacher: t)
    c.save!
    s1 = c.signups.new(snum:123)
    s1.save!
    expect {c.signups.create!(snum:123)}.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not allow signup if course is full' do
    t = Teacher.create(email:"a@a.a", password:"asdasdasd")
    c = Course.new(id: 1, name: "Testing", ctype: "lab", description: "Like this", ects:1, limit: 2, teacher: t)
    c.save!
    c.signups.create(snum:123)
    c.signups.create(snum:234)

    expect {c.signups.create!(snum:555)}.to raise_error(ActiveRecord::RecordInvalid)
  end
end
