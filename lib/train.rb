class Train

  attr_accessor :train_name
  attr_reader :id

  def initialize (attributes)
    @train_name = attributes.fetch(:train_name)
    @id = attributes.fetch(:id)
  end

  def self.get_trains
    returned_trains = DB.exec("SELECT * FROM trains;")
    trains = []
    returned_trains.each() do |train|
      train_name = train.fetch('train_name')
      id = train.fetch('id').to_i
      trains.push(Train.new({:train_name => train_name, :id => id}))
    end
    trains
  end

  def self.all
    self.get_trains
  end

  # def self.all_sold
  #   self.get_trains ('SELECT * FROM sold_trains;')
  # end

  def save
    result = DB.exec("INSERT INTO trains (train_name) VALUES ('#{@train_name}') RETURNING id;")
    @id = result.first().fetch('id').to_i
  end

  def ==(train_to_compare)
    if train_to_compare != nil
      self.train_name() == train_to_compare.train_name && self.id == train_to_compare.id
    else
      false
    end
  end

  def self.clear
    DB.exec("DELETE FROM trains *;")
  end

  def self.find(id)
    train = DB.exec("SELECT * FROM trains WHERE id = #{id};").first
    train_name = train.fetch('train_name')
    id = train.fetch('id').to_i
    Train.new({:train_name => train_name, :id => id})
  end

  def self.search(search)
    self.get_trains ("SELECT * FROM trains WHERE lower(train_name) LIKE '%#{search}%';")
  end

  def update(attributes)
    if (attributes.has_key?(:train_name)) && (attributes.fetch(:train_name) != '')
      @train_name = attributes.fetch(:train_name)
      DB.exec("UPDATE trains SET train_name = '#{@train_name}' WHERE id = #{@id};")
    end
    stop_name = attributes.fetch(:stop_name)
    if stop_name != nil
      city = DB.exec("SELECT * FROM cities WHERE lower(stop_name) =  '#{stop_name.downcase}';").first
      if city == nil
        new_city = Train.new({:stop_name => "#{stop_name}", :departure => "#{departure}", :id => nil})
        new_city.save()
        city = DB.exec("SELECT * FROM cities WHERE id = #{new_city.id};").first
      end
      DB.exec("INSERT INTO trains_cities (cities_id, trains_id) VALUES (#{city['id'].to_i}, #{@id});")
    end
  end

  def self.sort()
    self.get_trains ('SELECT * FROM trains ORDER BY lower(train_name);')
  end

  def delete
    DB.exec("DELETE FROM trains_cities WHERE train_id = #{@id};")
    DB.exec("DELETE FROM trains WHERE id = #{@id};")
  end

  # def sold
  #   result = DB.exec("INSERT INTO sold_trains (train_name) VALUES ('#{@train_name}') RETURNING id;")
  #   @id = result.first().fetch('id').to_i
  #   DB.exec("DELETE FROM trains WHERE id = #{@id};")
  # end
  #
  # def songs
  #   Song.find_by_train(self.id)
  # end

  def self.random
    self.get_trains ('SELECT * FROM trains ORDER BY RAND() LIMIT 1;')
  end

  def cities
    results = DB.exec("SELECT cities_id FROM trains_cities WHERE trains_id = #{@id}")
    id_string = results.map{ |result| result.fetch("cities_id")}.join(', ')
    (id_string != '') ?
    City.get_cities("SELECT * FROM cities WHERE id IN (#{id_string});") :
    nil
  end
end
