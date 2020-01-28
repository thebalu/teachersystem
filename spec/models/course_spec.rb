require 'rails_helper'

RSpec.describe Course, type: :model do
  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:description)}
  it { should validate_presence_of(:ects)}
  it { should validate_presence_of(:ctype)}
  it { should validate_presence_of(:limit)}
end
