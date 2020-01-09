class City
  attr_accessor :stop_name, :departure
  attr_reader :id

  def initialize(attributes)
    @stop_name = attributes.fetch(:stop_name)
    @departure = attributes.fetch(:departure)
    @id = attributes.fetch(:id)
  end

  def update(attributes)
  if (attributes.has_key?(:stop_name)) && (attributes.fetch(:stop_name) != '')
    @name = attributes.fetch(:stop_name)
    DB.exec("UPDATE cities SET stop_name = '#{@stop_name}' WHERE id = #{@id};")
  end
  train_name = attributes.fetch(:train_name)
  if train_name != nil
    train = DB.exec("SELECT * FROM trains WHERE lower(train_name) =  '#{train_name.downcase}';").first
    if train== nil
      new_train= Train.new({:train_name => "#{train_name}", :departure => "#{departure}", :id => nil})
      new_train.save()
      train= DB.exec("SELECT * FROM trains WHERE id = #{new_train.id};").first
    end
    DB.exec("INSERT INTO trains_cities (trains_id, cities_id) VALUES (#{train['id'].to_i}, #{@id});")
  end
end

  def self.get_cities(db_query)
    returned_cities = DB.exec(db_query)
    cities = []
    returned_cities.each() do |city|
      stop_name = city.fetch('stop_name')
      departure = city.fetch('departure')
      id = city.fetch('id').to_i
      cities.push(City.new({:stop_name => stop_name, :departure => departure, :id => id}))
    end
    cities
  end

  def self.all
    self.get_cities('SELECT * FROM cities;')
  end

  # def self.all_sold
  #   self.get_cities('SELECT * FROM sold_cities;')
  # end

  def save
    result = DB.exec("INSERT INTO cities (stop_name, departure) VALUES ('#{@stop_name}', '#{@departure}') RETURNING id;")
    @id = result.first().fetch('id').to_i
  end

  def ==(city_to_compare)
    self.stop_name() == city_to_compare.stop_name()
  end

  def self.clear
    DB.exec("DELETE FROM cities *;")
  end

  def self.find(id)
    city = DB.exec("SELECT * FROM cities WHERE id = #{id};").first
    stop_name = city.fetch('stop_name')
    departure = city.fetch('departure')
    id = city.fetch('id').to_i
    City.new({:stop_name => stop_name, :departure => departure, :id => id})
  end

  def self.search(search)
    self.get_cities("SELECT * FROM cities WHERE lower(stop_name) LIKE '%#{search}%';")
  end

  def self.sort()
    self.get_cities('SELECT * FROM cities ORDER BY lower(stop_name);')
  end

  def delete
    DB.exec("DELETE FROM trains_cities WHERE city_id = #{@id};")
    DB.exec("DELETE FROM cities WHERE id = #{@id};")
  end

  def trains
    results = DB.exec("SELECT trains_id FROM trains_cities WHERE cities_id = #{@id}")
    id_string = results.map{ |result| result.fetch("trains_id")}.join(', ')
    (id_string != '') ?
      Train.get_trains("SELECT * FROM trains WHERE id IN (#{id_string});") :
      nil
  end

  def self.random
    self.get_cities('SELECT * FROM cities ORDER BY RAND() LIMIT 1;')
  end
end
