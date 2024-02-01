def get_first_word_occurrence_map(filename)
  first_word_occurrence_key = {}
  File.open(filename) do |file|
    puts "file opened"
    file.each do |line|
      next if line.strip.empty?
      word_key, word = line.strip.split("\t")

      first_word_occurrence_key[word] = word_key if first_word_occurrence_key[word].nil?
    end
    puts "work done"
  end
  first_word_occurrence_key
end

def get_word_key_to_verse_map(filename)
  word_key_to_verse = {}
  File.open(filename) do |file|
    puts "file opened"
    file.each do |line|
      next if line.strip.empty?
      word_key, verse = line.strip.split("\t")

      word_key_to_verse[word_key] = verse if word_key_to_verse[word_key].nil?
    end
    puts "work done"
  end
  word_key_to_verse
end

def get_first_word_occurrence_data(book_abbreviations, first_word_occurrence_key, word_key_to_verse)
  first_word_occurrence = {}
  tabbed_data = []
  first_word_occurrence_key.each do |word, word_key|
    verse = word_key_to_verse[word_key]

    book, chap, verse_num = verse.split(".")
    book_name = book_abbreviations[book.to_sym].nil? ? book : book_abbreviations[book.to_sym]

    chap = "0" if chap == "Prolog" # Sirach has a prolog
    starting_verse = verse_num.split("/")[0].split("-")[0] # Apparently some verses were given a range like 11/13 or 60-62

    full_reference = book_name + " " + chap + ":" + starting_verse.tr('^0-9', '') # some verses had letters at the end

    first_word_occurrence[word] = full_reference
    tabbed_data.push("#{word}\t#{full_reference}\t#{word_key}")
  end
  return first_word_occurrence, tabbed_data
end

RSpec.describe "Map Lemma to LXX Bible Verse", type: :feature do
  book_abbreviations = {
    "Gen": "Genesis",
    "Exod": "Exodus",
    "Lev": "Leviticus",
    "Num": "Numbers",
    "Deut": "Deuteronomy",
    "Josh": "Joshua",
    "Judg": "Judges",
    "Ruth": "Ruth",
    "1Sam": "1 Samuel",
    "2Sam": "2 Samuel",
    "1Kgs": "1 Kings",
    "2Kgs": "2 Kings",
    "1Chr": "1 Chronicles",
    "2Chr": "2 Chronicles",
    "ezr": "Ezra",
    "neh": "Nehemiah",
    "Esth": "Esther",
    "Job": "Job",
    "Ps": "Psalms",
    "Prov": "Proverbs",
    "Eccl": "Ecclesiastes",
    "Qoh": "Ecclesiastes",
    "Song": "Song of Solomon",
    "Cant": "Song of Solomon",
    "Isa": "Isaiah",
    "Jer": "Jeremiah",
    "Lam": "Lamentations",
    "Ezek": "Ezekiel",
    "DanOG": "Daniel",
    "Dan": "Daniel",
    "Hos": "Hosea",
    "Joel": "Joel",
    "Amos": "Amos",
    "Obad": "Obadiah",
    "Jonah": "Jonah",
    "Mic": "Micah",
    "Nah": "Nahum",
    "Hab": "Habakkuk",
    "Zeph": "Zephaniah",
    "Hag": "Haggai",
    "Zech": "Zechariah",
    "Mal": "Malachi",
    "1Esd": "1 Esdras",
    "1Esdr": "1 Esdras",
    "2Esd": "2 Esdras",
    "2Esdr": "2 Esdras",
    "tob": "Tobias",
    "Jdt": "Judith",
    "aes": "Additions to Esther",
    "Wis": "Wisdom",
    "Bar": "Baruch",
    "EpJer": "Epistle of Jeremiah",
    "SusOG": "Susanna",
    "Sus": "Susanna",
    "BelOG": "Bel and the Dragon",
    "Bel": "Bel and the Dragon",
    "man": "Prayer of Manasseh",
    "1Macc": "1 Macabees",
    "1Mac": "1 Macabees",
    "2Macc": "2 Macabees",
    "2Mac": "2 Macabees",
    "3Macc": "3 Macabees",
    "3Mac": "3 Macabees",
    "4Macc": "4 Macabees",
    "4Mac": "4 Macabees",
    "Sir": "Sirach",
    "Sir": "Sirach",
    "aza": "Prayer of Azariah",
    "lao": "Laodiceans",
    "jsb": "Joshua B",
    "jsa": "Joshua A",
    "jdb": "Judges B",
    "jda": "Judges A",
    "TobBA": "Tobit BA",
    "TobS": "Tobit S",
    "PsSol": "Psalms of Solomon",
    "BelTh": "Bel and the Dragon Th",
    "DanTh": "Daniel Th",
    "SusTh": "Susanna Th",
    "Odes": "Odes",
    "Od": "Odes"
  }

  it "Creates a map of Words to LXX Verses" do
    first_word_occurrence_map = get_first_word_occurrence_map("./private_data/lxx/word-keys.csv")

    word_key_to_verse = get_word_key_to_verse_map("./private_data/lxx/word-key-to-verse.csv")

    first_word_occurrence, tabbed_data = get_first_word_occurrence_data(book_abbreviations, first_word_occurrence_map, word_key_to_verse)

    File.write('lxx-lemma-example-verses.json', JSON.dump(first_word_occurrence))
    File.write('lxx-lemma-example-verses.tsv', tabbed_data.join("\n"))
    puts "finished"
  end

  it "Creates a map of Unmarked Words to LXX Verses" do
    first_word_occurrence_map = get_first_word_occurrence_map("./private_data/lxx/word-keys-unmarked.csv")

    word_key_to_verse = get_word_key_to_verse_map("./private_data/lxx/word-key-to-verse.csv")

    first_word_occurrence, tabbed_data = get_first_word_occurrence_data(book_abbreviations, first_word_occurrence_map, word_key_to_verse)

    File.write('lxx-unmarked-lemma-example-verses.json', JSON.dump(first_word_occurrence))
    File.write('lxx-unmarked-lemma-example-verses.tsv', tabbed_data.join("\n"))
    puts "finished"
  end

  it "Removes all markings from Greek Characters" do
    word_list = []
    File.open("./private_data/lxx/lxx-words-accented.txt") do |file|
      puts "file opened"
      file.each do |line|
        next if line.strip.empty?
        word = line.strip
        unmarked_word = remove_markings(word)

        word_list.push(unmarked_word)
      end
      puts "work done"
    end

    File.write('lxx-words-unmarked.txt', word_list.join("\n"))
  end

end