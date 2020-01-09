require 'spec_helper'

describe '#City' do

  describe('.all') do
    it("returns an empty array when there are no cities") do
      expect(City.all).to(eq([]))
    end
  end

  describe('#save') do
    it("saves a city") do
      train = City.new({:stop_name => "Bernina Express", :departure => "1:00", :id => nil})
      train.save()
      train2 = City.new({:stop_name => "Darjeeling Limited", :departure => "1:00", :id => nil})
      train2.save()
      expect(City.all).to(eq([train, train2]))
    end
  end

  describe('.clear') do
    it("clears all cities") do
      train = City.new({:stop_name => "Bernina Express", :departure => "1:00", :id => nil})
      train.save()
      train2 = City.new({:stop_name => "Darjeeling Limited", :departure => "1:00", :id => nil})
      train2.save()
      City.clear
      expect(City.all).to(eq([]))
    end
  end

  describe('#==') do
    it("is the same city if it has the same attributes as another city") do
      train = City.new({:stop_name => "Bernina Express", :departure => "1:00", :id => nil})
      train2 = City.new({:stop_name => "Bernina Express", :departure => "1:00", :id => nil})
      expect(train).to(eq(train2))
    end
  end

  describe('.find') do
    it("finds train by id") do
      train = City.new({:stop_name => "Bernina Express", :departure => "1:00", :id => nil})
      train.save()
      train2 = City.new({:stop_name => "Deltrain", :departure => "1:00", :id => nil})
      train2.save()
      expect(City.find(train.id)).to(eq(train))
    end
  end

  # describe('#delete') do
  #   it("deletes a train by id") do
  #     train = City.new({:stop_name => "Bernina Express", :departure => "1:00", :id => nil})
  #     train.save()
  #     train2 = City.new({:stop_name => "Deltrain", :departure => "1:00", :id => nil})
  #     train2.save()
  #     train.delete()
  #     expect(City.all).to(eq([train2]))
  #   end
  # end

  describe('.search') do
    it("searches for a train by name") do
      train = City.new({:stop_name => "Bernina Express", :departure => "1:00", :id => nil})
      train.save()
      train2 = City.new({:stop_name => "Deltrain", :departure => "1:00", :id => nil})
      train2.save()
      train3 = City.new({:stop_name => "Deltrain3030", :departure => "1:00", :id => nil})
      train3.save()
      expect(City.search("deltrain")).to(eq([train2, train3]))
    end
  end

  describe('.sort') do
    it("sorts  by name") do
      train = City.new({:stop_name => "Bernina Express", :departure => "1:00", :id => nil})
      train.save()
      train2 = City.new({:stop_name => "Deltrain", :departure => "1:00", :id => nil})
      train2.save()
      train3 = City.new({:stop_name => "Darjeeling Limited", :departure => "1:00", :id => nil})
      train3.save()
      expect(City.sort()).to(eq([train, train3, train2]))
    end
  end

  describe('#update') do
    it("adds a train to a city") do
      city = City.new({:stop_name => "Bernina Express", :departure => "1:00", :id => nil})
      city.save()
      train = Train.new({:train_name => "Treyname", :id => nil})
      train.save()
      city.update({:train_name => "Treyname"})
      expect(city.trains).to(eq([train]))
    end
  end
  describe('#update') do
    it("creates a stop for an train") do
      city = City.new({:stop_name => "Madlib",:departure => "11:30", :id => nil})
      city.save()
      train = Train.new({:train_name => "A Love Supreme", :id => nil})
      train.save()
      city.update({:train_name => train.train_name, :stop_name => city.stop_name, :departure => "12:30"})
      expect(city.trains).to(eq([train]))
    end
  end
end
