RSpec.describe "Map Lemma to Bible Verse", type: :feature do
  book_map = {
    numbers: {
      "01": "Matthew",
      "02": "Mark",
      "03": "Luke",
      "04": "John",
      "05": "Acts",
      "06": "Romans",
      "07": "1 Corinthians",
      "08": "2 Corinthians",
      "09": "Galatians",
      "10": "Ephesians",
      "11": "Philippians",
      "12": "Colossians",
      "13": "1 Thessalonians",
      "14": "2 Thessalonians",
      "15": "1 Timothy",
      "16": "2 Timothy",
      "17": "Titus",
      "18": "Philemon",
      "19": "Hebrews",
      "20": "James",
      "21": "1 Peter",
      "22": "2 Peter",
      "23": "1 John",
      "24": "2 John",
      "25": "3 John",
      "26": "Jude",
      "27": "Revelation"
    },
    abbreviations: {
      "Mt": "Matthew",
      "Mk": "Mark",
      "Lk": "Luke",
      "Jn": "John",
      "Ac": "Acts",
      "Ro": "Romans",
      "1Co": "1 Corinthians",
      "2Co": "2 Corinthians",
      "Ga": "Galatians",
      "Eph": "Ephesians",
      "Php": "Philippians",
      "Col": "Colossians",
      "1Th": "1 Thessalonians",
      "2Th": "2 Thessalonians",
      "1Ti": "1 Timothy",
      "2Ti": "2 Timothy",
      "Tit": "Titus",
      "Phm": "Philemon",
      "Heb": "Hebrews",
      "Jas": "James",
      "1Pe": "1 Peter",
      "2Pe": "2 Peter",
      "1Jn": "1 John",
      "2Jn": "2 John",
      "3Jn": "3 John",
      "Jud": "Jude",
      "Re": "Revelation"
    }
  }
  it "1. Create bible.json" do
    bible_hash = {}
    book_map[:numbers].each_key do |book_number|
      book_index = book_number.to_s.to_i
      filename = "#{60 + book_index}-#{book_map[:abbreviations].keys[book_index - 1]}.txt"

      File.open("./private_data/SBLGNTtxt/#{filename}") do |file|
        line_number = 0
        file.each do |line|
          line_number += 1
          if line_number == 1
            next
          end
          next if line.strip.empty?
          components = line.strip.split("\t")
          book_abbrev, chapter_verse = components[0].split(' ')
          chapter, verse = chapter_verse.split(':')
          verse_text = components[1]

          book_name = book_map[:abbreviations][book_abbrev.to_sym]
          bible_hash[book_name] = {} if bible_hash[book_name].nil?
          bible_hash[book_name][chapter] = {} if bible_hash[book_name][chapter].nil?
          bible_hash[book_name][chapter][verse] = verse_text
        end
      end
    end

    puts bible_hash.to_json
    File.write('bible.json', JSON.dump(bible_hash))
  end

  it "2. Create Lemma Example Files" do
    lemma_to_reference_map = {}
    book_map[:numbers].each_key do |book_number|
      book_index = book_number.to_s.to_i
      filename = "#{60 + book_index}-#{book_map[:abbreviations].keys[book_index - 1]}-morphgnt.txt"

      File.open("./private_data/SBLGNTmorph/#{filename}") do |file|
        file.each do |line|
          components = line.split(' ')
          book = components[0][0..1]
          chapter = components[0][2..3].to_i
          verse = components[0][4..6].to_i
          lemma = components[6]
          # puts "#{book} #{chapter}:#{verse} #{lemma}"

          next unless lemma_to_reference_map[lemma].nil?
          lemma_to_reference_map[lemma] = {
            book: book_map[:numbers][book.to_sym],
            chapter: chapter,
            verse: verse
          }
        end
      end
    end

    bible_json = JSON.parse(File.read("bible.json"))
    lemma_to_verse_map = {}

    tabbed_data = []
    lemma_to_reference_map.each do |lemma, reference|
      lemma_to_verse_map[lemma] = {
        reference: "#{reference[:book]} #{reference[:chapter].to_s}:#{reference[:verse].to_s}",
        verse: bible_json[reference[:book]][reference[:chapter].to_s][reference[:verse].to_s]
      }

      tabbed_data.push("#{lemma}\t#{lemma_to_verse_map[lemma][:reference]}\t#{lemma_to_verse_map[lemma][:verse]}")
    end

    puts tabbed_data

    File.write('lemma-example-verses.json', JSON.dump(lemma_to_verse_map))
    File.write('lemma-example-verses.tsv', tabbed_data.join("\n"))
  end
end