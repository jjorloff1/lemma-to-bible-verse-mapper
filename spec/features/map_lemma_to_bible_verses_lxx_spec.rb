RSpec.describe "Map Lemma to Bible Verse", type: :feature do
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
    "Song": "Song of Solomon",
    "Isa": "Isaiah",
    "Jer": "Jeremiah",
    "Lam": "Lamentations",
    "Ezek": "Ezekiel",
    "DanOG": "Daniel",
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
    "2Esd": "2 Esdras",
    "tob": "Tobias",
    "Jdt": "Judith",
    "aes": "Additions to Esther",
    "Wis": "Wisdom",
    "Bar": "Baruch",
    "EpJer": "Epistle of Jeremiah",
    "SusOG": "Susanna",
    "BelOG": "Bel and the Dragon",
    "man": "Prayer of Manasseh",
    "1Macc": "1 Macabees",
    "2Macc": "2 Macabees",
    "3Macc": "3 Macabees",
    "4Macc": "4 Macabees",
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
    "Odes": "Odes"
  }

  it "Creates a map of Words to LXX Verses" do
    first_word_occurrence_key = {}
    File.open("./private_data/lxx/word-keys.csv") do |file|
      puts "file opened"
      file.each do |line|
        next if line.strip.empty?
        word_key, word = line.strip.split("\t")

        first_word_occurrence_key[word] = word_key if first_word_occurrence_key[word].nil?
      end
      puts "work done"
    end

    word_key_to_verse = {}
    File.open("./private_data/lxx/word-key-to-verse.csv") do |file|
      puts "file opened"
      file.each do |line|
        next if line.strip.empty?
        word_key, verse = line.strip.split("\t")

        word_key_to_verse[word_key] = verse if word_key_to_verse[word_key].nil?
      end
      puts "work done"
    end

    first_word_occurrence = {}
    tabbed_data = []
    first_word_occurrence_key.each do |word, word_key|
      verse = word_key_to_verse[word_key]

      book, chap, verse_num = verse.split(".")
      book_name = book_abbreviations[book.to_sym].nil? ? book : book_abbreviations[book.to_sym]
      full_reference = book_name + " " + chap + ":" + verse_num

      first_word_occurrence[word] = full_reference
      tabbed_data.push("#{word}\t#{full_reference}")
    end


    File.write('lxx-lemma-example-verses.json', JSON.dump(first_word_occurrence))
    File.write('lxx-lemma-example-verses.tsv', tabbed_data.join("\n"))
    puts "finished"
  end

end