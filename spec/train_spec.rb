require 'spec_helper'

describe '#Train' do

  describe('.all') do
    it("returns an empty array when there are no trains") do
      expect(Train.all).to(eq([]))
    end
  end
  describe('#save') do
    it("saves an train") do
      train = Train.new({:train_name => "Red line", :id => nil})
      train.save()
      train2 = Train.new({:train_name => "Blue Line", :id => nil})
      train2.save()
      expect(Train.all).to(eq([train, train2]))
    end
  end
  describe('.clear') do
    it("clears all albums") do
      train = Train.new({:train_name => "Red Line", :id => nil})
      train.save()
      train2 = Train.new({:train_name => "Blue Line", :id => nil})
      train2.save()
      Train.clear
      expect(Train.all).to(eq([]))
    end
  end
  describe('#==') do
    it("is the same train if it has the same attributes as another train") do
      train = Train.new({:train_name => "Blue", :id => nil})
      train2 = Train.new({:train_name => "Blue", :id => nil})
      expect(train).to(eq(train2))
    end
  end
  describe('.find') do
    it("finds an train by id") do
      train = Train.new({:train_name => "A Love Supreme", :id => nil})
      train.save()
      train2 = Train.new({:train_name => "Blue", :id => nil})
      train2.save()
      expect(Train.find(train.id)).to(eq(train))
    end
  end
  # describe('#update') do
  #   it("updates an trainby id") do
  #     train = City.new({:train_name => "Madlib", :id => nil})
  #     train.save()
  #     train = Train.new({:train_name => "A Love Supreme", :id => nil})
  #     train.save()
  #     train.update({:train_name => "Madlib"})
  #     # expect(train.trains).to(eq([artist]))
  #   end
  # end
  # describe('#delete') do
  #   it("deletes an train by id") do
  #     train = Train.new({:train_name => "A Love Supreme", :id => nil})
  #     train.save()
  #     train2 = Train.new({:train_name => "Blue", :id => nil})
  #     train2.save()
  #     train.delete()
  #     expect(Train.all).to(eq([train2]))
  #   end
  # end
  # describe('#cities') do
  #   it("returns an train's city") do
  #     train= Album.new({:train_name => "Red Line", :id => nil})
  #     train.save()
  #     city = City.new({:train_name => "Blue Line", :train_id => train.id, :id => nil})
  #     city.save()
  #     city2 = City.new({:train_name => "Yellow Line", :train_id => train.id, :id => nil})
  #     city2.save()
  #     expect(train.cities).to(eq([city, city2]))
  #   end
  # end

  describe('.search') do
    it("searches for an train by name") do
      train = Train.new({:train_name => "A Love Supreme", :id => nil})
      train.save()
      train2 = Train.new({:train_name => "Blue", :id => nil})
      train2.save()
      train3 = Train.new({:train_name => "Blues clues", :id => nil})
      train3.save()
      expect(Train.search("blue")).to(eq([train2, train3]))
    end
  end
  describe('.sort') do
    it("sorts trains by name") do
      train = Train.new({:train_name => "Blue", :id => nil})
      train.save()
      train2 = Train.new({:train_name => "A Love Supreme", :id => nil})
      train2.save()
      train3 = Train.new({:train_name => "Moving Pictures", :id => nil})
      train3.save()
      expect(Train.sort()).to(eq([train2, train, train3]))
    end
  end
end
