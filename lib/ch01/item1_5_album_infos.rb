album_infos = 100.times.flat_map do |i|
  10.times.map do |j|
    ["Album #{i}", j, "Artist #{j}"]
  end
end

def transfer_to_hash_database(album_infos)
  album_hash = Hash.new {|hash, key| hash[key] = []}
  album_song_number_hash = Hash.new {|hash, key| hash[key] = []}

  album_infos.each do |album_name, song_number, artist|
    album_hash[album_name] << song_number
    album_song_number_hash[[album_name, song_number]] << artist
  end
end

transfer_to_hash_database(album_infos)