class Train

  attr_accessor :train_name
  attr_reader :id

  def initialize (attributes)
    @train_name = attributes.fetch(:train_name)
    @id = attributes.fetch(:id)
  end

  def self.get_trains(db_query)
    returned_trains = DB.exec(db_query)
    trains = []
    returned_trains.each() do |train|
      train_name = train.fetch('train_name')
      id = train.fetch('id').to_i
      trains.push(Train.new({:train_name => train_name, :id => id}))
    end
    trains
  end

  def self.all
    self.get_trains ('SELECT * FROM trains;')
  end

  def self.all_sold
    self.get_trains ('SELECT * FROM sold_trains;')
  end

  def save
    result = DB.exec("INSERT INTO trains (train_name) VALUES ('#{@train_name}') RETURNING id;")
    @id = result.first().fetch('id').to_i
  end

  def ==(train_to_compare)
    self.train_name() == train_to_compare.train_name()
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
      DB.exec("UPDATE trains SET name = '#{@train_name}' WHERE id = #{@id};")
    end
    artist_name = attributes.fetch(:artist_name)
    if artist_name != nil
      artist = DB.exec("SELECT * FROM artists WHERE lower(name) =  '#{artist_name.downcase}';").first
      if artist == nil
        new_artist = train.new({:name => "#{artist_name}", :id => nil})
        new_artist.save()
        artist = DB.exec("SELECT * FROM artists WHERE id = #{new_artist.id};").first
      end
      DB.exec("INSERT INTO trains_artists (artist_id, train_id) VALUES (#{artist['id'].to_i}, #{@id});")
    end
  end

  def self.sort()
    self.get_trains ('SELECT * FROM trains ORDER BY lower(train_name);')
  end

  def delete
    DB.exec("DELETE FROM trains_cities WHERE train_id = #{@id};")
    DB.exec("DELETE FROM trains WHERE id = #{@id};")
  end

  def sold
    result = DB.exec("INSERT INTO sold_trains (train_name) VALUES ('#{@train_name}') RETURNING id;")
    @id = result.first().fetch('id').to_i
    DB.exec("DELETE FROM trains WHERE id = #{@id};")
  end

  def songs
    Song.find_by_train(self.id)
  end

  def self.random
    self.get_trains ('SELECT * FROM trains ORDER BY RAND() LIMIT 1;')
  end

  def artists
    results = DB.exec("SELECT artist_id FROM trains_artists WHERE train_id = #{@id}")
    id_string = results.map{ |result| result.fetch("artist_id")}.join(', ')
    (id_string != '') ?
    Artist.get_artists("SELECT * FROM artists WHERE id IN (#{id_string});") :
    nil
  end
end
